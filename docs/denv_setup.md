Distributed Environment Setup
=====

Installation
------------

To use para-dist-workspace, first install it using pip:

```console
(.venv) $ pip install para-dist-workspace
```

Creating recipes
----------------

To retrieve a list of random ingredients, you can use the
`para-dist-workspace.get_random_ingredients()` function:

::: para-dist-workspace.get_random_ingredients
    options:
      show_root_heading: true

<br>

The `kind` parameter should be either `"meat"`, `"fish"`, or `"veggies"`.
Otherwise, [`get_random_ingredients`][para-dist-workspace.get_random_ingredients] will raise an exception [`para-dist-workspace.InvalidKindError`](/api#para-dist-workspace.InvalidKindError).

For example:

```python
>>> import para-dist-workspace
>>> para-dist-workspace.get_random_ingredients()
['shells', 'gorgonzola', 'parsley']
```