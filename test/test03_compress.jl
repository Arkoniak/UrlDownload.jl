module TestCompress
using Test
using UrlDownload
using DataFrames

@testset "compress" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.xz"
    res = urldownload(url) |> DataFrame
    @test res == df
    res = urldownload(url, compress = :xz) |> DataFrame
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz"
    res = urldownload(url) |> DataFrame
    @test res == df
    res = urldownload(url, compress = :gzip) |> DataFrame
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.bz2"
    res = urldownload(url) |> DataFrame
    @test res == df
    res = urldownload(url, compress = :bzip2) |> DataFrame
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.lz4"
    res = urldownload(url) |> DataFrame
    @test res == df
    res = urldownload(url, compress = :lz4) |> DataFrame
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.zst"
    res = urldownload(url) |> DataFrame
    @test res == df
    res = urldownload(url, compress = :zstd) |> DataFrame
    @test res == df
end

@testset "zip compress" begin
    df = DataFrame(x = [1, 3], y = [2, 4])
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv.zip"
    res = urldownload(url) |> DataFrame
    @test res == df

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    @test_logs (:warn, "More than one file in zip archive, returning first.") urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    @test_logs (:warn, "Data format unknown is not supported.") urldownload(url, multifiles = true)
end

@testset "compress overrides" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.zst"
    urldownload(url, parser = identity)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.zst"
    urldownload(url, compress = :none, parser = identity)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    @test_logs (:warn, "More than one file in zip archive, returning first.") urldownload(url, parser = identity)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    urldownload(url, compress = :none, parser = identity)
end

end # module
