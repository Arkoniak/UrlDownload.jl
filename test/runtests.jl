using Test
using UrlDownload

@testset "Standard CSVs" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.tsv"
    res = urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noextcsv"
    res = urldownload(url, format = :CSV)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/noexttsv"
    res = urldownload(url, format = :TSV)
end

@testset "Force format CSVs" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolon.csv"
    res = urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/semicolonnoextcsv"
    res = urldownload(url, format = :CSV)
end

@testset "Pics" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.jpg"
    res = urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.png"
    res = urldownload(url)
end

@testset "Feather" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.feather"
    res = urldownload(url)
end

@testset "Json" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.json"
    res = urldownload(url)
end

@testset "Progress meter" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv"
    res = urldownload(url, true)
end
