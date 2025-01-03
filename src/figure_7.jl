println("Running Section: Figure 7 Replication")
using Plots

# Ensure consistent rows
train_indices = completecases(df[:, [:D1lloans1r_l1, :D1lloans1r_l2, :D1lloans1r_l3, 
                                      :D1lloans1r_l4, :D1lloans1r_l5, :iso, :crisisST]])
true_labels = df.crisisST[train_indices]
predicted_probabilities = predict(baseline)

# Define thresholds
thresholds = range(0, stop=1, length=100)

# Compute TPR and FPR
tpr = Float64[]
fpr = Float64[]

for threshold in thresholds
    predicted_labels = predicted_probabilities .>= threshold

    tp = sum((predicted_labels .== 1) .& (true_labels .== 1))
    fn = sum((predicted_labels .== 0) .& (true_labels .== 1))
    fp = sum((predicted_labels .== 1) .& (true_labels .== 0))
    tn = sum((predicted_labels .== 0) .& (true_labels .== 0))

    push!(tpr, tp / (tp + fn))
    push!(fpr, fp / (fp + tn))
end

# Ensure FPR and TPR are sorted
sorted_indices = sortperm(fpr)
fpr = fpr[sorted_indices]
tpr = tpr[sorted_indices]

# Compute AUC
auc = sum((fpr[i] - fpr[i-1]) * (tpr[i] + tpr[i-1]) / 2 for i in 2:length(fpr))
formatted_auc = round(auc, digits=3)
println("AUC: $formatted_auc")

# Plot ROC Curve
plot(fpr, tpr, xlabel="False Positive Rate", ylabel="True Positive Rate", 
     title="ROC Curve (AUC = $formatted_auc)", legend=false)
     plot!([0, 1], [0, 1], label="Random Classifier", linestyle=:dash, color=:gray)

     savefig("./results/figure_7.png")


println("Completed Section: Figure 7 Replication")