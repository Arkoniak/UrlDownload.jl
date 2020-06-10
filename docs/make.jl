using Documenter
using UrlDownload

makedocs(;
    modules=[UrlDownload],
    authors="Andrey Oskin",
    repo="https://github.com/Arkoniak/UrlDownload.jl/blob/{commit}{path}#L{line}",
    sitename="UrlDownload.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Arkoniak.github.io/UrlDownload.jl",
        siteurl="https://github.com/Arkoniak/UrlDownload.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Basic usage" => "basic.md",
        "Additional functionality" => "advanced.md"
    ],
)

deploydocs(;
    repo="github.com/Arkoniak/UrlDownload.jl",
)
