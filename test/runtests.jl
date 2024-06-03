using Test
using Ratings

@testset "Elo" begin
    rjs = [1609.0, 1477.0, 1388.0, 1586.0, 1720.0]
    sjs = [0.0, 0.5, 1.0, 1.0, 0.0]

    @test 1601.0 ≈ elo(1613.0, sjs, rjs; k=32) atol = 1.0
end

@testset "Glicko" begin
    rjs = [1400.0, 1550.0, 1700.0]
    RDjs = [30.0, 100.0, 300.0]
    sjs = [1.0, 0.0, 0.0]

    r′, RD′ = glicko(1500.0, 200.0, sjs, rjs, RDjs; c=0.0)
    @test r′ ≈ 1464.0 atol = 1.0
    @test RD′ ≈ 151.4 atol = 0.1
end

@testset "Glicko 2" begin
    μjs = [-0.5756, 0.2878, 1.1513]
    ϕjs = [0.1727, 0.5756, 1.7269]
    sjs = [1.0, 0.0, 0.0]

    μ′, ϕ′, σ′ = glicko2(0.0, 1.15, 0.06, sjs, μjs, ϕjs; τ=0.5)
    @test μ′ ≈ -0.207 atol = 0.001
    @test ϕ′ ≈ 0.872 atol = 0.001
    @test σ′ ≈ 0.060 atol = 0.001
end
