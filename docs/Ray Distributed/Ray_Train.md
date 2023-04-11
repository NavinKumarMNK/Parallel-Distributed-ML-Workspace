# Ray Distributed Model Training 

- Run the following command to start the cluster. 
```bash
ray up [OPTIONS] CLUSTER_CONFIG_FILE
```
**Head Node**
- Run the following program in the head node to start the ray cluster.

```bash
ray start --head --dashboard-port 8000
```

**Worker Node**
- Run the following command in all the worker nodes to connect to the head node.
```bash
ray start --address="ipaddress:port"
```

- Run the following command to check the status of the cluster.
```bash
ray status
```

!!! Note

    Also install prometheus and grafana to monitor the cluster. 
    [Prometheus](https://prometheus.io/docs/prometheus/latest/installation/) [Grafana](https://grafana.com/docs/grafana/latest/installation/)

## Model Training 

**Example**

```python
import torch
import torch.nn as nn

import ray
from ray import train
from ray.air import session, Checkpoint
from ray.train.torch import TorchTrainer
from ray.air.config import ScalingConfig
from ray.air.config import RunConfig
from ray.air.config import CheckpointConfig

# If using CPU, set this to False.
use_gpu = True

# Define NN layers archicture, epochs, and number of workers
input_size = 1
layer_size = 32
output_size = 1
num_epochs = 200
num_workers = 3

# Define your network structure
class NeuralNetwork(nn.Module):
    def __init__(self):
        super(NeuralNetwork, self).__init__()
        self.layer1 = nn.Linear(input_size, layer_size)
        self.relu = nn.ReLU()
        self.layer2 = nn.Linear(layer_size, output_size)

    def forward(self, input):
        return self.layer2(self.relu(self.layer1(input)))

# Define your train worker loop
def train_loop_per_worker():

    # Fetch training set from the session
    dataset_shard = session.get_dataset_shard("train")
    model = NeuralNetwork()

    # Loss function, optimizer, prepare model for training.
    # This moves the data and prepares model for distributed
    # execution
    loss_fn = nn.MSELoss()
    optimizer = torch.optim.Adam(model.parameters(),
                lr=0.01,
                weight_decay=0.01)
    model = train.torch.prepare_model(model)

    # Iterate over epochs and batches
    for epoch in range(num_epochs):
        for batches in dataset_shard.iter_torch_batches(batch_size=32,
                    dtypes=torch.float, device=train.torch.get_device()):

            # Add batch or unsqueeze as an additional dimension [32, x]
            inputs, labels = torch.unsqueeze(batches["x"], 1), batches["y"]
            output = model(inputs)

            # Make output shape same as the as labels
            loss = loss_fn(output.squeeze(), labels)

            # Zero out grads, do backward, and update optimizer
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            # Print what's happening with loss per 30 epochs
            if epoch % 20 == 0:
                print(f"epoch: {epoch}/{num_epochs}, loss: {loss:.3f}")

        # Report and record metrics, checkpoint model at end of each
        # epoch
        session.report({"loss": loss.item(), "epoch": epoch},
                             checkpoint=Checkpoint.from_dict(
                             dict(epoch=epoch, model=model.state_dict()))
        )

torch.manual_seed(42)
train_dataset = ray.data.from_items(
    [{"x": x, "y": 2 * x + 1} for x in range(200)]
)

# Define scaling and run configs
scaling_config = ScalingConfig(num_workers=3, use_gpu=use_gpu)
run_config = RunConfig(checkpoint_config=CheckpointConfig(num_to_keep=1))

trainer = TorchTrainer(
    train_loop_per_worker=train_loop_per_worker,
    scaling_config=scaling_config,
    run_config=run_config,
    datasets={"train": train_dataset})

result = trainer.fit()

best_checkpoint_loss = result.metrics['loss']

# Assert loss is less 0.09
assert best_checkpoint_loss <= 0.09

```