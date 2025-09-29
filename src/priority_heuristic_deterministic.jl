abstract type AbstractPriorityHeuristic end

struct PriorityHeuristic <: AbstractPriorityHeuristic end

"""
    decide_min_outcome(
        ::AbstractPriorityHeuristic,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2;
        print_trace = false,
    )

Decides whether to attack or retreat on the basis of the minimum outcomes of each option.

# Arguments 

- `model::AbstractPriorityHeuristic`: an subtype of AbstractPriorityHeuristic
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 

# Keywords 

-  `print_trace = false`: details of the decision process for validation 

# Returns

- `decision::Symbol`: the decision which can be :retreat, :attack, or :check_next
"""
function decide_min_outcome(
    ::AbstractPriorityHeuristic,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    args...;
    print_trace = false,
    rounding_on = false
)
    retreat_outcome = outcome_stage1
    attack_outcome1 = outcome_stage1 + outcome1_stage2
    attack_outcome2 = outcome_stage1 + outcome2_stage2
    max_retreat = min_retreat = retreat_outcome
    min_attack = compute_min_outcome(attack_outcome1, attack_outcome2)
    max_attack = compute_max_outcome(attack_outcome1, attack_outcome2)
    # max_outcome = compute_max_outcome(max_retreat, max_attack)
    max_outcome = maximum(abs.([retreat_outcome, attack_outcome1, attack_outcome2]))
    if rounding_on
        max_outcome = round_to_prominent(max_outcome)
    end
    if print_trace
        print_trace_min_outcome(
            attack_outcome1,
            attack_outcome2,
            min_retreat,
            min_attack,
            max_attack,
            max_outcome
        )
    end
    # threshold = abs(max_outcome)
    can_retreat = (min_retreat - min_attack) ≳ 0.10 * max_outcome
    can_attack = (min_attack - min_retreat) ≳ 0.10 * max_outcome
    if (min_retreat == 0) && (min_attack == 0)
        return :check_next
    elseif can_retreat && can_attack
        return :check_next
    elseif can_retreat
        return :retreat
    elseif can_attack
        return :attack
    else
        return :check_next
    end
end

"""
    print_trace_min_outcome(
        attack_outcome1,
        attack_outcome2,
        min_retreat,
        min_attack,
        max_attack,
        max_outcome,
    )

Prints the details of the decision process for minimum outcomes. 

# Arguments 

- `attack_outcome1`: the first outcome for attacking
- `attack_outcome2`: the second outcome for attacking
- `min_retreat`: the minimum outcome for retreating
- `min_attack`: the minimum outcome for attacking
- `max_attack`: the maximum outcome for attacking
- `max_outcome`: the maximum outcome for retreating and attacking 
"""
function print_trace_min_outcome(
    attack_outcome1,
    attack_outcome2,
    min_retreat,
    min_attack,
    max_attack,
    max_outcome
)
    println("Minimum Outcome Stage...")
    println("$((attack_outcome1, attack_outcome2)) min_attack $min_attack")
    println("max_attack $max_attack")
    println("max outcome $max_outcome")
    println("retreat....")
    println("(min_retreat - min_attack) ≥ .10 * |max_outcome| = 
        ($min_retreat - $min_attack) ≥ .10 * $(abs(max_outcome)) =
        $(min_retreat - min_attack) ≥ $(.10 * abs(max_outcome)) =
         $((min_retreat - min_attack) ≥ .10 * abs(max_outcome))")
    println("attack....")
    return println("(min_attack - min_retreat) ≥ .10 * |max_outcome| = 
                ($min_attack - $min_retreat) ≥ .10 * $(abs(max_outcome)) =
                $(min_attack - min_retreat) ≥ $(.10 * abs(max_outcome)) =
                 $((min_attack - min_retreat) ≥ .10 * abs(max_outcome))")
end

"""
    decide_max_outcome(
        ::AbstractPriorityHeuristic,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2;
        print_trace = false,
    )

Decides whether to attack or retreat on the basis of the maximum outcomes of each option.

# Arguments 

- `model::AbstractPriorityHeuristic`: an subtype of AbstractPriorityHeuristic
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 

# Keywords 

-  `print_trace = false`: details of the decision process for validation 

# Returns

- `decision::Symbol`: the decision which can be :retreat, :attack, or :check_next
"""
function decide_max_outcome(
    ::AbstractPriorityHeuristic,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    args...;
    print_trace = false,
    _...
)
    retreat_outcome = outcome_stage1
    attack_outcome1 = outcome_stage1 + outcome1_stage2
    attack_outcome2 = outcome_stage1 + outcome2_stage2
    max_retreat = retreat_outcome
    max_attack = compute_max_outcome(attack_outcome1, attack_outcome2)
    if print_trace
        print_trace_max_outcome(
            attack_outcome1,
            attack_outcome2,
            max_retreat,
            max_attack
        )
    end
    if max_retreat == max_attack
        return :check_next
    elseif max_retreat > max_attack
        return :retreat
    else
        return :attack
    end
end

"""
    print_trace_max_outcome(
        attack_outcome1,
        attack_outcome2,
        min_retreat,
        min_attack,
        max_attack,
    )

Prints the details of the decision process for maximum outcomes. 

# Arguments 

- `attack_outcome1`: the first outcome for attacking
- `attack_outcome2`: the second outcome for attacking
- `min_retreat`: the minimum outcome for retreating
- `min_attack`: the minimum outcome for attacking
- `max_attack`: the maximum outcome for attacking
"""
function print_trace_max_outcome(
    attack_outcome1,
    attack_outcome2,
    max_retreat,
    max_attack
)
    println("Maximum Outcome Stage...")
    println("outcomes $((attack_outcome1, attack_outcome2)) max_attack $max_attack")
    println("max outcome $max_outcome")
    println("retreat....")
    println("max_retreat > max_attack = ($max_retreat > $max_attack)")
    println("attack....")
    return println("max_attack > max_retreat = ($max_attack > $max_retreat)")
end

"""
    decide_min_outcome_prob(
        ::AbstractPriorityHeuristic,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        print_trace = false,
    )

Decides whether to attack or retreat on the basis of the minimum outcome probability of each option.

# Arguments 

- `model::AbstractPriorityHeuristic`: an subtype of AbstractPriorityHeuristic
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords 

-  `print_trace = false`: details of the decision process for validation 

# Returns

- `decision::Symbol`: the decision which can be :retreat, :attack, or :check_next
"""
function decide_min_outcome_prob(
    model::AbstractPriorityHeuristic,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
    print_trace = false,
    _...
)
    min_prob_retreat = 1
    retreat_outcome = outcome_stage1
    min_retreat = retreat_outcome

    # minimum attack 
    attack_outcome1, attack_outcome2, min_attack, min_prob_attack =
        compute_outcomes_min_probs(
            model,
            outcome_stage1,
            outcome1_stage2,
            outcome2_stage2,
            outcome1_prob_stage2
        )

    # println("attack_outcome1 $attack_outcome1 attack_outcome2 $attack_outcome2 min_attack $min_attack min_prob_attack $min_prob_attack")
    if print_trace
        print_trace_min_outcome_prob(
            attack_outcome1,
            attack_outcome2,
            min_attack,
            min_prob_attack,
            min_prob_retreat
        )
    end
    can_retreat = (min_prob_attack - min_prob_retreat) ≥ 0.10
    can_attack = (min_prob_retreat - min_prob_attack) ≥ 0.10
    if can_retreat && can_attack
        return :check_next
    elseif can_retreat
        return :retreat
    elseif can_attack
        return :attack
    else
        return :check_next
    end
end

function compute_outcomes_min_probs(
    ::AbstractPriorityHeuristic,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
)
    attack_outcome1 = outcome_stage1 + outcome1_stage2
    attack_outcome2 = outcome_stage1 + outcome2_stage2
    min_attack = compute_min_outcome(attack_outcome1, attack_outcome2)
    min_prob_attack =
        min_attack == attack_outcome1 ? outcome1_prob_stage2 : (1 - outcome1_prob_stage2)

    return attack_outcome1, attack_outcome2, min_attack, min_prob_attack
end

"""
    print_trace_min_outcome_prob(
        attack_outcome1,
        attack_outcome2,
        min_attack,
        min_prob_attack,
        min_prob_retreat
    )

Prints the details of the decision process for minimum outcome probabilities. 

# Arguments 

- `attack_outcome1`: the first outcome for attacking
- `attack_outcome2`: the second outcome for attacking
- `min_attack`: the minimum outcome for attacking
- `min_prob_attack`: the probability associated with the minimum attack outcome 
- `min_prob_retreat`:  the probability associated with the minimum retreat outcome 
"""
function print_trace_min_outcome_prob(
    attack_outcome1,
    attack_outcome2,
    min_attack,
    min_prob_attack,
    min_prob_retreat
)
    println("Minimum Outcome Probability Stage...")
    println("$((attack_outcome1, attack_outcome2)) min_attack $min_attack")
    println("retreat....")
    println("(min_prob_attack - min_prob_retreat) ≥ .10 = 
        ($min_prob_attack - $min_prob_retreat) ≥ .10 =
        $(min_prob_attack - min_prob_retreat) ≥ .10 =
         $((min_prob_attack - min_prob_retreat) ≥ .10)")
    println("attack....")
    return println("(min_prob_retreat - min_prob_attack) ≥ .10 = 
               ($min_prob_retreat - $min_prob_attack) ≥ .10 =
               $(min_prob_retreat - min_prob_attack) ≥ .10 =
               $((min_prob_retreat - min_prob_attack) ≥ .10)")
end

"""
    decide(
        ::AbstractPriorityHeuristic,
        outcome_stage1,
        outcome1_stage2,
        outcome2_stage2,
        outcome1_prob_stage2;
        decision_funcs = (decide_min_outcome, decide_min_outcome_prob, decide_max_outcome),
        print_trace = false,
    )

Decides whether to attack or retreat based on the priority heuristic. The order in which features are 
evaluated is given by keyword `decision_funcs`.

# Arguments 

- `model::AbstractPriorityHeuristic`: an subtype of AbstractPriorityHeuristic
- `outcome_stage1`: the observed or hypothetical outcome from stage 1
- `outcome1_stage2`: the first outcome for attacking 
- `outcome2_stage2`: the second outcome for attacking 
- `outcome1_prob_stage2`: the probability of outcome 1 in stage 2

# Keywords 

- `decision_funcs = (decide_min_outcome, decide_min_outcome_prob, decide_max_outcome)`: a tuple of 
    decision functions. Each decision function evaluates a different feature of the decision options. 
    By default, features are evaluated in the following order: minimum outcomes, minimum outcome probabilities, 
    and maximum outcomes. 

- `print_trace = false`: details of the decision process for validation 

# Returns

- `decision::Symbol`: the decision which can be :retreat, :attack, or :check_next
"""
function decide(
    model::AbstractPriorityHeuristic,
    outcome_stage1,
    outcome1_stage2,
    outcome2_stage2,
    outcome1_prob_stage2;
    decision_funcs = (decide_min_outcome, decide_min_outcome_prob, decide_max_outcome),
    print_trace = false,
    rounding_on = false
)
    decision = :check_next
    i = 1
    n = length(decision_funcs)
    while decision == :check_next
        decision = decision_funcs[i](
            model,
            outcome_stage1,
            outcome1_stage2,
            outcome2_stage2,
            outcome1_prob_stage2;
            print_trace,
            rounding_on
        )
        i += decision == :check_next ? 1 : 0
        if i > n
            decision = :guess
        end
    end
    return decision
end
