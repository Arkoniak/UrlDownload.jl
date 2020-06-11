module TestWrapper

using Test
using UrlDownload
using DataFrames
using CSV

wrapper(x; kw...) = DataFrame(CSV.File(IOBuffer(x); kw...))

@testset "wrappers" begin
    df = DataFrame(x = [1, 3], y = [2, 4])

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url, parser = x -> DataFrame(CSV.File(IOBuffer(x))))
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
    res = urldownload(url, parser = wrapper, delim = ';')
    @test res == df
end

end # module
