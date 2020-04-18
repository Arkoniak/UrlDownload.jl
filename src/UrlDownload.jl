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
    :FEATHER => (x, y; kw...) -> load_feather(x, y; kw...),
    :PIC => (x, y; kw...) -> load_pic(x, y; kw...),
    :CSV => (x, y; kw...) -> load_csv(x, y; kw...),
    :TSV => (x, y; kw...) -> load_csv(x, y; kw...),
    :JSON => (x, y; kw...) -> load_json(x, y; kw...)
)

function load_feather(buf, data; kw...)
    lib = checked_import(:Feather)
    return Base.invokelatest(lib.read, buf)
end

function load_csv(buf, data; kw...)
    lib = checked_import(:CSV)
    return Base.invokelatest(lib.File, buf; kw...)
end

function load_pic(buf, data; kw...)
    lib = checked_import(:ImageMagick)
    return Base.invokelatest(lib.load_, data)
end

function load_json(buf, data; kw...)
    lib = checked_import(:JSON3)
    return Base.invokelatest(lib.read, data)
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

function datatype(url)
    _, ext = splitext(url)
    ext = lowercase(ext)
    for (k, v) in ext2sym
        occursin(k, ext) && return v
    end

    # For now (later magic should be reintroduced)
    error("$ext is unsupported.")
end

function wrapdata(url, data, format; kw...)
    buf = IOBuffer(data)
    dtype = format == nothing ? datatype(url) : format

    sym2func[dtype](buf, data; kw...)
end


"""
    urldownload(url, progress = false; parser = nothing, format = nothing, headers = HTTP.Header[], httpkw = Pair[], update_period = 1, kw...)

Download file from the corresponding url in memory and process it to the necessary data structure.

*Arguments*
* `url`: url of download
* `progress`: show ProgressMeter, by default it is not shown
* `parser`: custom parser, function that should accept one positional argument of the type `Vector{UInt8}` and optional
keyword arguments and return necessary data structure. If parser is set than it overrides all other settings, such as `format`.
If parser is not set, than internal parsers are used for data process.
* `format`: one of the fixed formats (:CSV, :PIC, :FEATHER, :JSON), if set overrides autodetection mechanism.
* `headers`: `HTTP.jl` arguments that set http header of the request.
* `httpkw`: `HTTP.jl` additional keyword arguments that is passed to the `GET` function. Should be supplied as a vector of
pairs.
* `update_period`: period of `ProgressMeter` update, by default 1 sec
* `kw...`: any keyword arguments that should be passed to the data parser.
"""
function urldownload(url, progress = false; parser = nothing, format = nothing, headers = HTTP.Header[],
        update_period = 1, httpkw = Pair[], kw...)
    body = UInt8[]
    HTTP.open("GET", url, headers; httpkw...) do stream
        resp = startread(stream)
        eof(stream) && return
        total_bytes = Int(floor(parse(Float64, HTTP.header(resp, "Content-Length", "NaN"))))
        if progress
            p = Progress(total_bytes, update_period)
        end

        while !eof(stream)
            append!(body, readavailable(stream))
            if progress
                update!(p, length(body))
            end
        end
    end

    if parser == nothing
        return wrapdata(url, body, format; kw...)
    else
        return parser(body; kw...)
    end
end

end # module
