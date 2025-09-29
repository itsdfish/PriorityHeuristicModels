@safetestset "priority model" begin
    @safetestset "compute_probs_max_outcome" begin
        @safetestset "sum to 1 (1)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.10,
                σmin = 0.10,
                σprob = 0.10,
                δoutcome = 0.10,
                δprob = 0.10
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            decision_probs =
                [compute_probs_max_outcome(model, t, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ -eps(), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [compute_probs_max_outcome(model, a, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ -eps(), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end

        @safetestset "sum to 1 (2)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.20,
                σmin = 0.20,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.20
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            decision_probs =
                [compute_probs_max_outcome(model, t, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ -eps(), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [compute_probs_max_outcome(model, a, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ -eps(), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end
    end

    @safetestset "compute_probs_min_outcome" begin
        @safetestset "sum to 1 (1)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.10,
                σmin = 0.10,
                σprob = 0.10,
                δoutcome = 0.10,
                δprob = 0.10
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            decision_probs =
                [compute_probs_max_outcome(model, t, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [compute_probs_min_outcome(model, a, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end

        @safetestset "sum to 1 (2)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.20,
                σmin = 0.20,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.20
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            decision_probs =
                [compute_probs_min_outcome(model, t, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [compute_probs_min_outcome(model, a, t, a) for a ∈ aircraft, t ∈ targets]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end
    end

    @safetestset "compute_probs_min_outcome_prob" begin
        @safetestset "sum to 1 (1)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.10,
                σmin = 0.10,
                σprob = 0.10,
                δoutcome = 0.10,
                δprob = 0.10
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            probs = range(0, 1, length = 100)
            decision_probs =
                [
                    compute_probs_min_outcome_prob(model, t, t, a, p) for a ∈ aircraft,
                    t ∈ targets, p ∈ probs
                ]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [
                    compute_probs_min_outcome_prob(model, a, t, a, p) for a ∈ aircraft,
                    t ∈ targets, p ∈ probs
                ]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end

        @safetestset "sum to 1 (2)" begin
            using PriorityHeuristicModels
            using Test

            model = PriorityModel(;
                σmax = 0.20,
                σmin = 0.20,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.20
            )

            targets = range(0, 101, length = 500)
            aircraft = range(0, -100, length = 500)
            probs = range(0, 1, length = 100)

            decision_probs =
                [
                    compute_probs_min_outcome_prob(model, t, t, a, p) for a ∈ aircraft,
                    t ∈ targets, p ∈ probs
                ]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)

            decision_probs =
                [
                    compute_probs_min_outcome_prob(model, a, t, a, p) for a ∈ aircraft,
                    t ∈ targets, p ∈ probs
                ]
            @test all(x -> all(y -> y ≥ (0 - eps()), x), decision_probs)
            @test all(x -> sum(x) ≈ 1, decision_probs)
        end
    end
end

@safetestset "compute_probs_min_outcome" begin
    using PriorityHeuristicModels
    using Distributions
    using Random 
    using Test
    Random.seed!(54874)

    σmax = 0.20
    σmin = 0.2
    σprob = 0.20
    δoutcome = 0.20
    δprob = 0.10
    model = PriorityModel(;
        σmax,
        σmin,
        σprob,
        δoutcome,
        δprob,
    )
    outcome_stage1 = 0
    outcome1_stage2 = 10
    outcome2_stage2 = -5

    #p = [safe,risky, next]
    p = compute_probs_min_outcome(model, outcome_stage1, outcome1_stage2, outcome2_stage2; print_trace = false)
    # safe 
    z1 = (outcome2_stage2 - 0 + δoutcome * outcome1_stage2) / (σmin * outcome1_stage2)
    p1 = 1 - cdf(Normal(0, 1), z1)
    @test p1 ≈ p[1] 

    # risky 
    z2 = (outcome2_stage2 - 0 - δoutcome * outcome1_stage2) / (σmin * outcome1_stage2)
    p2 = cdf(Normal(0, 1), z2)
    @test p2 ≈ p[2] 
    # next 
    @test 1 - p1 - p2 ≈ p[3]


    x = rand(Normal(outcome2_stage2, σmin * outcome1_stage2), 100_000)
    p_est_safe = mean(x .< -δoutcome * outcome1_stage2)
    p_est_risky = mean(x .> δoutcome * outcome1_stage2)
    p_est_next = 1 - p_est_risky - p_est_safe

    @test p1 ≈ p_est_safe rtol = .05
    @test p2 ≈ p_est_risky atol = .001

    # using Plots 
    # using Distributions
    # # risky 
    # x1 = -5
    # # safe
    # x2 = 0
    # diff = x1 - x2
    # σ = .2 * 10
    # δ = 10 *.20 
    # x = range(-12, 5, length = 300)
    # dens = pdf.(Normal(diff, σ), x)
    # plot(x, dens)
    # vline!([δ], linestyle = :dash, color = :black)
    # vline!([-δ], linestyle = :dash, color = :black)
end

@safetestset "compute_probs_min_outcome_prob" begin
    using PriorityHeuristicModels
    using Distributions
    using Random 
    using Test
    Random.seed!(5144)

    σmax = 0.20
    σmin = 0.2
    σprob = 0.20
    δoutcome = 0.20
    δprob = 0.15

    model = PriorityModel(;
        σmax,
        σmin,
        σprob,
        δoutcome,
        δprob,
    )
    outcome_stage1 = 0
    outcome1_stage2 = 10
    outcome2_stage2 = -5
    outcome1_prob_stage2 = .08


    #p = [safe,risky, next]
    p = compute_probs_min_outcome_prob(model, outcome_stage1, outcome1_stage2, outcome2_stage2, outcome1_prob_stage2; print_trace = false)
    
    # safe 
    z1 = (1 - (1 - outcome1_prob_stage2) + δprob)
    p1 = 1 - cdf(truncated(Normal(0,  σprob), -1, 1), z1)
    @test p1 ≈ p[1] atol = 1e-5 

    # risky 
    z2 = (1 - (1 - outcome1_prob_stage2) - δprob)
    p2 = cdf(truncated(Normal(0, σprob), -1, 1), z2)
    @test p2 ≈ p[2] atol = 1e-5


    x = rand(truncated(Normal(1 - (1 - outcome1_prob_stage2), σprob),-1, 1), 100_000)
    p_est_safe = mean(x .< -δprob)
    p_est_risky = mean(x .> δprob)
    p_est_next = 1 - p_est_risky - p_est_safe

    @test p[1] ≈ p_est_safe atol = .002
    @test p[2] ≈ p_est_risky atol = .002
    @test p[3] ≈ p_est_next atol = .002
    @test sum(p) ≈ 1

    # using Plots 
    # using Distributions
    # # risky 
    # p_r = (1 - outcome1_prob_stage2)
    # # safe
    # p_s = 1
    # diff = p_s - p_r
    # x = range(-1, 1, length = 300)
    # dens = pdf.(truncated(Normal(diff, σprob), -1, 1), x)
    # plot(x, dens, xlabel = "pₛ - pᵣ ↑ increases p_risky")
    # vline!([δprob], linestyle = :dash, color = :black)
    # vline!([-δprob], linestyle = :dash, color = :black)
end

@safetestset "compute_probs_max_outcome" begin
    using PriorityHeuristicModels
    using Distributions
    using Random 
    using Test
    Random.seed!(6414)

    σmax = 0.30
    σmin = 0.2
    σprob = 0.20
    δoutcome = 0.05
    δprob = 0.10
    model = PriorityModel(;
        σmax,
        σmin,
        σprob,
        δoutcome,
        δprob,
    )
    outcome_stage1 = 0
    outcome1_stage2 = 3
    outcome2_stage2 = -5

    #p = [safe,risky]
    p = compute_probs_max_outcome(model, outcome_stage1, outcome1_stage2, outcome2_stage2; print_trace = false)
    # safe 
    z1 = (outcome1_stage2 - 0) / (σmax * abs(outcome2_stage2))
    p1 = 1 - cdf(Normal(0, 1), z1)
    @test p1 ≈ p[1] 

    # risky 
    p2 = cdf(Normal(0, 1), z1)
    @test p2 ≈ p[2] 

    x = rand(Normal(outcome1_stage2, σmax * abs(outcome2_stage2)), 100_000)
    p_est_safe = mean(x .< 0)
    p_est_risky = mean(x .> 0)

    @test p1 ≈ p_est_safe rtol = .05
    @test p2 ≈ p_est_risky atol = .001
end

@safetestset "sanity checks" begin
    @safetestset "compute_probs_min_outcome" begin
        using PriorityHeuristicModels
        using Test

        model = PriorityModel(;
            σmax = 0.20,
            σmin = 0.2,
            σprob = 0.20,
            δoutcome = 0.20,
            δprob = 0.10
        )

        # prob_risky should be low because 0 - (-5) > .10 * 10
        p1 = compute_probs_min_outcome(model, 0, 10, -5; print_trace = false)
        # prob_safe should be high
        @test p1[1] > 0.90
    
        @test p1[2] < 0.10

        p2 = compute_probs_min_outcome(model, 0, 10, -1; print_trace = false)
        # making decreasing min outcome of risky should make prob of selecting safe less likely
        @test p2[1] < p1[1]
        # making decreasing min outcome of risky should make prob of selecting risky more likely
        @test p2[2] > p1[2]
    end

    @safetestset "compute_probs_min_outcome_prob" begin
        using PriorityHeuristicModels
        using Test

        model = PriorityModel(;
            σmax = 0.20,
            σmin = 0.20,
            σprob = 0.20,
            δoutcome = 0.20,
            δprob = 0.10
        )

        # p_min_safe = 1, p_min_risky = 1 - .90 = .10
        p1 = compute_probs_min_outcome_prob(model, 0, 10, -5, 0.90; print_trace = false)
        # prob_safe should be low
        @test p1[1] < 0.10
        # prob_risky should be high 
        @test p1[2] > 0.90

        # p_min_safe = 1, p_min_risky = 1 - .05 = .95
        p2 = compute_probs_min_outcome_prob(model, 0, 10, -5, 0.05; print_trace = false)
        # making the p_mins closer should decrease the probability of risky
        @test p2[2] < p1[2]
        # making the p_mins closer should increase the probability of safe
        @test p2[1] > p1[1]

        # using Plots 
        # using Distributions
        # # risky 
        # x1 = .95
        # # safe
        # x2 = 1
        # diff = x1 - x2
        # σ = .20 
        # δ = .10 
        # x = range(-2, 2, length = 200)
        # dens = pdf.(Normal(diff, σ), x)
        # plot(x, dens)
        # vline!([δ], linestyle = :dash, color = :black)
        # vline!([-δ], linestyle = :dash, color = :black)
    end

    @safetestset "logpdf" begin
        @safetestset "δoutcome" begin
            using PriorityHeuristicModels
            using Random
            using Test

            Random.seed!(642)

            parms = (
                σmax = 0.2,
                σmin = 0.2,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.15,
                p_rep = 0.30
            )

            model = PriorityModel(; parms...)

            n_trials = 20_000

            outcome_stage1 = 10.0
            outcome1_stage2 = 5
            outcome2_stage2 = -5
            outcome1_prob_stage2 = 0.50

            data = rand(
                model,
                outcome_stage1,
                outcome1_stage2,
                outcome2_stage2,
                outcome1_prob_stage2,
                n_trials
            )

            δoutcomes = range(parms.δoutcome * 0.80, parms.δoutcome * 1.2, length = 100)
            LLs = map(
                δoutcome ->
                    logpdf(
                        PriorityModel(; parms..., δoutcome),
                        outcome_stage1,
                        outcome1_stage2,
                        outcome2_stage2,
                        outcome1_prob_stage2,
                        data
                    ),
                δoutcomes
            )
            _, max_i = findmax(LLs)
            @test parms.δoutcome ≈ δoutcomes[max_i] rtol = 0.1
        end

        @safetestset "σmin" begin
            using PriorityHeuristicModels
            using Random
            using Test

            Random.seed!(25)

            parms = (
                σmax = 0.2,
                σmin = 0.2,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.15,
                p_rep = 0.30
            )

            model = PriorityModel(; parms...)

            n_trials = 20_000

            outcome_stage1 = 5.0
            outcome1_stage2 = 5
            outcome2_stage2 = -5
            outcome1_prob_stage2 = 0.50

            data = rand(
                model,
                outcome_stage1,
                outcome1_stage2,
                outcome2_stage2,
                outcome1_prob_stage2,
                n_trials
            )

            σmins = range(parms.σmin * 0.80, parms.σmin * 1.2, length = 100)
            LLs = map(
                σmin ->
                    logpdf(
                        PriorityModel(; parms..., σmin),
                        outcome_stage1,
                        outcome1_stage2,
                        outcome2_stage2,
                        outcome1_prob_stage2,
                        data
                    ),
                σmins
            )
            _, max_i = findmax(LLs)
            @test parms.σmin ≈ σmins[max_i] rtol = 0.02
        end

        @safetestset "p_rep" begin
            using PriorityHeuristicModels
            using Random
            using Test

            Random.seed!(654)

            parms = (
                σmax = 0.20,
                σmin = 0.20,
                σprob = 0.20,
                δoutcome = 0.20,
                δprob = 0.15,
                p_rep = 0.25
            )

            model = PriorityModel(; parms...)

            n_trials = 20_000

            outcome_stage1 = -5.0
            outcome1_stage2 = 5
            outcome2_stage2 = -5
            outcome1_prob_stage2 = 0.50

            data = rand(
                model,
                outcome_stage1,
                outcome1_stage2,
                outcome2_stage2,
                outcome1_prob_stage2,
                n_trials
            )

            p_reps = range(parms.p_rep * 0.80, parms.p_rep * 1.2, length = 100)
            LLs = map(
                p_rep ->
                    logpdf(
                        PriorityModel(; parms..., p_rep),
                        outcome_stage1,
                        outcome1_stage2,
                        outcome2_stage2,
                        outcome1_prob_stage2,
                        data
                    ),
                p_reps
            )
            _, max_i = findmax(LLs)
            @test parms.p_rep ≈ p_reps[max_i] rtol = 0.05
        end
    end

    @safetestset "sum to 1 predict_joint_probs" begin
        using PriorityHeuristicModels
        using PriorityHeuristicModels: predict_joint_probs
        using Random
        using Test

        Random.seed!(654)
        for _ ∈ 1:100
            model = PriorityModel(;
                σmax = 0.10,
                σmin = 0.10,
                σprob = 0.10,
                δoutcome = 0.10,
                δprob = 0.10,
                p_rep = rand()
            )

            p = predict_joint_probs(model, rand(2)...)
            @test sum(p) ≈ 1
        end
    end
end
