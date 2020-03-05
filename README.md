# energy-storage-example

This repository includes an example of how PowerModels can be used to solve a variety of multi-period energy storage optimization models.

* comp-model.jl - generates solution data from solving storage optimization with AC, DC and SOC power flow models
* comp-phase.jl - generates solution data for solving storage optimization with single-phase AC and multi-phase AC
* common.jl - features shared across `comp` files
* plot-model.r - generates plots comparing storage optimization models
* plot-phase.r - generates plots comparing single-phase to multi-phase optimization models
* plot-single.r - generates plots of data from a single model, used for debugging

## License

This code is provided under a BSD license as part of the Multi-Infrastructure Control and Optimization Toolkit (MICOT) project, LA-CC-13-108.
