[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://elicheamshapiro.github.io/Schularick_Taylor_2012_Replication.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://elicheamshapiro.github.io/Schularick_Taylor_2012_Replication.jl/dev/)
[![Build Status](https://github.com/elicheamshapiro/Schularick_Taylor_2012_Replication.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/elicheamshapiro/Schularick_Taylor_2012_Replication.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/elicheamshapiro/Schularick_Taylor_2012_Replication.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/elicheamshapiro/Schularick_Taylor_2012_Replication.jl)

# Replication of Schularick and Taylor (2012) in Julia
# By Eli Cheam Shapiro

## Overview
The replication was project created for the Computational Economics PhD course taught by Dr. Florian Oswald at Sciences Po, Paris in the Fall semester of 2024: https://floswald.github.io/NumericalMethods/

This repository contains a Julia-based replication of the seminal paper "Credit Booms Gone Bust: Monetary Policy, Leverage Cycles, and Financial Crises, 1870-2008" by Moritz Schularick and Alan M. Taylor (AER 2012), which examines the long-run relationships between credit growth and financial crises. This analysis includes data preparation, econometric modeling, and graphical results similar to those presented in the paper. 

## Results
### 1. Table 3: 
   - Coefficients match the original paper.
   - The logit models utilize standard errors while the paper uses robust standard error. This is due to differences in robust standard error handling between Julia's GLM package and Stata.

### 2. Figure 7: 
   - ROC curve visually matches the original paper.
   - AUC difference is minimal (0.715 vs. 0.717), likely due to rounding.

### 3. Table 4: 
   - Coefficients match the original paper.
   - Standard errors are not robust for the same reason as Table 3.

---

### Data Availability
panel17.dta is the original dataset from the paper and can be obtained from the American Economic Review website: https://www.aeaweb.org/articles?id=10.1257/aer.102.2.1029.

### Running time of reproducing all the results: 36 seconds.

CPU: Apple M2
RAM: 16 GB
OS: Sonoma 14.5

---
## How to run the code
### IN TERMINAL: Clone your GitHub repository and navigate to the project directory
```bash
git clone https://github.com/elicheamshapiro/Schularick_Taylor_2012_Replication.jl

cd Schularick_Taylor_2012_Replication.jl
```

### IN JULIA: Run the following code
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
using SchularickTaylor2012Replication
SchularickTaylor2012Replication.run()
```
---

## Installation Instructions

### Prerequisites
Ensure you have Julia installed on your system. This code has been tested with Julia version `1.10.2`. To replicate the results, you need to install several Julia packages. Please manually install RegressionTables as seen below.

### Package Installation

```julia
using Pkg
Pkg.add("DataFrames")
Pkg.add("GLM")
Pkg.add("StatsModels")
Pkg.add("StatsBase")
Pkg.add("ShiftedArrays")
Pkg.add("CategoricalArrays")
Pkg.add("FixedEffectModels")
Pkg.add("Plots")
Pkg.add("XLSX")
Pkg.add("StatFiles")
Pkg.add("PanelDataTools")
```

#### Be sure to install RegressionTables MANUALLY! (The package supports exporting regression tables in Latex in this version)
```
] add RegressionTables #RegressionTables v0.7.8
```
---

## Inputs and outputs table
| File       | Input                  | Output                 |
|------------|:----------------------|:----------------------|
| data\_setup.jl | data/panel17.dta | - |
| table\_3.jl | - | results/table_3.tex, results/table_3.html |
| figure\_7.jl | - | results/figure_7.png |
| table\_4.jl | - | results/table_4.tex, results/table_4.html |

#### data\_setup.jl
data\_setup.jl prepares the dataset for panel regressions by data cleaning and producing the relevant variables.

#### table\_3.jl
table\_3.jl reproduces Table 3 of the paper, a table of regression results.

#### figure\_7.jl
figure\_7.jl reproduces the Figure 7, the ROC curve and AUC of the baseline model.

#### table\_4.jl
table\_4.jl reproduces Table 4 of the paper, a table of regression results.

For questions or issues, please reach out to Eli Cheam Shapiro. Contributions and suggestions for improving this replication in Julia are welcome!
