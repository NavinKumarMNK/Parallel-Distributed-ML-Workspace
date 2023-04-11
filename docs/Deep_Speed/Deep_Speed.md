# Deep Speed Model Training 

DeepSpeed is a deep learning optimization library that makes distributed training easy, efficient, and effective. It has been engineered from the ground up to provide significant speedups for both training and inference. DeepSpeed is optimized for NVIDIA GPUs and is based on PyTorch.

## DeepSpeed Features

* **ZeRO**: Zero Redundancy Optimizer is a novel memory optimization technique that reduces GPU memory requirements by overlapping optimizer memory across multiple GPUs. ZeRO is a key component of DeepSpeed that enables training large models and using larger batch sizes. ZeRO is available in two modes: ZeRO-Offload and ZeRO-2. ZeRO-Offload moves optimizer states to the host memory while ZeRO-2 overlaps optimizer state across multiple GPUs. ZeRO-Offload is currently supported on NVIDIA Volta and Turing GPUs. ZeRO-2 is supported on NVIDIA Volta, Turing, and Ampere GPUs. For more information, see [ZeRO: Memory Optimizations Toward Training Trillion Parameter Models, by Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He](https://arxiv.org/abs/1910.02054).

* **Fused Adam**: Fused Adam is a fused kernel implementation of the Adam optimizer that is up to 4x faster than the Adam optimizer in PyTorch. For more information, see [Fused Adam: Improving Performance and Reducing Memory Requirements of Adam, by Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He](https://arxiv.org/abs/2006.08217).

* **Fused LAMB**: Fused LAMB is a fused kernel implementation of the LAMB optimizer that is up to 2x faster than the LAMB optimizer in PyTorch. For more information, see [Fused LAMB: Improving Performance and Reducing Memory Requirements of LAMB, by Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He](https://arxiv.org/abs/2006.08217).

* **Fused Layer Norm**: Fused Layer Norm is a fused kernel implementation of the Layer Normalization layer that is up to 3x faster than the Layer Normalization layer in PyTorch. For more information, see [Fused Layer Norm: Improving Performance and Reducing Memory Requirements of Layer Normalization, by Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He](https://arxiv.org/abs/2006.08217).

* **Fused Softmax**: Fused Softmax is a fused kernel implementation of the Softmax layer that is up to 2x faster than the Softmax layer in PyTorch. For more information, see [Fused Softmax: Improving Performance and Reducing Memory Requirements of Softmax, by Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He](https://arxiv.org/abs/2006.08217).

## Installation

To install DeepSpeed, run the following command:

```bash 
pip install deepspeed
```

## Usage

To use DeepSpeed, you need to add the following to your training script:

```python
import deepspeed

model_engine, optimizer, _, _ = deepspeed.initialize(
    args=args,
    model=model,
    model_parameters=model_parameters,
    training_data=training_data,
    lr_scheduler=lr_scheduler,
    mpu=mpu,
    dist_init_required=False)
```



