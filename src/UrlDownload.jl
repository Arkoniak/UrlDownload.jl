module UrlDownload

import FileIO: hasmagic, ext2sym,  lensym, query, Stream, DataFormat
import FileIO: load
using ProgressMeter
using HTTP
using CSV

export urldownload

# This is one is mimic FileIO.query, may be it should be
# moved to FileIO.
function wrapdata(url, data)
    buf = IOBuffer(data)
    _, ext = splitext(url)
    if haskey(ext2sym, ext)
        sym = ext2sym[ext]
        no_magic = !hasmagic(sym)
        # Sorry, I prefer CSV...
        if sym == :CSV
            return CSV.File(buf)
        end
        if lensym(sym) == 1 && no_magic # we only found one candidate and there is no magic bytes, trust the extension
            return load(Stream{DataFormat{sym}, typeof(buf)}(buf, nothing))
        elseif lensym(sym) > 1 && no_magic
            return load(Stream{DataFormat{sym[1]}, typeof(buf)}(buf, nothing))
        end
        if no_magic && !hasfunction(sym)
            error("Some formats with extension ", ext, " have no magic bytes; use `urldownload(url, format = :FMT)` to resolve the ambiguity.")
        end
    end
    # Check the magic bytes
    load(query(buf, nothing))
end

function wrapdata(url, data, format::Symbol)
    buf = IOBuffer(data)
    if format == :CSV
        return CSV.File(buf)
    else
        return load(Stream{DataFormat{format}, typeof(buf)}(buf, nothing))
    end
end

"""
    urldownload(url; format = nothing, progress = false, headers = HTTP.Header[], update_period = 1, kw...)

Download file from the corresponding url
"""
function urldownload(url; format = nothing, progress = false, headers = HTTP.Header[], update_period = 1, kw...)
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

    return wrapdata(url, body)
end

end # module
