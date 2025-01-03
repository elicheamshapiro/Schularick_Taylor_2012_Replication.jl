println("Running Section: Table 3 Replication")

using FixedEffectModels, DataFrames, GLM, StatsModels, RegressionTables

# Omit missing values for the dependent variable
df = dropmissing(df, :crisisST)

# Convert all numeric columns to Float64 (GLM Package regressions will not work with Float32)
for col in names(df)
    if eltype(df[!, col]) <: AbstractFloat
        df[!, col] = convert(Vector{Float64}, df[!, col])
    end
end

# Ordinary Least Squares Model
ols_none = lm(@formula(crisisST ~ D1lloans1r_l1  +  D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4  +  D1lloans1r_l5), df)

# Ordinary Least Squares Model with Country Fixed Effects 
ols_country = lm(@formula(crisisST ~ D1lloans1r_l1  +  D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4  +  D1lloans1r_l5 + iso), df)

# Ordinary Least Squares Model with Country and Time Fixed Effects (Must use the FixedEffectModels package)
ols_country_year = reg(df, @formula(crisisST ~ D1lloans1r_l1  +  D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4 + D1lloans1r_l5 + fe(iso) + fe(year)))

# Logistic Regression Model with No Fixed Effects w/ Robust Standard Errors
logit_none = glm(@formula(crisisST ~ D1lloans1r_l1 + D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4 + D1lloans1r_l5), df, Binomial(), LogitLink())

# Logistic Regression Model with Country Fixed Effects w/ Robust Standard Errors
baseline = glm(@formula(crisisST ~ D1lloans1r_l1 + D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4 + D1lloans1r_l5 + iso), df, Binomial(), LogitLink())

#Create results table (replicated primary results from Table 3)
reg_table3 = regtable(ols_none, ols_country, ols_country_year, logit_none, baseline; renderSettings = LatexTable(), file = "./results/table_3.tex")
reg_table3 = regtable(ols_none, ols_country, ols_country_year, logit_none, baseline; renderSettings = HtmlTable(), file = "./results/table_3.html")

println("Completed Section: Table 3 Replication")

