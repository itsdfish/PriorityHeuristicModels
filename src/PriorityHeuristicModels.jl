module PriorityHeuristicModels

using Distributions

import Distributions: loglikelihood
import Distributions: logpdf
import Distributions: pdf
import Distributions: rand

export PriorityHeuristic
export PriorityModel

export compute_probs_min_outcome
export compute_probs_min_outcome_prob
export compute_probs_max_outcome
export decide
export decide_max_outcome
export decide_min_outcome
export decide_min_outcome_prob
export loglikelihood
export logpdf
export pdf
export rand
export round_to_prominent
export ≳
export ≲

include("priority_heuristic.jl")
include("priority_heuristic_deterministic.jl")
include("common.jl")

end
