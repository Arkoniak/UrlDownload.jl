module TestAutodetect
using Test
using UrlDownload
using UrlDownload: autodetect_uri_type
using UrlDownload: File, URL
using UrlDownload: @f_str, @u_str
using DataFrames

@testset "files" begin
    url = "/tmp/data.csv"
    @test typeof(autodetect_uri_type(url)) == File

    url = "~/data.csv"
    @test typeof(autodetect_uri_type(url)) == File
end

@testset "urls" begin
    url = "https://example.com/data.csv"
    @test typeof(autodetect_uri_type(url)) == URL

    url = "http://example.com/data.csv"
    @test typeof(autodetect_uri_type(url)) == URL
end

@testset "download files or urls" begin
    df = DataFrame(x = [1, 3], y = [2, 4])

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url) |> DataFrame
    @test df == res

    url = joinpath(@__DIR__, "..", "data", "ext.csv")
    res = urldownload(url) |> DataFrame
    @test df == res

    url = URL("https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv")
    res = urldownload(url) |> DataFrame
    @test df == res

    url = u"https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url) |> DataFrame
    @test df == res

    url = File(joinpath(@__DIR__, "..", "data", "ext.csv"))
    res = urldownload(url) |> DataFrame
    @test df == res

    url = joinpath(@__DIR__, "..", "data", "ext.csv")
    url = @f_str url
    res = urldownload(url) |> DataFrame
    @test df == res
end

end # module
