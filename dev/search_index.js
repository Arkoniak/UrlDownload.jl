var documenterSearchIndex = {"docs":
[{"location":"basic/#Basic-usage","page":"Basic usage","title":"Basic usage","text":"","category":"section"},{"location":"basic/#Download-CSV-files","page":"Basic usage","title":"Download CSV files","text":"","category":"section"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"CSV files are supported with the help of CSV.jl","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"using UrlDownload\nusing DataFrames\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv\"\ndf = urldownload(url) |> DataFrame\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"For csv and other file formats one can use keyword arguments from the corresponding library, for example, to process csv with nonstandard delimiters, one can use delim argument from CSV.jl","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"using UrlDownload\nusing DataFrames\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv\"\ndf = urldownload(url, delim = ';') |> DataFrame\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"basic/#Images","page":"Basic usage","title":"Images","text":"","category":"section"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"Images are supported through ImageMagick.jl","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"using UrlDownload\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.jpg\"\nimg = urldownload(url);\n\ntypeof(img)\n# Array{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}},2}","category":"page"},{"location":"basic/#JSON","page":"Basic usage","title":"JSON","text":"","category":"section"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"Json supported with JSON3.jl","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"using UrlDownload\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.json\"\nurldownload(url)\n\n# JSON3.Object{Array{UInt8,1},Array{UInt64,1}} with 1 entry:\n#   :glossary => {…","category":"page"},{"location":"basic/#Feather","page":"Basic usage","title":"Feather","text":"","category":"section"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"Feather supported with Feather.jl","category":"page"},{"location":"basic/","page":"Basic usage","title":"Basic usage","text":"using UrlDownload\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.feather\"\ndf = urldownload(url)\n\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/#Additional-functionality","page":"Additional functionality","title":"Additional functionality","text":"","category":"section"},{"location":"advanced/#Progress-Meter","page":"Additional functionality","title":"Progress Meter","text":"","category":"section"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"By default nothing is shown during data downloading, but it can be changed with passing true as a second argument to the function urldownload","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\n\nurl = \"https://www.stats.govt.nz/assets/Uploads/Business-price-indexes/Business-price-indexes-December-2019-quarter/Download-data/business-price-indexes-december-2019-quarter-csv.csv\"\n\nurldownload(url, true)\n# Progress: 45%|████████████████████                      | Time: 0:00:01","category":"page"},{"location":"advanced/#Custom-parsers","page":"Additional functionality","title":"Custom parsers","text":"","category":"section"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"If file type is not supported by UrlDownload.jl it is possible to use custom parser to process the data. Such parser should accept one positional argument, of the type Vector{UInt8} and can have optional keyword arguments.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"It should be used in parser argument of the urldownload.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\nusing CSV\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv\"\nres = urldownload(url, parser = x -> DataFrame(CSV.File(IOBuffer(x))))\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"Alternatively one can use parser = identity and process data outside of the function","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\nusing CSV\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv\"\nres = urldownload(url, parser = identity) |>\n  x -> DataFrame(CSV.File(IOBuffer(x)))","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"If keywords arguments are used in custom parser they will accept values from keyword arguments of urldownload function","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\nusing CSV\n\nwrapper(x; kw...) = DataFrame(CSV.File(IOBuffer(x); kw...))\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv\"\nres = urldownload(url, parser = wrapper, delim = ';')\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/#Compressed-files","page":"Additional functionality","title":"Compressed files","text":"","category":"section"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"UrlDownload.jl can process compressed data using autodetection. Currently following formats are supported: :xz, :gzip, :bzip2, :lz4, :zstd, :zip.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz\"\nres = urldownload(url) |> DataFrame\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"To override compression type one can use either one of formats :xz, :gzip, :bzip2, :lz4, :zstd, :zip in the argument compress or specify :none. In second case if custom parser is used it should decompress data on itself","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\nusing CodecXz\nusing CSV\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz\"\nres = urldownload(url, compress = :xz) |> DataFrame\n\nres = urldownload(url, compress = :none, parser = x -> CSV.read(XzDecompressorStream(IOBuffer(x))))","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"For all compress types except :zip urldownload automatically applies CSV.File transformation. If any other kind of data is stored in an archive, it should be processed with custom parser.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":":zip compressed data is processed one by one with usual rules of the auto-detection applied. If zip archive contains only single file, than it'll be decompressed as a single object, otherwise only first file is unpacked. This behavior can be overridden with multifiles = true, in this case urldownload returns Vector of processed objects.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip\"\nres = urldownload(url, multifiles = true)\n\nlength(res) # 2","category":"page"},{"location":"advanced/#Undetected-file-types","page":"Additional functionality","title":"Undetected file types","text":"","category":"section"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"Sometimes file type can't be detected from the url, in this case one can supply optional format argument, to force necessary behavior","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noextcsv\"\ndf = urldownload(url, format = :CSV) |> DataFrame\n\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/#Storing-raw-data","page":"Additional functionality","title":"Storing raw data","text":"","category":"section"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"Sometimes downloaded data can be too big to be downloaded multiple times, so you may want to store original version of the file locally. To do it you can use save_raw argument, which can be either String with the file name or IOStream.","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"using UrlDownload\nusing DataFrames\n\nurl = \"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv\"\nres = urldownload(url; save_raw = \"/tmp/data.csv\") |> DataFrame\n# 2×2 DataFrame\n# │ Row │ x     │ y     │\n# │     │ Int64 │ Int64 │\n# ├─────┼───────┼───────┤\n# │ 1   │ 1     │ 2     │\n# │ 2   │ 3     │ 4     │","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"and you can verify that original data was stored locally","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"sh> cat /tmp/data.csv\nx,y\n1,2\n3,4","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"You can process downloaded file with urldownload in the following way","category":"page"},{"location":"advanced/","page":"Additional functionality","title":"Additional functionality","text":"io = open(\"/tmp/data.csv\", \"r\")\nres = urldownload(io) |> DataFrame\nclose(io)","category":"page"},{"location":"#UrlDownload.jl","page":"Home","title":"UrlDownload.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"UrlDownload.jl is a small package aimed to simplify process of data downloading and postprocessing, without intermediate files storing. Additionally UrlDownload.jl provides progress bar for big files with long download time.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Currently these types of data are supported","category":"page"},{"location":"","page":"Home","title":"Home","text":"PIC: image files, such as jpeg, png, bmp etc\nCSV: files with comma separated values\nFEATHER\nJSON","category":"page"},{"location":"","page":"Home","title":"Home","text":"Unsupported file formats can be processed with the help of custom parsers.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install UrlDownload either do","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg\nPkg.add(\"UrlDownload\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"or switch to Pkg mode with ] and issue","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add UrlDownload","category":"page"},{"location":"","page":"Home","title":"Home","text":"Note: this package uses many different packages for data processing, which should be installed separately. SO, if you receive message like ERROR: ArgumentError: Package CSV not found in current path, install CSV.jl manually and error will go away. No additional work is needed, since UrlDownload.jl import necessary packages on it's own.","category":"page"},{"location":"#Functions","page":"Home","title":"Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Modules = [UrlDownload]","category":"page"},{"location":"#UrlDownload.urldownload","page":"Home","title":"UrlDownload.urldownload","text":"urldownload(url, progress = false;\n            parser = nothing, format = nothing, save_raw = nothing,\n            compress = :auto, multifiles = false, headers = HTTP.Header[],\n            httpkw = Pair[], update_period = 1, kw...)\n\nDownload file from the corresponding url in memory and process it to the necessary data structure.\n\nArguments\n\nurl: url of download\nprogress: show ProgressMeter, by default it is not shown\nparser: custom parser, function that should accept one positional argument of the type Vector{UInt8} and optional keyword arguments and return necessary data structure. If parser is set than it overrides all other settings, such as format. If parser is not set, than internal parsers are used for data process.\nformat: one of the fixed formats (:CSV, :PIC, :FEATHER, :JSON), if set overrides autodetection mechanism.\nsave_raw: if set to String or IO then downloaded raw data is stored in corresponding stream.\ncompress: :auto by default, can be one of :none, :xz, :gzip, :bzip2, :lz4, :zstd, :zip. Determines whether file is compressed and compression type. Decompressed data is processed either by custom parser or by internal parser. By default for any compression type except of :zip internal parser is CSV.File, for :zip usual rules applies. If compress is :none than custom parser should decompress data on its own.\nmultifiles: false by default, for :zip compressed data defines, whether process only first file inside archive or return an array of decompressed and processed objects.\nheaders: HTTP.jl arguments that set http header of the request.\nhttpkw: HTTP.jl additional keyword arguments that is passed to the GET function. Should be supplied as a vector of pairs.\nupdate_period: period of ProgressMeter update, by default 1 sec\nkw...: any keyword arguments that should be passed to the data parser.\n\n\n\n\n\n","category":"function"}]
}