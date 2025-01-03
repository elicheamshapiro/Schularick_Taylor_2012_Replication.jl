println("Running Section: Table 4 Replication")

using GLM, RegressionTables

#Baseline Logistic Regression with Country Fixed Effects
baseline = glm(@formula(crisisST ~ D1lloans1r_l1 + D1lloans1r_l2 + D1lloans1r_l3 + D1lloans1r_l4 + D1lloans1r_l5 + iso), df, Binomial(), LogitLink())

#Broad Money Logistic Regression with Country Fixed Effects
broad_money_baseline = glm(@formula(crisisST ~ D1lmoneyr_l1 + D1lmoneyr_l2 + D1lmoneyr_l3 + D1lmoneyr_l4 + D1lmoneyr_l5 + iso), df, Binomial(), LogitLink())

#Narrow Money Logistic Regression with Country Fixed Effects
narrow_money_baseline = glm(@formula(crisisST ~ D1lnarrowmr_l1 + D1lnarrowmr_l2 + D1lnarrowmr_l3 + D1lnarrowmr_l4 + D1lnarrowmr_l5 + iso), df, Binomial(), LogitLink())

#Loans to GDP Logistic Regression with Country Fixed Effects
loans_gdp_baseline = glm(@formula(crisisST ~ D1lloansgdp_l1 + D1lloansgdp_l2 + D1lloansgdp_l3 + D1lloansgdp_l4 + D1lloansgdp_l5 + iso), df, Binomial(), LogitLink())

#Loans to Broad Money Logistic Regression with Country Fixed Effects
loans_broad_money_baseline = glm(@formula(crisisST ~ D1lloansmoney_l1 + D1lloansmoney_l2 + D1lloansmoney_l3 + D1lloansmoney_l4 + D1lloansmoney_l5 + iso), df, Binomial(), LogitLink())

#Exporting the table into latex
reg_table4 = regtable(baseline, broad_money_baseline, narrow_money_baseline, loans_gdp_baseline, loans_broad_money_baseline; renderSettings = LatexTable(), file = "./results/table_4.tex")
reg_table4 = regtable(baseline, broad_money_baseline, narrow_money_baseline, loans_gdp_baseline, loans_broad_money_baseline; renderSettings = HtmlTable(), file = "./results/table_4.html")
println("Completed Section: Table 4 Replication")