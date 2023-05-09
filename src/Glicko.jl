module Glicko

using Roots

export glicko, glicko2

const q = log(10) / 400

function g(RD)
    return 1 / sqrt(1 + 3 * q^2 * RD^2 / π^2)
end

function E(r, rj, RDj)
    return 1 / (1 + 10^(-g(RDj) * (r - rj) / 400))
end

function glicko(r, RD, sjs, rjs, RDjs; c)
    RD = min(350.0, sqrt(RD^2 + c^2))

    if isempty(sjs)
        return r, RD
    else
        RD = min(350.0, sqrt(RD^2 + c^2))
        d² = 1 / q^2 / sum(@. g(RDjs) * E(r, rjs, RDjs) * (1 - E(r, rjs, RDjs)))
        RD′ = 1 / sqrt(1 / RD^2 + 1 / d²)
        r′ = r + q * RD′^2 * sum(@. g(RDjs) * (sjs - E(r, rjs, RDjs)))
        return r′, RD′
    end
end

function g2(ϕ)
    return 1 / sqrt(1 + 3 * ϕ^2 / π^2)
end

function E2(μ, μ_opp, ϕ_opp)
    return 1 / (1 + exp(-g2(ϕ_opp) * (μ - μ_opp)))
end

function f(x; Δ, ϕ, σ, v, τ)
    a = log(σ^2)
    return exp(x) * (Δ^2 - ϕ^2 - v - exp(x)) / (ϕ^2 + v + exp(x)) / 2 - (x - a) / τ^2
end

function glicko2(μ, ϕ, σ, sjs, μjs, ϕjs; τ)
    if isempty(sjs)
        μ′ = μ
        ϕ′ = sqrt(ϕ^2 + σ^2)
        σ′ = σ
    else
        v = 1 / sum(@. g2(ϕjs)^2 * E2(μ, μjs, ϕjs) * (1 - E2(μ, μjs, ϕjs)))
        Δ = v * sum(@. g2(ϕjs) * (sjs - E2(μ, μjs, ϕjs)))
        A = find_zero(x -> f(x; Δ, ϕ, σ, v, τ), log(σ^2))
        σ′ = exp(A / 2)
        ϕ′ = 1 / sqrt(1 / (ϕ^2 + σ′^2) + 1 / v)
        μ′ = μ + ϕ′^2 * Δ / v
    end

    return μ′, ϕ′, σ′
end

end # module
