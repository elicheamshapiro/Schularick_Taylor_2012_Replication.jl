using Schularick_Taylor_2012_Replication
using Test

#Load Packages
using DataFrames, Test, PanelDataTools, ShiftedArrays

##### Function 1: Real Variables #####
# Define the real_var function
function real_var(var::Vector{Symbol}, df::DataFrame)
    for variable in var
        df[!, Symbol("l", variable, "r")] = log.(df[!, variable]) .- log.(df[!, :cpi])
    end
end

# Unit test for real_var function
@testset "Testing real_var function" begin
    # Create a sample DataFrame
    df = DataFrame(
        year = 1:10,
        var1 = 1:10,
        var2 = 1:10,
        var3 = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
        cpi = 3:12
    )

    # Apply the real_var function
    nom_variables = [:var1, :var2, :var3]
    real_var(nom_variables, df)

    # Expected results
    expected_results = Dict(
        Symbol("lvar1r") => log.(df[!, :var1]) .- log.(df[!, :cpi]),
        Symbol("lvar2r") => log.(df[!, :var2]) .- log.(df[!, :cpi]),
        Symbol("lvar3r") => log.(df[!, :var3]) .- log.(df[!, :cpi])
    )

    # Check each new column
    for (col, expected) in expected_results
        @test df[!, col] == expected
    end
end

##### Function 2: First Differences ####

function diff_grouped(columns::Array{Symbol, 1}; grouped_data)
    for column in columns
        for group in grouped_data
            diff!(group, column, 1)  # Apply diff! from PanelDataTools
        end
    end
end

@testset "Testing diff_grouped function" begin
    # Create a sample DataFrame
    df = DataFrame(
        id = repeat(1:3, inner=3),
        year = repeat(1:3, outer=3),
        var1 = 1:9,
        var2 = [2, 4, 6, 1, 3, 5, 0, 2, 4]
    )

    paneldf!(df,:id,:year)

    # Group the data
    grouped_data = groupby(df, :id)

    # Columns to differentiate
    diff_columns = [:var1, :var2]

    # Apply the diff_grouped function
    diff_grouped(diff_columns; grouped_data=grouped_data)

    #Test if the expected values are correct 
    #Replace missing with 0s because test will not recognize missing values for testing
    #(There should be no 0's in the expected values based on the df we generated)
    df = coalesce.(df, 0)
    @test df.D1var1 == [0, 1, 1, 0, 1, 1, 0, 1, 1]
    @test df.D1var2 == [0, 2, 2, 0, 2, 2, 0, 2, 2]
end

##### Function 3: Lagged Variables #####

# Define the lagged_variables function
function lagged_variables(variables::Vector{Symbol}, df::DataFrame)
    for v in variables
        for i in 1:5
            df[!, Symbol(v, "_l", i)] = lag(df[!, v], i)
        end
    end
end

# Unit test for lagged_variables function
@testset "Testing lagged_variables function" begin
    # Generate an arbitrary DataFrame for testing
    df = DataFrame(
        year = 1:10,
        var1 = 3:12
    )

    # Define variables for lagging
    variables = [:var1]

    # Apply lagged_variables
    lagged_variables(variables, df)

    # Check if lagged variables were created
    for i in 1:5
        @test hasproperty(df, Symbol(:var1, "_l", i))
    end


    #Test if the expected values are correct 
    #Replace missing with 0s because test will not recognize missing values for testing
    #(There should be no 0's in the expected values based on the df we generated)
    df = coalesce.(df, 0)
    @test df.var1_l1 == [0, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @test df.var1_l2 == [0, 0, 3, 4, 5, 6, 7, 8, 9, 10]
    @test df.var1_l3 == [0, 0, 0, 3, 4, 5, 6, 7, 8, 9]
    @test df.var1_l4 == [0, 0, 0, 0, 3, 4, 5, 6, 7, 8]
    @test df.var1_l5 == [0, 0, 0, 0, 0, 3, 4, 5, 6, 7]
end

##### Function 4: Replace values for the years that must be omitted with "missing"

function replace_missing(variables::Vector{Symbol}, df::DataFrame; years_l1 = [], years_l2 = [], years_l3 = [], years_l4 = [], years_l5 = [])
    for v in variables
        for year in years_l1
            df[!, Symbol(v, "_l1")] .= ifelse.(df.year .== year, missing, df[!, Symbol(v, "_l1")])
        end
    
        for year in years_l2
            df[!, Symbol(v, "_l2")] .= ifelse.(df.year .== year, missing, df[!, Symbol(v, "_l2")])
        end
    
        for year in years_l3
            df[!, Symbol(v, "_l3")] .= ifelse.(df.year .== year, missing, df[!, Symbol(v, "_l3")])
        end
    
        for year in years_l4
            df[!, Symbol(v, "_l4")] .= ifelse.(df.year .== year, missing, df[!, Symbol(v, "_l4")])
        end
    
        for year in years_l5
            df[!, Symbol(v, "_l5")] .= ifelse.(df.year .== year, missing, df[!, Symbol(v, "_l5")])
        end
    end
end

# Unit test for replace_missing function
@testset "Testing replace_missing function" begin
    # Generate an arbitrary DataFrame for testing
    df = DataFrame(
        year = 1:10,
        var1 = 3:12
    )

    # Define variables for lagging
    variables = [:var1]

    # Create lagged variables first
    lagged_variables(variables, df)

    # Define years for missing replacements
    years_l1 = [3]
    years_l2 = [4]
    years_l3 = [5]
    years_l4 = [6]
    years_l5 = [7]

    # Apply replace_missing
    replace_missing(variables, df)

    #Test if the expected values are correct 
    #Replace missing with 0s because test will not recognize missing values for testing
    #(There should be no 0's in the expected values based on the df we generated)
    df = coalesce.(df, 0)
    @test df.var1_l1[1] === 0
    @test df.var1_l2[2] === 0
    @test df.var1_l3[3] === 0
    @test df.var1_l4[4] === 0
    @test df.var1_l5[5] === 0
end





