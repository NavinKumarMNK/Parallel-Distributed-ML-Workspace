# Using Pytorch Lightning with DeepSpeed

To use DeepSpeed with Pytorch Lightning, you need to add the following to your training script:

```python
model = SampleModel()
dataset = SampleDataset()

from pytorch_lightning import Trainer

trainer = Trainer(**Trainer Parameters, 
                    callbacks=callbacks,
                    logger=logger,
		            accelerator='gpu',
                    strategy='deepspeed_stage_1',
		            num_nodes=4,
                    log_every_n_steps=5,
                    )

trainer.fit(model, dataset)
```

## Trainer Parameters 

The following are the parameters that you can pass to the Trainer if you were working on 100-200 M paramter model of 100 GB of dataset :

```conf
max_epochs = 50
min_epochs = 20
#accelerator = gpu
benchmark = True
weights_summary = full
precision = 16
auto_lr_find = True
auto_scale_batch_size = True
auto_select_gpus = True
check_val_every_n_epoch = 1
fast_dev_run = False
enable_progress_bar = True
accumulate_grad_batches=16
sync_batchnorm=True
limit_train_batches=0.1
limit_val_batches=0.1
num_sanity_val_steps=0
```

- Balance the accumulate_grad_batches and batch_size parmater such that it can fit the model & data into the GPU memory. Increasing the accumulate_grad_batch speeds up the training, without increasing the memory usage.

## Distributed Run

```
export node_rank=<number>
```
starting from 0 to number of nodes - 1 assign the rank to each nodes. And run the following command in all the nodes :

```bash

python -m torch.distributed.run --nnodes=<no-of-nodes>  --nproc_per_node=<no-of-gpus-per-node> -node_rank=$node_rank --master_addr=<master-node-ip>  model.py 
```

Example : -

```bash
python -m torch.distributed.run --nnodes=4 --nproc_per_node=1 --node_rank=$node_rank    --master_addr=172.16.96.60 models/EfficientNetv2.py 
```
