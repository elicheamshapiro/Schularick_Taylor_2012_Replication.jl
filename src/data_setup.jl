println("Running Section: Data Set Up")

using StatFiles, FixedEffectModels, Plots, Test, DataFrames, GLM, StatsModels, StatsBase, ShiftedArrays, RegressionTables, PanelDataTools

# Load Data
df = DataFrame(load("./data/Panel17.dta"))

# Set up panel data
paneldf!(df,:iso,:year)

# Filter out data before 1895 for France
df[!, :loans1] .= ifelse.((df.year .<= 1895) .& (df.iso .== "FRA"), missing, df.loans1)

# Omit data for 2009
df = filter(row -> row.year != 2009, df)

#Generate loans/gdp and loans/broad money
df[!, :lloansmoney] = log.(df.loans1 ./ df.money)
df[!, :lloansgdp] = log.(df.loans1 ./ df.gdp)

# # Define nominal variables
nom_variables = [:loans1, :money, :narrowm]

# # Create a function for generating real log variables
function real_var(var::Vector{Symbol}, df::DataFrame)
    for variable in var
        df[!, Symbol("l", variable, "r")] = log.(df[!, variable]) .- log.(df[!, :cpi])
    end
end

real_var(nom_variables, df)

# Compute first differences
grouped = groupby(df, :iso)
columns = [:lloans1r, :lmoneyr, :lnarrowmr, :lloansgdp, :lloansmoney] 

function diff_grouped(columns::Array{Symbol,1}; grouped_data = grouped)
    for column in columns
        for group in grouped_data
            diff!(group, column, 1)
        end
    end
end

diff_grouped(columns)

# Omit data for WW1 and WW2
df.ww1 = ifelse.((df.year .>= 1914) .& (df.year .<= 1919), 1, 0)
df.ww2 = ifelse.((df.year .>= 1939) .& (df.year .<= 1947), 1, 0)
filter!(row -> !(row.ww1 == 1 || row.ww2 == 1), df)

# Define the independent variables
variables = [:D1lloans1r, :D1lmoneyr, :D1lnarrowmr, :D1lloansgdp, :D1lloansmoney]

# Omit year 1920 and 1948 from D1lloansgdp and D1lloansmoney
omit = [1920, 1948]
df.D1lloansgdp = ifelse.(in.(df.year, Ref(omit)), missing, df.D1lloansgdp)
df.D1lloansmoney = ifelse.(in.(df.year, Ref(omit)), missing, df.D1lloansmoney)

# Create lagged variables for each of the regressor variables for models in Table 3 and 4
function lagged_variables(variables::Vector{Symbol}, df::DataFrame)
    for v in variables
        for i in 1:5
            df[!, Symbol(v, "_l", i)] = lag(df[!, v], i)
        end
    end
end

lagged_variables(variables, df)

# Define the years for each lag variable that must be omitted
years_l1 = [1870, 1920, 1948, 1871]
years_l2 = [1870, 1871, 1920, 1921, 1948, 1949]
years_l3 = [1870, 1871, 1872, 1920, 1921, 1922, 1948, 1949, 1950]
years_l4 = [1870, 1871, 1872, 1873, 1920, 1921, 1922, 1923, 1948, 1949, 1950, 1951]
years_l5 = [1870, 1871, 1872, 1873, 1874, 1920, 1921, 1922, 1923, 1924, 1948, 1949, 1950, 1951, 1952]

#Replace values for the years that must be omitted with "missing"
function replace_missing(variables::Vector{Symbol}, df::DataFrame; years_l1 = years_l1, years_l2 = years_l2, years_l3 = years_l3, years_l4 = years_l4, years_l5 = years_l5)
    for v in variables
        for year in years_l1
        df[!, Symbol(v, "_l1")] = ifelse.(df.year .== year, missing, df[!,Symbol(v, "_l1")])
        end
    
        for year in years_l2
            df[!, Symbol(v, "_l2")] = ifelse.(df.year .== year, missing, df[!,Symbol(v, "_l2")])
        end
    
        for year in years_l3
            df[!, Symbol(v, "_l3")] = ifelse.(df.year .== year, missing, df[!,Symbol(v, "_l3")])
        end
    
        for year in years_l4
            df[!, Symbol(v, "_l4")] = ifelse.(df.year .== year, missing, df[!,Symbol(v, "_l4")])
        end
    
        for year in years_l5
            df[!, Symbol(v, "_l5")] = ifelse.(df.year .== year, missing, df[!,Symbol(v, "_l5")])
        end
    
    end
end

replace_missing(variables, df)

println("Data set up complete.")