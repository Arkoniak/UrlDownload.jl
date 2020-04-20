module TestCompress
using Test
using UrlDownload

@testset "compress" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.xz"
    urldownload(url)
    urldownload(url, compress = :xz)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.gz"
    urldownload(url)
    urldownload(url, compress = :gzip)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.bz2"
    urldownload(url)
    urldownload(url, compress = :bzip2)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.lz4"
    urldownload(url)
    urldownload(url, compress = :lz4)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test.zst"
    urldownload(url)
    urldownload(url, compress = :zstd)
end

@testset "zip compress" begin
    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/ext.csv.zip"
    urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    @test_logs (:warn, "More than one file in zip archive, returning first.") urldownload(url)

    url = "https://raw.githubusercontent.com/Arkoniak/UrlDownload.jl/master/data/test2.zip"
    @test_logs (:warn, "Data format nothing is not supported.") urldownload(url, multifiles = true)
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
