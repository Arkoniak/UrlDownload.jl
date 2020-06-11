module TestBasic

using Test
using UrlDownload
using DataFrames

@testset "Standard CSVs" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url) |> DataFrame
    @test df == res

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.tsv"
    res = urldownload(url) |> DataFrame
    @test df == res

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noextcsv"
    res = urldownload(url, format = :CSV) |> DataFrame
    @test df == res

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noexttsv"
    res = urldownload(url, format = :TSV) |> DataFrame
    @test df == res
end

@testset "Force format CSVs" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
    res = urldownload(url) |> DataFrame
    @test df == res

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolonnoextcsv"
    res = urldownload(url, format = :CSV) |> DataFrame
    @test df == res
end

@testset "Pics" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.jpg"
    res = urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.png"
    res = urldownload(url)
end

@testset "Feather" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.feather"
    res = urldownload(url) |> DataFrame

    @test df == res
end

@testset "Json" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.json"
    res = urldownload(url)
end

@testset "Progress meter" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url, true)
end

@testset "Keyword arguments" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
    res = urldownload(url, delim = ';') |> DataFrame
    @test res == df
end

end # module
