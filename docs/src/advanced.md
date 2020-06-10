# Additional functionality

## Progress Meter

By default nothing is shown during data downloading, but it can be changed with passing `true` as
a second argument to the function `urldownload`

```julia
using UrlDownload

url = "https://www.stats.govt.nz/assets/Uploads/Business-price-indexes/Business-price-indexes-December-2019-quarter/Download-data/business-price-indexes-december-2019-quarter-csv.csv"

urldownload(url, true)
# Progress: 45%|████████████████████                      | Time: 0:00:01
```

## Custom parsers

If file type is not supported by `UrlDownload.jl` it is possible to use custom parser
to process the data. Such parser should accept one positional argument, of the type
`Vector{UInt8}` and can have optional keyword arguments.

It should be used in `parser` argument of the `urldownload`.

```julia
using UrlDownload
using DataFrames
using CSV

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
res = urldownload(url, parser = x -> DataFrame(CSV.File(IOBuffer(x))))
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

Alternatively one can use `parser = identity` and process data outside of the function
```julia
using UrlDownload
using DataFrames
using CSV

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
res = urldownload(url, parser = identity) |>
  x -> DataFrame(CSV.File(IOBuffer(x)))
```

If keywords arguments are used in custom parser they will accept values from
keyword arguments of `urldownload` function

```julia
using UrlDownload
using DataFrames
using CSV

wrapper(x; kw...) = DataFrame(CSV.File(IOBuffer(x); kw...))

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
res = urldownload(url, parser = wrapper, delim = ';')
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

## Compressed files

[UrlDownload.jl](https://github.com/Arkoniak/UrlDownload.jl) can process compressed data using autodetection. Currently following formats are supported:
`:xz, :gzip, :bzip2, :lz4, :zstd, :zip`.
```julia
using UrlDownload
using DataFrames

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz"
res = urldownload(url) |> DataFrame
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

To override compression type one can use either one of formats `:xz, :gzip, :bzip2, :lz4, :zstd, :zip`
in the argument `compress` or specify `:none`. In second case if custom parser is used it should
decompress data on itself
```julia
using UrlDownload
using DataFrames
using CodecXz
using CSV

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz"
res = urldownload(url, compress = :xz) |> DataFrame

res = urldownload(url, compress = :none, parser = x -> CSV.read(XzDecompressorStream(IOBuffer(x))))
```

For all compress types except `:zip` `urldownload` automatically applies `CSV.File`
transformation. If any other kind of data is stored in an archive, it should be processed
with custom parser.

`:zip` compressed data is processed one by one with usual rules of the auto-detection applied.
If zip archive contains only single file, than it'll be decompressed as a single object, otherwise
only first file is unpacked. This behavior can be overridden with `multifiles = true`, in
this case `urldownload` returns `Vector` of processed objects.

```julia
using UrlDownload
url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
res = urldownload(url, multifiles = true)

length(res) # 2
```

## Undetected file types

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

## Storing raw data

Sometimes downloaded data can be too big to be downloaded multiple times, so you may want to store original version of the file locally. To do it you can use `save_raw` argument, which can be either `String` with the file name or `IOStream`.

```julia
using UrlDownload
using DataFrames

url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
res = urldownload(url; save_raw = "/tmp/data.csv") |> DataFrame
# 2×2 DataFrame
# │ Row │ x     │ y     │
# │     │ Int64 │ Int64 │
# ├─────┼───────┼───────┤
# │ 1   │ 1     │ 2     │
# │ 2   │ 3     │ 4     │
```

and you can verify that original data was stored locally
```sh
sh> cat /tmp/data.csv
x,y
1,2
3,4
```

You can process downloaded file with `urldownload` in the following way
```julia
io = open("/tmp/data.csv", "r")
res = urldownload(io) |> DataFrame
close(io)
```
