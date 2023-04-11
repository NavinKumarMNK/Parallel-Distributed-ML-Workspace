{!README.md!}

- For GPU computing the bandwith between the nodes should be high, with the 1gb bandwidth between the nodes, there is very less improvement in model/data parallel training.

- 4 nodes gives the best performance for the model/data parallel training. After testing almost there is an decrease of 1.75x in the training time. And the time taken for an epoch decreases.

- You should ensure that all the system have same high specs and python & package version. Because a sinlge slow working system can cause the whole cluster to slow down drastically.

- Its better to scale the ray cluster using Auto Scaling Serivce provided by Ray.

