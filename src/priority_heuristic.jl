abstract type AbstractPriorityModel <: ContinuousUnivariateDistribution end

"""
    PriorityModel{T<:Real} <: AbstractPriorityModel  

A model object for the priority model adapted to the two stage gamble task. 

# Fields

- `σmax::T`: decision noise for maximum outcomes 
- `σmin::T`: decision noise for minimum outcomes 
- `σprob::T`: decision noise for minimum outcome probabilities
- `δoutcome::T`: threshold scalar for outcomes [0,1]
- `δprob::T`: threshold scalar for minimum outcome probabilities [0,1]
- `p_rep::T`: the probability of remembering and repeating the planned response in the final decision

# Constructor 

    PriorityModel(;
        σmax = 0.10,
        σmin = 0.10,
        σprob = 0.10,
        δoutcome = 0.10,
        δprob = 0.10,
        p_rep = .30
    )
"""
mutable struct PriorityModel{T <: Real} <: AbstractPriorityModel
    σmax::T
    σmin::T
    σprob::T
    δoutcome::T
    δprob::T
    p_rep::T
end

function PriorityModel(;
    σmax = 0.10,
    σmin = 0.10,
    σprob = 0.10,
    δoutcome = 0.10,
    δprob = 0.10,
    p_rep = 0.30
)
    parms = promote(σmax, σmin, σprob, δoutcome, δprob, p_rep)
    return PriorityModel(parms...)
end

"""
    compute_probs_min_outcome(
        model::AbstractPriorityModel,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace = false
    )

Computes the probability of safe, risky or next based on minimum outcomes. 

# Arguments

- `model::AbstractPriorityModel`: an subtype of AbstractPriorityModel
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords

- `print_trace = false`: prints trace if true 

# Output 

a tuple of probabilities ordered as prob_safe, prob_risky, prob_next.
"""
function compute_probs_min_outcome(
    model::AbstractPriorityModel,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2;
    print_trace = false
)
    (; δoutcome, σmin) = model
    safe_outcome = outcome_stage1
    risky_outcome1 = outcome_stage1 + outcome1_stage2
    risky_outcome2 = outcome_stage1 + outcome2_stage2
    max_safe = min_safe = safe_outcome
    min_risky = compute_min_outcome(risky_outcome1, risky_outcome2)
    max_risky = compute_max_outcome(risky_outcome1, risky_outcome2)
    max_outcome = maximum(abs.([max_safe, risky_outcome1, risky_outcome2]))
    if print_trace
        print_trace_min_outcome(
            risky_outcome1,
            risky_outcome2,
            min_safe,
            min_risky,
            max_risky,
            max_outcome
        )
    end
    diff_min = min_risky - min_safe
    σ = max_outcome * σmin
    δ = abs(δoutcome * max_outcome)
    return compute_latent_decision_probs(diff_min, σ, δ)
end

"""
    compute_probs_min_outcome_prob(
        model::AbstractPriorityModel,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace = false
    )

Computes the probability of safe, risky or next based on minimum outcome probabilities. 

# Arguments

- `model::AbstractPriorityModel`: an subtype of AbstractPriorityModel
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords

- `print_trace = false`: prints trace if true 

# Output 

a tuple of probabilities ordered as prob_safe, prob_risky, prob_next.
"""
function compute_probs_min_outcome_prob(
    model::AbstractPriorityModel,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
    print_trace = false
)
    (; δprob, σprob) = model
    # minimum prob safe 
    p_min_safe = 1
    # minimum risky 
    risky_outcome1, risky_outcome2, min_risky, min_prob_risky =
        compute_outcomes_min_probs(
            model,
            outcome_stage1,
            outcome1_stage2,
            outcome2_stage2,
            outcome1_prob_stage2
        )
    if print_trace
        print_trace_min_outcome_prob(
            risky_outcome1,
            risky_outcome2,
            min_risky,
            min_prob_risky,
            p_min_safe
        )
    end
    # switch order because smaller p_min_risky increases chance risky is selected
    p_min_diff = p_min_safe - min_prob_risky
    return compute_latent_decision_probs_truncated(p_min_diff, σprob, δprob)
end

"""
    compute_latent_decision_probs(μ, σ, δ)

Computes the latent decision probabilities based on Thurstonian model. 

# Arguments 

- `μ`: mean difference 
- `σ`: evaluation noise 
- `δ`: aspiration level 

# Returns 

A vector with elements corresponding to 

- `prob_safe`: probability of selecting safe option 
- `prob_risky`: probability of selecting risky option 
- `prob_next`: probability of evaluating next feature 
"""
function compute_latent_decision_probs(μ, σ, δ)
    prob_safe = cdf(Normal(μ, σ), -δ)
    prob_risky = 1 - cdf(Normal(μ, σ), δ)
    prob_next = 1 - prob_safe - prob_risky
    return prob_safe, prob_risky, prob_next
end

function compute_latent_decision_probs_truncated(μ, σ, δ)
    prob_safe = cdf(truncated(Normal(μ, σ), -1, 1), -δ)
    prob_risky = 1 - cdf(truncated(Normal(μ, σ), -1, 1), δ)
    prob_next = 1 - prob_safe - prob_risky
    return prob_safe, prob_risky, prob_next
end

function compute_outcomes_min_probs(
    ::AbstractPriorityModel,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
)
    risky_outcome1 = outcome_stage1 + outcome1_stage2
    risky_outcome2 = outcome_stage1 + outcome2_stage2
    min_risky = compute_min_outcome(risky_outcome1, risky_outcome2)
    min_prob_risky =
        min_risky == risky_outcome1 ? outcome1_prob_stage2 : (1 - outcome1_prob_stage2)

    return risky_outcome1, risky_outcome2, min_risky, min_prob_risky
end

"""
    compute_probs_max_outcome(
        model::AbstractPriorityModel,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2;
        print_trace = false
    )

Computes the probability of safe, risky or next based on maximum outcomes. 

# Arguments

- `model::AbstractPriorityModel`: an subtype of AbstractPriorityModel
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords

- `print_trace = false`: prints trace if true 

# Output 

a tuple of probabilities ordered as prob_safe, prob_risky.
"""
function compute_probs_max_outcome(
    model::AbstractPriorityModel,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2;
    print_trace = false
)
    (; σmax) = model
    safe_outcome = outcome_stage1
    risky_outcome1 = outcome_stage1 + outcome1_stage2
    risky_outcome2 = outcome_stage1 + outcome2_stage2
    max_safe = safe_outcome
    max_risky = compute_max_outcome(risky_outcome1, risky_outcome2)
    max_outcome = maximum(abs.([safe_outcome, risky_outcome1, risky_outcome2]))
    if print_trace
        print_trace_max_outcome(
            risky_outcome1,
            risky_outcome2,
            max_safe,
            max_risky,
            max_outcome
        )
    end
    diff_max = max_risky - max_safe
    σ = max_outcome * σmax
    prob_risky = 1 - cdf(Normal(diff_max, σ), 0)
    prob_safe = 1 - prob_risky
    return prob_safe, prob_risky
end

"""
    compute_response_prob(
        model::AbstractPriorityModel,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace = false
    )

Computes the marginal probability of selecting risky option across features minimum outcome, minimum outcome probability and maximum outcome. 

# Arguments

- `model::AbstractPriorityModel`: an subtype of AbstractPriorityModel
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords

- `print_trace = false`: prints trace if true 
"""
function compute_response_prob(
    model::AbstractPriorityModel,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
    print_trace = false
)

    # probabilities for min outcome
    _, prob_risky_min, prob_next_min = compute_probs_min_outcome(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2;
        print_trace
    )

    # probabilities for min outcome probability 
    _, prob_risky_min_p, prob_next_min_p = compute_probs_min_outcome_prob(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace
    )

    # probabilities for max outcome 
    _, prob_risky_max = compute_probs_max_outcome(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2;
        print_trace
    )

    # println("prob_risky_min $prob_risky_min prob_next_min * prob_risky_min_p $(prob_next_min * prob_risky_min_p)
    # prob_next_min * prob_next_min_p * prob_risky_max $(prob_next_min * prob_next_min_p * prob_risky_max)")

    # marginal probability of selecting risky option 
    return prob_risky_min + prob_next_min * prob_risky_min_p +
           prob_next_min * prob_next_min_p * prob_risky_max
end

function predict(
    model::AbstractPriorityModel,
    outcome_stage1::Real,
    outcome1_stage2::Real,
    outcome2_stage2::Real,
    outcome1_prob_stage2;
    print_trace::Bool = false
)
    # outcome from stage 1 is ignored (i.e. set to 0)
    p_risky_plan = compute_response_prob(
        model,
        0,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace
    )

    p_risky_final = compute_response_prob(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace
    )
    return predict_joint_probs(model, p_risky_plan, p_risky_final)
end

""" 
    predict_joint_probs(
        model::AbstractPriorityModel,
        p_plan::Real,
        p_final::Real
    )

Returns the joint choice distribution for the planned and final decision of the 
second gamble conditioned on outcome of first gamble. The joint probability distribution includes 
the probability of repeating of remembering and repeating the choice, denoted  by parameter `m`, which 
allows dependencies in the joint probability distribution 

# Arguments

- `model::AbstractPriorityModel`: a subtype of `AbstractPriorityModel``
- `p_plan::Real`: probability of planning to accept gamble 
- `p_final::Real`: probability of accepting gamble in final decision 

# Returns 

Returns a vector respresenting the joint distribution over planned and final choices, where elements correspond to 

1. probability of planning to accept second gamble and accepting second gamble
2. probability of planning to accept second gamble and rejecting second gamble
3. probability of planning to reject second gamble and accepting second gamble
4. probability of planning to reject second gamble and rejecting second gamble
"""
function predict_joint_probs(
    model::AbstractPriorityModel,
    p_plan::Real,
    p_final::Real
)
    (; p_rep) = model
    # probability of planning to accept second gamble and accepting second gamble
    p_aa = p_plan * (p_rep + (1 - p_rep) * p_final)
    # probability of planning to accept second gamble and rejecting second gamble
    p_ar = p_plan * (1 - p_rep) * (1 - p_final)
    # probability of planning to reject second gamble and accepting second gamble
    p_ra = (1 - p_plan) * (1 - p_rep) * p_final
    # probability of planning to reject second gamble and rejecting second gamble
    p_rr = (1 - p_plan) * (p_rep + (1 - p_rep) * (1 - p_final))
    return [p_aa, p_ar, p_ra, p_rr]
end

function rand(
    model::AbstractPriorityModel,
    outcome_stage1::Real,
    outcome1_stage2::Real,
    outcome2_stage2::Real,
    outcome1_prob_stage2::Real,
    n_trials::Int;
    print_trace::Bool = false
)
    θ = predict(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace
    )

    return rand(Multinomial(n_trials, θ))
end

loglikelihood(d::AbstractPriorityModel, data::Tuple) = sum(logpdf.(d, data...))

logpdf(model::AbstractPriorityModel, x::Tuple) = logpdf(model, x...)

function logpdf(
    model::AbstractPriorityModel,
    outcome_stage1::Real,
    outcome1_stage2::Real,
    outcome2_stage2::Real,
    outcome1_prob_stage2::Real,
    data::Vector{<:Int};
    print_trace::Bool = false
)
    θ = predict(
        model,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace
    )
    θ = any(x -> x == 0, θ) ? adjust(θ) : θ
    n = sum(data)
    return logpdf(Multinomial(n, θ), data)
end

function adjust(p)
    p .+= eps()
    return p ./ sum(p)
end
