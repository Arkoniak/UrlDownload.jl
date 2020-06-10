# Basic usage

## Download CSV files

CSV files are supported with the help of `CSV.jl`

```julia
using UrlDownload
using DataFrames

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
df = urldownload(url) |> DataFrame
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

For csv and other file formats one can use keyword arguments from the corresponding
library, for example, to process csv with nonstandard delimiters, one can use
`delim` argument from `CSV.jl`

```julia
using UrlDownload
using DataFrames

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
df = urldownload(url, delim = ';') |> DataFrame
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

## Images

Images are supported through `ImageMagick.jl`

```julia
using UrlDownload

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.jpg"
img = urldownload(url);

typeof(img)
# Array{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}},2}
```

## JSON
Json supported with `JSON3.jl`

```julia
using UrlDownload

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.json"
urldownload(url)

# JSON3.Object{Array{UInt8,1},Array{UInt64,1}} with 1 entry:
#   :glossary => {…
```

## Feather

Feather supported with `Feather.jl`

```julia
using UrlDownload

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.feather"
df = urldownload(url)

# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```
