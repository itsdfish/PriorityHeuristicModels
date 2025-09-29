
@safetestset "compute_max_outcome" begin
    using PriorityHeuristicModels
    using PriorityHeuristicModels: compute_max_outcome
    using Test

    @test compute_max_outcome(-1, 0) == -1
    @test compute_max_outcome(-1, -2) == -2
    @test compute_max_outcome(1, 0) == 1
    @test compute_max_outcome(1, 2) == 2
    @test compute_max_outcome(-1, 2) == 2
end

@safetestset "compute_min_outcome" begin
    using PriorityHeuristicModels
    using PriorityHeuristicModels: compute_min_outcome
    using Test

    @test compute_min_outcome(-1, 0) == 0
    @test compute_min_outcome(-1, -2) == -1
    @test compute_min_outcome(1, 0) == 0
    @test compute_min_outcome(1, 2) == 1
    @test compute_min_outcome(-1, 2) == -1
end

@safetestset "compute_min_outcome" begin
    @safetestset "xᵢ = xₐ" begin
        using PriorityHeuristicModels
        using PriorityHeuristicModels: compute_min_outcome
        using Test

        targets = range(0, 100, length = 500)
        money = range(0, -100, length = 500)
        for a ∈ money, t ∈ targets
            xᵢ = a
            xₜ = t
            xₐ = a
            min_outcome = compute_min_outcome(xᵢ + xₜ, xᵢ + xₐ)
            if (abs(xₐ) ≥ xₜ) && (xᵢ == xₐ)
                #println("xᵢ = $xᵢ, xₜ = $xₜ, xₐ = $xₐ, xᵢ + xₐ = $(xᵢ + xₐ), xᵢ + xₜ = $(xᵢ + xₜ)")
                @test min_outcome == xₐ + xₜ
            elseif (xₜ ≈ 0) && (xᵢ == xₜ)
                @test min_outcome == 0
            else
                #println("xᵢ = $xᵢ, xₜ = $xₜ, xₐ = $xₐ, xᵢ + xₐ = $(xᵢ + xₐ), xᵢ + xₜ = $(xᵢ + xₜ)")
                @test min_outcome == xᵢ + xₐ
            end
        end
    end
    @safetestset "xᵢ = xₜ" begin
        using PriorityHeuristicModels
        using PriorityHeuristicModels: compute_min_outcome
        using Test

        targets = range(0, 100, length = 500)
        money = range(0, -100, length = 500)

        for a ∈ money, t ∈ targets
            xᵢ = t
            xₜ = t
            xₐ = a
            min_outcome = compute_min_outcome(xᵢ + xₜ, xᵢ + xₐ)
            if (abs(xₐ) ≥ xₜ) && (xᵢ == xₐ)
                #println("xᵢ = $xᵢ, xₜ = $xₜ, xₐ = $xₐ, xᵢ + xₐ = $(xᵢ + xₐ), xᵢ + xₜ = $(xᵢ + xₜ)")
                @test min_outcome == xₐ + xₜ
            elseif (xₜ ≈ 0) && (xᵢ == xₜ)
                #println("xᵢ = $xᵢ, xₜ = $xₜ, xₐ = $xₐ, xᵢ + xₐ = $(xᵢ + xₐ), xᵢ + xₜ = $(xᵢ + xₜ)")
                @test min_outcome == 0
            else
                #println("xᵢ = $xᵢ, xₜ = $xₜ, xₐ = $xₐ, xᵢ + xₐ = $(xᵢ + xₐ), xᵢ + xₜ = $(xᵢ + xₜ)")
                @test min_outcome == xᵢ + xₐ
            end
        end
    end
end

@safetestset "compute_max_outcome" begin
    @safetestset "xᵢ = xₐ" begin
        using PriorityHeuristicModels
        using PriorityHeuristicModels: compute_max_outcome
        using Test

        targets = range(0, 100, length = 500)
        money = range(0, -100, length = 500)
        for a ∈ money, t ∈ targets
            xᵢ = a
            xₜ = t
            xₐ = a
            max_outcome = compute_max_outcome(xᵢ + xₜ, xᵢ + xₐ)
            if (abs(xₐ) ≥ xₜ && xᵢ == xₐ)
                #println("A xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ 2 * xₐ
            elseif (xₜ ≈ 0)
                #println("B xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ xₐ
            else
                #println("C xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ (xᵢ + xₜ)
            end
        end
    end

    @safetestset "xᵢ = xₜ" begin
        using PriorityHeuristicModels
        using PriorityHeuristicModels: compute_max_outcome
        using Test

        targets = range(0, 100, length = 500)
        money = range(0, -100, length = 500)
        for a ∈ money, t ∈ targets
            xᵢ = t
            xₜ = t
            xₐ = a
            max_outcome = compute_max_outcome(xᵢ + xₜ, xᵢ + xₐ)
            if (abs(xₐ) ≥ xₜ && xᵢ == xₐ)
                #println("A xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ 2 * xₐ
            elseif (xₜ ≈ 0)
                #println("B xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ xₐ
            else
                #println("C xᵢ $xᵢ xₜ $xₜ xₐ $xₐ xᵢ + xₐ $(xᵢ + xₐ) xᵢ + xₜ $(xᵢ + xₜ) max_outcome $max_outcome")
                @test max_outcome ≈ (xᵢ + xₜ)
            end
        end
    end
end

@safetestset "deterministic priority heuristic" begin
    @safetestset "decide_min_outcome" begin
        @safetestset "Stage 1 targets destroyed" begin
            using PriorityHeuristicModels
            using Test

            # Case 1: Stage 1 targets destroyed 
            # assuming xᵢ = xₜ
            # retreat if xₐ ≤ -.20 xₜ if xₐ ≠ 0, xₜ ≠ 0

            model = PriorityHeuristic()
            targets = range(0, 101, length = 500)
            money = range(0, -100, length = 500)
            for a ∈ money, t ∈ targets
                if (a ≠ 0) && (t ≠ 0) && (a ≤ -0.20 * t)
                    @test decide_min_outcome(model, t, t, a) == :retreat
                else
                    @test decide_min_outcome(model, t, t, a) == :check_next
                end
            end
        end

        @safetestset "Stage 1 money lost" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: decide_min_outcome
            using Test

            # Case 1: Stage 1 money lost 
            # assuming xᵢ = xₐ
            # retreat if xₐ ≤ -1/11 xₜ if |xₐ| < xₜ

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            # simplified conditions
            for a ∈ money, t ∈ targets
                if (a ≲ -1 / 11 * t) && (abs(a) < t)
                    #println("a $a t $t")
                    @test decide_min_outcome(model, a, t, a) == :retreat
                elseif (abs(a) ≲ 5 * t) && (abs(a) ≳ t) && (a ≠ 0) && (t ≠ 0)
                    #println("a $a t $t")
                    @test decide_min_outcome(model, a, t, a) == :attack
                else
                    @test decide_min_outcome(model, a, t, a) == :check_next
                end
            end

            # equivalent, but similar to conditions in text
            for a ∈ money, t ∈ targets
                if (a ≲ -1 / 11 * t) && (abs(a) < t)
                    #println("a $a t $t")
                    @test decide_min_outcome(model, a, t, a) == :retreat
                elseif (a > -1 / 11 * t) && (abs(a) < t)
                    #println("a $a t $t")
                    @test decide_min_outcome(model, a, t, a) == :check_next
                elseif (abs(a) ≲ 5 * t) && (abs(a) ≳ t) && (a ≠ 0) && (t ≠ 0)
                    #println("a $a t $t")
                    @test decide_min_outcome(model, a, t, a) == :attack
                elseif (abs(a) ≲ 5 * t) && (abs(a) ≳ t) && (a == 0) && (t == 0)
                    @test decide_min_outcome(model, a, t, a) == :check_next
                elseif (abs(a) ≳ t) && ((abs(a) > 5 * t) || (a == 0) || (t == 0))
                    @test decide_min_outcome(model, a, t, a) == :check_next
                else
                    #println("a $a t $t decision $(decide_min_outcome(model, a, t, a))")
                    @test false
                end
            end
        end
    end

    @safetestset "decide_min_outcome_prob" begin
        @safetestset "compute_outcomes_min_probs 1" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.0:0.1:1
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                p = compute_outcomes_min_probs(model, a, t, a, p_t)[end]
                if abs(a) ≳ t
                    @test p == p_t
                else
                    @test p == (1 - p_t)
                end
            end
        end

        @safetestset "compute_outcomes_min_probs 2" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.0:0.1:1
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                p = compute_outcomes_min_probs(model, t, t, a, p_t)[end]
                if t == 0
                    @test p == p_t
                else
                    @test p == (1 - p_t)
                end
            end
        end

        @safetestset "Stage 1 outcomes are targets 1" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0:0.01:0.1
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, t, t, a, p_t)
                p = compute_outcomes_min_probs(model, t, t, a, p_t)[end]
                if t == 0
                    @test decision == :attack
                    @test p ≤ 0.90
                else
                    @test decision == :check_next
                    @test p ≳ 0.90
                end
            end
        end

        @safetestset "Stage 1 outcomes are targets 2" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.9:0.01:1
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, t, t, a, p_t)
                p = compute_outcomes_min_probs(model, t, t, a, p_t)[end]
                if t == 0
                    @test p ≳ 0.90
                    @test decision == :check_next
                else
                    @test decision == :attack
                    @test p ≤ 0.90
                end
            end
        end

        @safetestset "Stage 1 outcomes are targets 3" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.11:0.05:0.89
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, t, t, a, p_t)
                p = compute_outcomes_min_probs(model, t, t, a, p_t)[end]
                @test decision == :attack
                @test p ≤ 0.90
            end
        end

        @safetestset "Stage 1 outcomes are money 1" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.0:0.01:0.10
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, a, t, a, p_t)
                p = compute_outcomes_min_probs(model, a, t, a, p_t)[end]
                if abs(a) ≳ t
                    @test decision == :attack
                    @test p ≤ 0.90
                else
                    @test decision == :check_next
                    @test p ≳ 0.90
                end
            end
        end

        @safetestset "Stage 1 outcomes are money 2" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.90:0.01:1
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, a, t, a, p_t)
                p = compute_outcomes_min_probs(model, a, t, a, p_t)[end]
                if abs(a) ≳ t
                    @test decision == :check_next
                    @test p ≳ 0.90
                else
                    @test decision == :attack
                    @test p ≤ 0.90
                end
            end
        end

        @safetestset "Stage 1 outcomes are money 3" begin
            using PriorityHeuristicModels
            using PriorityHeuristicModels: compute_outcomes_min_probs
            using Test

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            p_ts = 0.11:0.05:0.89
            for p_t ∈ p_ts, a ∈ money, t ∈ targets
                decision = decide_min_outcome_prob(model, a, t, a, p_t)
                p = compute_outcomes_min_probs(model, a, t, a, p_t)[end]
                @test decision == :attack
                @test p ≤ 0.90
            end
        end
    end

    @safetestset "compute_max_outcome" begin
        @safetestset "Case 1: Stage 1 targets destroyed" begin
            using PriorityHeuristicModels
            using Test

            # Case 1: Stage 1 targets destroyed 
            # assuming xᵢ = xₜ
            # retreat if xₜ = 0, xₐ ≠ 0
            # attack if xₜ ≠ 0
            # check next otherwise 

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)
            for a ∈ money, t ∈ targets
                if (t == 0) && (a ≠ 0)
                    @test decide_max_outcome(model, t, t, a) == :retreat
                elseif (t ≠ 0)
                    @test decide_max_outcome(model, t, t, a) == :attack
                else
                    @test decide_max_outcome(model, t, t, a) == :check_next
                end
            end
        end

        @safetestset "Case 2: Stage 1 money lost" begin
            using PriorityHeuristicModels
            using Test

            # Case 2: Stage 1 money lost
            # assuming xᵢ = xₐ
            # retreat if -xₐ 
            # attack if xₜ ≤ 9xₜ, such that |xₐ| < xₜ
            # check next otherwise 

            model = PriorityHeuristic()
            targets = range(0, 100, length = 500)
            money = range(0, -100, length = 500)

            # simpler way to express in code
            for a ∈ money, t ∈ targets
                if (abs(a) < t) && (a ≲ 9 * t)
                    @test decide_max_outcome(model, a, t, a) == :attack
                elseif (abs(a) ≳ t) && (a ≠ 0)
                    @test decide_max_outcome(model, a, t, a) == :retreat
                else
                    @test decide_max_outcome(model, a, t, a) == :check_next
                end
            end
            # equivalent but more consistent with paper
            for a ∈ money, t ∈ targets
                if (abs(a) < t) && (a ≲ 9 * t)
                    @test decide_max_outcome(model, a, t, a) == :attack
                elseif (abs(a) < t) && !(a ≲ 9 * t)
                    @test decide_max_outcome(model, a, t, a) == :check_next
                elseif (abs(a) ≳ t) && (a ≠ 0)
                    @test decide_max_outcome(model, a, t, a) == :retreat
                elseif (abs(a) ≳ t) && !(a ≠ 0)
                    @test decide_max_outcome(model, a, t, a) == :check_next
                else
                    @test false
                end
            end
        end
    end
end
