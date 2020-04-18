module TestWrapper

using Test
using UrlDownload
using DataFrames
using CSV

wrapper(x; kw...) = DataFrame(CSV.File(IOBuffer(x); kw...))

@testset "wrappers" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url, parser = x -> DataFrame(CSV.File(IOBuffer(x))))

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
    res = urldownload(url, parser = wrapper, delim = ';')
end

end # module
