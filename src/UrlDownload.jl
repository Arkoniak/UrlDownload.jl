module UrlDownload

using ProgressMeter
using HTTP

export urldownload

const ext2sym = Dict(
    r".feather" => :FEATHER,
    r".[ct]sv" => :CSV,
    r".jpe?g" => :PIC,
    r".png" => :PIC,
    r".json" => :JSON,
    r".tga" => :PIC,
    r".gif" => :PIC,
    r".bmp" => :PIC,
    r".pcx" => :PIC
)

const sym2func = Dict(
    :FEATHER => (x; kw...) -> load_feather(x; kw...),
    :PIC => (x; kw...) -> load_pic(x; kw...),
    :CSV => (x; kw...) -> load_csv(x; kw...),
    :TSV => (x; kw...) -> load_csv(x; kw...),
    :JSON => (x; kw...) -> load_json(x; kw...)
)

const Compressor = Dict(
    :gzip => (lib = :CodecZlib, stream = :GzipDecompressorStream, transcode = :GzipDecompressor),
    :zstd => (lib = :CodecZstd, stream = :ZstdDecompressorStream, transcode = :ZstdDecompressor),
    :xz => (lib = :CodecXz, stream = :XzDecompressorStream, transcode = :XzDecompressor),
    :lz4 => (lib = :CodecLz4, stream = :LZ4FrameDecompressorStream, transcode = :LZ4FrameDecompressor),
    :bzip2 => (lib = :CodecBzip2, stream = :Bzip2DecompressorStream, transcode = :Bzip2Decompressor)
)

abstract type Resource end

struct File <: Resource
    name::String
end

struct URL <: Resource
    name::String
end

"""
    f_str(name)

Use this macro to explicitly show that downloaded url is actually local file resource. It is useful if resource type autodetection fails.

# Example
```
using UrlDownload: @f_str
url = f"/tmp/data"
res = urldownload(url)

# Alternatively
using UrlDownload: File
url = File("/tmp/data")
res = urldownload(url)
```
"""
macro f_str(p)
    return quote
        File($(esc(p)))
    end
end

"""
    u_str(name)

Use this macro to explicitly show that downloaded url is remote http resource. It is useful if resource type autodetection fails.

# Example
```
using UrlDownload: @u_str
url = u"https://example.com/data.csv"
res = urldownload(url)

# Alternatively
using UrlDownload: URL
url = URL("https://example.com/data.csv")
res = urldownload(url)
```
"""
macro u_str(p)
    return quote
        URL($(esc(p)))
    end
end

function load_feather(buf; kw...)
    lib = checked_import(:Feather)
    return Base.invokelatest(lib.read, buf)
end

function load_csv(buf; kw...)
    lib = checked_import(:CSV)
    return Base.invokelatest(lib.File, buf; kw...)
end

function load_pic(buf; kw...)
    lib = checked_import(:ImageMagick)
    return Base.invokelatest(lib.load_, _getdata(buf))
end

function load_json(buf; kw...)
    lib = checked_import(:JSON3)
    return Base.invokelatest(lib.read, _getdata(buf))
end

# Borrowed directly from FileIO

# This one is outdated.
# is_installed(pkg::Symbol) = get(Pkg.installed(), string(pkg), nothing) != nothing

function _findmod(f::Symbol)
    for (u,v) in Base.loaded_modules
        (Symbol(v) == f) && return u, v
    end
    nothing, nothing
end

function loadmod(pkg::Symbol)
    @eval Base.__toplevel__  import $pkg
    return _findmod(pkg)
end

function checked_import(pkg::Symbol)
    if isdefined(Main, pkg)
        m1 = getfield(Main, pkg)
        isa(m1, Module) && return m1
    end
    mid, m = _findmod(pkg)
    mid == nothing || return m
    _, m = loadmod(pkg)
    return m
end


getext(url) = splitext(url)
getext(url::IO) = splitext(url.name[2:end-1])
getext(url::Resource) = getext(url.name)
    
function datatype(url)
    _, ext = getext(url)
    ext = lowercase(ext)
    for (k, v) in ext2sym
        occursin(k, ext) && return v
    end
end

# this set of functions is needed for distinguish between raw data and zipstreams,
# we do not want to wrap/unwrap zipstreams.
createbuffer(data::Vector{UInt8}) = IOBuffer(data)
createbuffer(data) = data

_getdata(buf::IOBuffer) = buf.data
_getdata(buf) = buf

function wrapdata(url, data, format, parser, error_on_undetected_format = true; kw...)
    if parser === nothing
        buf = createbuffer(data)
        dtype = format === nothing ? datatype(url) : format

        if dtype in keys(sym2func)
            return sym2func[dtype](buf; kw...)
        else
            dtype = dtype === nothing ? :unknown : dtype
            if error_on_undetected_format
                @error "Data format $dtype is not supported."
            else
                @warn "Data format $dtype is not supported."
                return data
            end
        end
    else
        return parser(data; kw...)
    end
end

maybezip(url) = occursin(".zip", url)
maybezip(url::Resource) = occursin(".zip", url.name)
maybezip(url::IO) = occursin(".zip", url.name)

# Check the file format of a stream.
# Taken from TableReader.jl
function checkformat(data, url)
    if length(data) >= 6
        magic = data[1:6]
    else
        error("Incomplete data received")
    end
    if magic[1:6] == b"\xFD\x37\x7A\x58\x5A\x00"
        return :xz
    elseif magic[1:2] == b"\x1f\x8b"
        return :gzip
    elseif magic[1:4] == b"\x28\xb5\x2f\xfd"
        return :zstd
    elseif magic[1:3] == b"\x42\x5A\x68"
        return :bzip2
    elseif magic[1:4] == b"\x04\x22\x4D\x18"
        return :lz4
    end

    # there is a possibility of false positive, but
    # better to be sorry
    if maybezip(url) &
        ((magic[1:4] == b"\x50\x4b\x03\x04") | (magic[1:4] == b"\x50\x4b\x05\x06") | (magic[1:4] == b"\x50\x4b\x07\x08"))
            return :zip
    end

    # we are giving up
    return :none
end

wrap_httpkw(httpkw::Pair) = [httpkw]
wrap_httpkw(httpkw) = httpkw

saveraw(io::Nothing, data) = nothing
saveraw(io, data) = write(io, data)
function saveraw(io::AbstractString, data)
    iostream = open(io, "w")
    saveraw(iostream, data)
    close(iostream)
end

get_data(url::IO, headers, httpkw, progress, update_period) = read(url)
get_data(url::AbstractString, headers, httpkw, progress, update_period) =
    get_data(autodetect_uri_type(url), headers, httpkw, progress, update_period)
get_data(url::File, headers, httpkw, progress, update_period) = read(url.name)
function get_data(url::URL, headers, httpkw, progress, update_period)
    local body
    HTTP.open("GET", url.name, headers; httpkw...) do stream
        resp = startread(stream)
        eof(stream) && return # nothing to process yet

        body = UInt8[]
        if progress
            total_bytes = floor(parse(Float64, HTTP.header(resp, "Content-Length", "NaN")))
            total_bytes = isnan(total_bytes) ? typemax(Int) : Int(total_bytes)
            p = Progress(total_bytes, update_period)
        end

        while !eof(stream)
            append!(body, readavailable(stream))
            if progress
                update!(p, length(body))
            end
        end
    end

    return body
end

autodetect_uri_type(url) = url
function autodetect_uri_type(url::AbstractString)
    m = match(r"^https?://.*", url)
    if m === nothing
        return File(url)
    else
        return URL(url)
    end
end

"""
    urldownload(url, progress = false;
                parser = nothing, format = nothing, save_raw = nothing,
                compress = :auto, multifiles = false, headers = HTTP.Header[],
                httpkw = Pair[], update_period = 1, kw...)

Download file from the corresponding `url` in memory and process it to the necessary data structure.

# Arguments
* `url`: url of download
* `progress`: show `ProgressMeter`, by default it is not shown
* `parser`: custom parser, function that should accept one positional argument of the type `Vector{UInt8}` and optional keyword arguments and return necessary data structure. If parser is set than it overrides all other settings, such as `format`. If parser is not set, than internal parsers are used for data process.
* `format`: one of the fixed formats (:CSV, :PIC, :FEATHER, :JSON), if set overrides autodetection mechanism.
* `save_raw`: if set to `String` or `IO` then downloaded raw data is stored in corresponding stream.
* `compress`: :auto by default, can be one of :none, :xz, :gzip, :bzip2, :lz4, :zstd, :zip. Determines whether file is compressed and compression type. Decompressed data is processed either by custom `parser` or by internal parser. By default for any compression type except of `:zip` internal parser is `CSV.File`, for `:zip` usual rules applies. If `compress` is `:none` than custom parser should decompress data on its own.
* `multifiles`: `false` by default, for `:zip` compressed data defines, whether process only first file inside archive or return an array of decompressed and processed objects.
* `headers`: `HTTP.jl` arguments that set http header of the request.
* `httpkw`: `HTTP.jl` additional keyword arguments that is passed to the `GET` function. Should be supplied as a vector of pairs.
* `update_period`: period of `ProgressMeter` update, by default 1 sec
* `kw...`: any keyword arguments that should be passed to the data parser.
"""
function urldownload(url, progress = false;
        parser = nothing, format = nothing,
        compress = :auto, multifiles = false,
        save_raw = nothing,
        headers = HTTP.Header[],
        update_period = 1, httpkw = Pair[], kw...)

    httpkw = wrap_httpkw(httpkw)
    body = get_data(url, headers, httpkw, progress, update_period)
    saveraw(save_raw, body)

    compress = compress == :auto ? checkformat(body, url) : compress

    if compress == :none
        # skip unzipping entirely, it's parser responisbility to process the data
        wrapdata(url, body, format, parser; kw...)
    elseif compress == :zip
        zlib = checked_import(:ZipFile)
        zread = Base.invokelatest(getfield(zlib, :Reader), IOBuffer(body)).files
        if multifiles
            return [wrapdata(z.name, z, format, parser, false; kw...) for z in zread]
        else
            if length(zread) > 1
                @warn "More than one file in zip archive, returning first."
            elseif length(zread) == 0
                @error "Zip archive is empty."
            end
            zread = zread[1]
            # This one can easily fail for non csv files, nothing I can do about it
            wrapdata(zread.name, zread, format, parser; kw...)
        end
    elseif compress in keys(Compressor)
        # it's one of the TranscodingStreams.jl streams, not much to do here,
        # defaults to CSV/custom parser
        if parser === nothing
            lib = checked_import(Compressor[compress].lib)
            stream = getfield(lib, Compressor[compress].stream)
            csvlib = checked_import(:CSV)
            csvlibfile = getfield(csvlib, :File)
            return Base.invokelatest(csvlibfile, Base.invokelatest(stream, IOBuffer(body)); kw...)
        else
            lib = checked_import(Compressor[compress].lib)
            transcoder = getfield(lib, Compressor[compress].transcode)
            data = Base.invokelatest(transcode, transcoder, body)
            return parser(data; kw...)
        end
    else
        error("Unknown compress format: $compress")
    end
end

end # module
