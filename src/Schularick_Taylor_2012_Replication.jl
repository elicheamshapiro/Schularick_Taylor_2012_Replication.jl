#] add RegressionTables

module Schularick_Taylor_2012_Replication

using StatFiles, FixedEffectModels, Plots, Test, DataFrames, GLM, StatsModels, StatsBase, ShiftedArrays, PanelDataTools, RegressionTables

# Exported function to execute the replication
export run

# Main entry point to run the replication
function run()
    println("Running the Taylor and Schularick (2012) replication...")

    # Step 1: Setup data
    include("./src/data_setup.jl")  # Loads and preprocesses the data

    # Step 2: Generate Table 3
    include("./src/table_3.jl")  # Runs regressions and creates Table 3

    # Step 3: Generate Figure 7
    include("./src/figure_7.jl")  # Creates the ROC curve (Figure 7)

    # Step 4: Generate Table 4
    include("./src/table_4.jl")  # Runs regressions and creates Table 4

    println("Replication complete.")
end

end  # End of module


