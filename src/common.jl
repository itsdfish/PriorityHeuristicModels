"""
    compute_min_outcome(x1, x2)

Computes the minimum outcome of two options, as defined by the deterministic version of the priority heuristic. 

# Argument 

- `x1`: outcome 1 
- `x2`: outcome 2

# Examples 

```julia 
julia> compute_min_outcome(1, 2)
1
```

```julia 
julia> compute_min_outcome(-1, -2)
-1
```

```julia 
julia> compute_min_outcome(-1, 2)
-1
```
"""
function compute_min_outcome(x1, x2)
    return (x1 ≤ 0) && (x2 ≤ 0) ? max(x1, x2) : min(x1, x2)
end

"""
    compute_max_outcome(x1, x2)

Computes the maximum outcome of two options, as defined by the deterministic version of the priority heuristic. 

# Argument 

- `x1`: outcome 1 
- `x2`: outcome 2

# Examples 

```julia 
julia> compute_max_outcome(1, 2)
2
```

```julia 
julia> compute_max_outcome(-1, -2)
-2
```

```julia 
julia> compute_max_outcome(-1, 2)
2
```
"""
function compute_max_outcome(x1, x2)
    return (x1 ≤ 0) && (x2 ≤ 0) ? min(x1, x2) : max(x1, x2)
end

"""
    to_decision_index(x)

Maps decisions to indices:

retreat -> 1 
attack -> 2
otherwise -> 3
"""
function to_decision_index(x)
    return x == :retreat ? 1 : x == :attack ? 2 : 3
end

"""
    ≳(a, b; kwargs...)

Tests whether a ≥ b ± ϵ   
"""
≳(a, b; kwargs...) = (a >= b) || isapprox(a, b; kwargs...)

"""
    ≲(a, b; kwargs...)

Tests whether a ≤ b ± ϵ   
"""
≲(a, b; kwargs...) = (a <= b) || isapprox(a, b; kwargs...)

"""
    round_to_prominent(x::Real)

Rounds to the nearest prominent numbers where prominent numbers are defined as 
powers of 10, and their halfs and doubles. For example, {1,2,5,10,20,50,100,200,500,1000}

# Argument

- `x::Real`: a number to be rounded to nearest prominent number

# Example 

```julia 
round_to_prominent(160)
200.0
```
"""
function round_to_prominent(x::Real)
    r = floor(log10(x))
    c = (10^r, 2 * 10^r, 0.5 * 10^(r + 1), 10^(r + 1))
    closest = c[1]
    distance = abs(c[1] - x)
    for i ∈ 2:4
        temp_distance = abs(c[i] - x)
        if temp_distance < distance
            closest = c[i]
            distance = temp_distance
        end
    end
    return closest
end
