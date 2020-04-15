# UrlDownload

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Arkoniak.github.io/UrlDownload.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Arkoniak.github.io/UrlDownload.jl/dev)
[![Build Status](https://travis-ci.com/Arkoniak/UrlDownload.jl.svg?branch=master)](https://travis-ci.com/Arkoniak/UrlDownload.jl)
[![Codecov](https://codecov.io/gh/Arkoniak/UrlDownload.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Arkoniak/UrlDownload.jl)

This is simple package aimed to simplify process of data downloading, without intermediate files storing. Additionally
`UrlDownload.jl` provides progress bar for big files with long download time. Currently these types of data are supported

* PIC: image files, such as jpeg, png, bmp etc
* CSV: files with comma separated values
* FEATHER
* JSON

# Usage

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

# Progress Meter

By default nothing is shown during data downloading, but it can be changed with passing `true` as
a second argument to the function `urldownload`

```julia
using UrlDownload

url = "https://www.stats.govt.nz/assets/Uploads/Business-price-indexes/Business-price-indexes-December-2019-quarter/Download-data/business-price-indexes-december-2019-quarter-csv.csv"

urldownload(url, true)
# Progress: 45%|████████████████████                      | Time: 0:00:01
```

# Undetected file types
Sometimes file type can't be detected from the url, in this case one can supply optional
`format` argument, to force necessary behavior

```julia
using UrlDownload
using DataFrames

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noextcsv"
df = urldownload(url, format = :CSV) |> DataFrame

# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```
