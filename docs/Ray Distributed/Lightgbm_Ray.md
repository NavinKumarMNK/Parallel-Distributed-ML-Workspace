<!--$UNCOMMENT(lightgbm-ray)=-->

# Distributed LightGBM on Ray
<!--$REMOVE-->
![Build Status](https://github.com/ray-project/lightgbm_ray/workflows/pytest%20on%20push/badge.svg)
[![docs.ray.io](https://img.shields.io/badge/docs-ray.io-blue)](https://docs.ray.io/en/master/lightgbm-ray.html)
<!--$END_REMOVE-->
LightGBM-Ray is a distributed backend for
[LightGBM](https://lightgbm.readthedocs.io/), built
on top of
[distributed computing framework Ray](https://ray.io).

LightGBM-Ray

- enables [multi-node](#usage) and [multi-GPU](#multi-gpu-training) training
- integrates seamlessly with distributed [hyperparameter optimization](#hyperparameter-tuning) library [Ray Tune](http://tune.io)
- comes with [fault tolerance handling](#fault-tolerance) mechanisms, and
- supports [distributed dataframes and distributed data loading](#distributed-data-loading)

All releases are tested on large clusters and workloads.

This package is based on <!--$UNCOMMENT{ref}`XGBoost-Ray <xgboost-ray>`--><!--$REMOVE-->[XGBoost-Ray](https://github.com/ray-project/xgboost_ray)<!--$END_REMOVE-->. As of now, XGBoost-Ray is a dependency for LightGBM-Ray.

## Installation

You can install the latest LightGBM-Ray release from PIP:

```bash
pip install "lightgbm_ray"
```

If you'd like to install the latest master, use this command instead:

```bash
pip install "git+https://github.com/ray-project/lightgbm_ray.git#egg=lightgbm_ray"
```

## Usage

LightGBM-Ray provides a drop-in replacement for LightGBM's `train`
function. To pass data, a `RayDMatrix` object is required, common
with XGBoost-Ray. You can also use a scikit-learn
interface - see next section.

Just as in original `lgbm.train()` function, the 
[training parameters](https://lightgbm.readthedocs.io/en/latest/Parameters.html)
are passed as the `params` dictionary.

Ray-specific distributed training parameters are configured with a
`lightgbm_ray.RayParams` object. For instance, you can set
the `num_actors` property to specify how many distributed actors
you would like to use.

Here is a simplified example (which requires `sklearn`):

**Training:**

```python
from lightgbm_ray import RayDMatrix, RayParams, train
from sklearn.datasets import load_breast_cancer

train_x, train_y = load_breast_cancer(return_X_y=True)
train_set = RayDMatrix(train_x, train_y)

evals_result = {}
bst = train(
    {
        "objective": "binary",
        "metric": ["binary_logloss", "binary_error"],
    },
    train_set,
    evals_result=evals_result,
    valid_sets=[train_set],
    valid_names=["train"],
    verbose_eval=False,
    ray_params=RayParams(num_actors=2, cpus_per_actor=2))

bst.booster_.save_model("model.lgbm")
print("Final training error: {:.4f}".format(
    evals_result["train"]["binary_error"][-1]))
```

**Prediction:**

```python
from lightgbm_ray import RayDMatrix, RayParams, predict
from sklearn.datasets import load_breast_cancer
import lightgbm as lgbm

data, labels = load_breast_cancer(return_X_y=True)

dpred = RayDMatrix(data, labels)

bst = lgbm.Booster(model_file="model.lgbm")
pred_ray = predict(bst, dpred, ray_params=RayParams(num_actors=2))

print(pred_ray)
```

### scikit-learn API

LightGBM-Ray also features a scikit-learn API fully mirroring pure
LightGBM scikit-learn API, providing a completely drop-in
replacement. The following estimators are available:

- `RayLGBMClassifier`
- `RayLGBMRegressor`

Example usage of `RayLGBMClassifier`:

```python
from lightgbm_ray import RayLGBMClassifier, RayParams
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split

seed = 42

X, y = load_breast_cancer(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, train_size=0.25, random_state=42)

clf = RayLGBMClassifier(
    n_jobs=2,  # In LightGBM-Ray, n_jobs sets the number of actors
    random_state=seed)

# scikit-learn API will automatically convert the data
# to RayDMatrix format as needed.
# You can also pass X as a RayDMatrix, in which case
# y will be ignored.

clf.fit(X_train, y_train)

pred_ray = clf.predict(X_test)
print(pred_ray)

pred_proba_ray = clf.predict_proba(X_test)
print(pred_proba_ray)

# It is also possible to pass a RayParams object
# to fit/predict/predict_proba methods - will override
# n_jobs set during initialization

clf.fit(X_train, y_train, ray_params=RayParams(num_actors=2))

pred_ray = clf.predict(X_test, ray_params=RayParams(num_actors=2))
print(pred_ray)
```

- For more details on the paramter, Refer : [Ray Documentation](https://github.com/ray-project/lightgbm_ray)