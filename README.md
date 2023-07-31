# Glicko.jl

Simple implementation of Glicko and Glicko2 rating systems in Julia.

```julia
using Glicko

rjs = [1400.0, 1550.0, 1700.0] # Opponents ratings
RDjs = [30.0, 100.0, 300.0] # Opponents ratings deviation
sjs = [1.0, 0.0, 0.0] # Results

# New rating and rating deviation:
r′, RD′ = glicko(1500.0, 200.0, sjs, rjs, RDjs; c=0.0)

# Glicko 2
μjs = [-0.5756, 0.2878, 1.1513] # Opponents ratings
ϕjs = [0.1727, 0.5756, 1.7269] # Opponents ratings deviation

# New rating, deviation and volatility:
μ′, ϕ′, σ′ = glicko2(0.0, 1.15, 0.06, sjs, μjs, ϕjs; τ=0.5)
```
