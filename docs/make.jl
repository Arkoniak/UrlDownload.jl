using Documenter, UrlDownload

makedocs(;
    modules=[UrlDownload],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/Arkoniak/UrlDownload.jl/blob/{commit}{path}#L{line}",
    sitename="UrlDownload.jl",
    authors="Andrey Oskin",
    assets=String[],
)

deploydocs(;
    repo="github.com/Arkoniak/UrlDownload.jl",
)
