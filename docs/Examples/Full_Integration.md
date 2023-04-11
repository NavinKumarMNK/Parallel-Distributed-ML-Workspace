# PyTorch Ray Distributed + Wandb Integration
## Code For Integrating Ray Train, Pytorch Lightning, Wandb

For a complete Code for Integration Ray Train, Pytorch Lightning & Wandb, check this [[**here**]](https://github.com/NavinKumarMNK/Parallel-Distributed-ML-Workspace/blob/main/examples/full_integration.py) out. The Following is the code Snippet for the same. Here we look at the generalized way of writing the code so you can use it both for Ray Train Distributed as well as DeepSpeed Distributed Training.

```
'@Author:NavinKumarMNK'
import sys
import os
import torch
import torch.nn as nn
import torch.nn.functional as F
import wandb
import torch.nn as nn
import pytorch_lightning as pl
import ray_lightning as rl

pl.seed_everything(42) # Set the seed for reproducibility
    
class PyTorchModel(pl.LightningModule):
    def __init__(self, **parmas) -> None:
        super(VariationalAutoEncoder, self).__init__()
        ## Setup the needed paramters for the model
        self.example_input_array = ...
        self.model = nn.Sequential(
            ...
        )


    def forward(self, x):
        ## Forward pass of the model, returns the output of the model
        x = self.model(x)
        return x

    def loss_function(self, y, y_hat):
        # Define the custom loss function for your problem
        loss = nn.CrossEntropyLoss(y_hat, y) 
        self.log("Total loss", loss)
        return loss

    def training_step(self, batch, batch_idx):
        # this function defines the procedure for each training step
        x, y = batch
        y_hat = self(x)
        loss = self.loss_function(y, y_hat)
        # Default Logger Provided by Pytorch Lightning, when Wandb Plugins is used this logs into wandb
        self.log('train_loss', loss)  
        return {"loss" : loss}

    def training_epoch_end(self, outputs)-> None:
        # Provides the prcedure for the end of each train epoch
        loss = outputs[0]['loss']
        avg_loss = torch.stack([x['loss'] for x in loss]).mean()
        self.log('train/loss_epoch', avg_loss)

    def validation_step(self, batch, batch_idx):
        # this function defines the procedure for each validation step
        x, y = batch
        y_hat = self(x)
        loss = self.loss_function(x_hat, y, mu, log_var)
        self.log('val_loss', loss)
        return {"val_loss": loss, "y_hat": x_hat, "y": y}

    def validation_epoch_end(self, outputs)-> None:
        # Provides the prcedure for the end of each validation epoch
        loss, y_hat, y = outputs[0]['val_loss'], outputs[0]['y_hat'], outputs[0]['y']
        avg_loss = torch.stack([x['loss'] for x in loss]).mean()
        self.log('val/loss_epoch', avg_loss)
        
        # validation loss is less than previous epoch then save the model
        elif (avg_loss < self.best_val_loss):
            self.best_val_loss = avg_loss
            self.save_model()

    def test_step(self, batch, batch_idx):
        # this function defines the procedure for each test step
        x, y = batch
        x_hat, mu, log_var = self(x)
        loss = self.loss_function(x_hat, y, mu, log_var)
        self.log('test_loss', loss)
        return {"test_loss": loss, "y_hat": x_hat, "y": y}

    def test_epoch_end(self, outputs)-> None:
        # Provides the prcedure for the end of each test epoch
        loss, y_hat, y = outputs[0]['test_loss'], outputs[0]['y_hat'], outputs[0]['y']
        avg_loss = torch.stack([x['loss'] for x in loss]).mean()
        self.log('test/loss_epoch', avg_loss)

    def save_model(self):
        # Save the model
        torch.save(self.state_dict(), "auto_encoder_model.cpkt")
        artifact = wandb.Artifact('auto_encoder_model.cpkt', type='model')
        wandb.run.log_artifact(artifact)

    def print_params(self): 
        print("Model Parameters:")
        for name, param in self.named_parameters():
            if param.requires_grad:
                print(name, param.data.shape)

    def configure_optimizers(self):
        # Define the optimizer for the model
        optimizer = torch.optim.Adam(self.parameters(), lr=0.0001)
        return [optimizer]
        
    def prediction_step(self, batch, batch_idx, dataloader_idx=None):
        # this function defines the procedure for each prediction step
        x, y = batch
        y_hat = self(x)
        return y_hat

class CustomCallback(Callback):
    ...

def train():
    # Pytorch Wandb Logger
    logger = WandbLogger(project='CrimeDetection3', name='VariationalAutoEncoder')
    
    # Intialize the Wandb, Ray and Pytorch Lightning
    ray.init(runtime_env={"working_dir": utils.ROOT_PATH})
    wandb.init()
    
    # Setup the Dataset
    dataset = Dataset()
    dataset.setup()
    
    # Pytorch Lightning Callbacks
    ... 

    callbacks = [
        ...                 # Declare the callbacks
        CustomCallback()
    ]

    model = PyTorchModel()
    
    # Setup the Distributed Training Method
    dist_env_params = {'horovod': 0, 'deep_speed': 0, 'model_parallel': 0, 'data_parallel': 0, 'use_gpu': 0, 'num_workers': 0, 'num_cpus_per_worker': 0}

    strategy = None
    if int(dist_env_params['horovod']) == 1:
        strategy = rl.HorovodRayStrategy(use_gpu=dist_env_params['use_gpu'],
                                        num_workers=dist_env_params['num_workers'],
                                        num_cpus_per_worker=dist_env_params['num_cpus_per_worker'])
    elif int(dist_env_params['deep_speed']) == 1:
        strategy = 'deepspeed_stage_1'
    elif int(dist_env_params['model_parallel']) == 1:
        strategy = rl.RayShardedStrategy(use_gpu=dist_env_params['use_gpu'],
                                        num_workers=dist_env_params['num_workers'],
                                        
                                        num_cpus_per_worker=dist_env_params['num_cpus_per_worker'])
    elif int(dist_env_params['data_parallel']) == 1:
        strategy = rl.RayStrategy(use_gpu=dist_env_params['use_gpu'],
                                        num_workers=dist_env_params['num_workers'],
                                        num_cpus_per_worker=dist_env_params['num_cpus_per_worker'])
    
    trainer = Trainer(**autoencoder_params, 
                callbacks=callbacks, 
                strategy=strategy,
                accelerator='gpu',
                logger=logger,
                log_every_n_steps=5
                )
    
    trainer.fit(model, dataset)
    model.save_model()
    wandb.finish()

if __name__ == '__main__':
    train()    
```