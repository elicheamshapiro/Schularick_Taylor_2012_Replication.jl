using Schularick_Taylor_2012_Replication
using Documenter

DocMeta.setdocmeta!(Schularick_Taylor_2012_Replication, :DocTestSetup, :(using Schularick_Taylor_2012_Replication); recursive=true)

makedocs(;
    modules=[Schularick_Taylor_2012_Replication],
    authors="Eli Cheam Shapiro <elicheamshapiro@gmail.com>",
    sitename="Schularick_Taylor_2012_Replication.jl",
    format=Documenter.HTML(;
        canonical="https://elicheamshapiro.github.io/Schularick_Taylor_2012_Replication.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/elicheamshapiro/Schularick_Taylor_2012_Replication.jl",
    devbranch="main",
)
