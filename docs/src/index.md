# UrlDownload.jl

[UrlDownload.jl](https://github.com/Arkoniak/UrlDownload.jl) is a small package aimed to simplify process of data downloading and postprocessing, without intermediate files storing. Additionally [UrlDownload.jl](https://github.com/Arkoniak/UrlDownload.jl) provides progress bar for big files with long download time.

Currently these types of data are supported

* PIC: image files, such as jpeg, png, bmp etc
* CSV: files with comma separated values
* FEATHER
* JSON

Unsupported file formats can be processed with the help of custom parsers.

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

Note: this package uses many different packages for data processing, which should be installed separately. SO, if you receive message like `ERROR: ArgumentError: Package CSV not found in current path`, install [CSV.jl](https://github.com/JuliaData/CSV.jl) manually and error will go away. No additional work is needed, since [UrlDownload.jl](https://github.com/Arkoniak/UrlDownload.jl) import necessary packages on it's own.

# Functions

```@autodocs
Modules = [UrlDownload]
```
