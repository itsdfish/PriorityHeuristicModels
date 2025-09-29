@safetestset "round_to_prominent" begin
    using PriorityHeuristicModels
    using Test

    @test round_to_prominent(0) == 0
    @test round_to_prominent(3) == 2
    @test round_to_prominent(6) == 5
    @test round_to_prominent(30) == 20
    @test round_to_prominent(90) == 100
    @test round_to_prominent(400) == 500
end
