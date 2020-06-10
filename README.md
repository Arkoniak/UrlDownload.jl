# UrlDownload

[![Stable](https://img.shields.io/badge/docs-dev-blue.svg)](https://Arkoniak.github.io/UrlDownload.jl/dev)
[![Build Status](https://travis-ci.com/Arkoniak/UrlDownload.jl.svg?branch=master)](https://travis-ci.com/Arkoniak/UrlDownload.jl)
[![Codecov](https://codecov.io/gh/Arkoniak/UrlDownload.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Arkoniak/UrlDownload.jl)

This is small package aimed to simplify process of data downloading and postprocessing, without intermediate files storing. Additionally `UrlDownload.jl` provides progress bar for big files with long download time.

UrlDownload.jl has integrated support for the processing of various data formats, such as CSV, JSON, various image formats. Everything that is not supported by default, can be easily extended with custom parsers. Also, package automatically decompress and process various compressed data with the help of `TranscodingStreams.jl`(https://github.com/JuliaIO/TranscodingStreams.jl). And it can process files located on `http` resources and local.

# Installation

To install `UrlDownload` either do

```julia
using Pkg
Pkg.add("UrlDownload")
```

or switch to `Pkg` mode with `]` and issue
```julia
pkg> add UrlDownload
```

Note: this package uses many different packages for data processing, which should be installed separately. SO, if you receive message like `ERROR: ArgumentError: Package CSV not found in current path`, install `CSV.jl` manually and error will go away. No additional work is needed, since `UrlDownload.jl` import necessary packages on it's own.

# Usage

Usage is quite simple

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

More details and examples can be found in the [documentation](https://Arkoniak.github.io/UrlDownload.jl/dev).
