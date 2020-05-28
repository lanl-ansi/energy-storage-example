# energy-storage-example

This repository includes an example of how PowerModels and PowerModelsDistribution can be used to solve multi-period and multi-phase energy storage optimization models.

* comp-model.jl - generates solution data from solving storage optimization with AC, DC and SOC power flow models
* comp-phase.jl - generates solution data for solving storage optimization with single-phase AC and multi-phase AC
* common.jl - features shared across `comp` files
* plot-model.r - generates plots comparing storage optimization models
* plot-phase.r - generates plots comparing single-phase to multi-phase optimization models
* plot-single.r - generates plots of data from a single model, used for debugging


## Technical Report

This example was developed to validate the storage model proposed in the following [publication](https://arxiv.org/abs/2004.14768) for use in [PowerModels.jl](https://lanl-ansi.github.io/PowerModels.jl/stable/storage/) and [PowerModelsDistribution.jl](https://github.com/lanl-ansi/PowerModelsDistribution.jl):
```
@misc{2004.14768,
  author = {Frederik Geth and Carleton Coffrin and David M. Fobes},
  title = {A Flexible Storage Model for Power Network Optimization},
  month = {april},
  year = {2020},
  eprint = {arXiv:2004.14768},
  url = {https://arxiv.org/abs/2004.14768}
}
```

## License

This code is provided under a BSD license as part of the Multi-Infrastructure Control and Optimization Toolkit (MICOT) project, LA-CC-13-108.
