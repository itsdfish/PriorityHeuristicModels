using SafeTestsets

files = filter(f -> f ≠ "runtests.jl", readdir(pwd()))
include.(files)
#include("test_priority_model.jl")
