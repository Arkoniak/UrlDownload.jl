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
    :FEATHER => (x, y) -> load_feather(x, y),
    :PIC => (x, y) -> load_pic(x, y),
    :CSV => (x, y) -> load_csv(x, y),
    :TSV => (x, y) -> load_csv(x, y),
    :JSON => (x, y) -> load_json(x, y)
)

function load_feather(buf, data)
    lib = checked_import(:Feather)
    return Base.invokelatest(lib.read, buf)
end

function load_csv(buf, data)
    lib = checked_import(:CSV)
    return Base.invokelatest(lib.File, buf)
end

function load_pic(buf, data)
    lib = checked_import(:ImageMagick)
    return Base.invokelatest(lib.load_, data)
end

function load_json(buf, data)
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

function wrapdata(url, data, format)
    buf = IOBuffer(data)
    dtype = format == nothing ? datatype(url) : format

    sym2func[dtype](buf, data)
end

# This is one is mimic FileIO.query, may be it should be
# moved to FileIO.
# function wrapdata(url, data, ::Nothing)
#     buf = IOBuffer(data)
#     _, ext = splitext(url)
#     if haskey(ext2sym, ext)
#         sym = ext2sym[ext]
#         no_magic = !hasmagic(sym)
#         # Sorry, I prefer CSV...
#         if sym ∈ CSVS
#             return CSV.File(buf)
#         end
#         if lensym(sym) == 1 && no_magic # we only found one candidate and there is no magic bytes, trust the extension
#             return load(Stream{DataFormat{sym}, typeof(buf)}(buf, nothing))
#         elseif lensym(sym) > 1 && no_magic
#             return load(Stream{DataFormat{sym[1]}, typeof(buf)}(buf, nothing))
#         end
#         if no_magic && !hasfunction(sym)
#             error("Some formats with extension ", ext, " have no magic bytes; use `urldownload(url, format = :FMT)` to resolve the ambiguity.")
#         end
#     end
#     # Check the magic bytes
#     load(query(buf, nothing))
# end


"""
    urldownload(url; format = nothing, progress = false, headers = HTTP.Header[], update_period = 1, kw...)

Download file from the corresponding url
"""
function urldownload(url, progress = false; format = nothing, headers = HTTP.Header[], update_period = 1, kw...)
    body = UInt8[]
    HTTP.open("GET", url, headers; kw...) do stream
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

    return wrapdata(url, body, format)
end

end # module
