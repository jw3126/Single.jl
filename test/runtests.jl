using Single
using Base.Test

# custom iterator, that implements nothing except
# bare bones iteration protocol
struct MyRepeater{T}
    t::T
    length::Int
end

Base.start(iter::MyRepeater) = 1
Base.done(iter::MyRepeater, i) = (i > iter.length)
function Base.next(iter::MyRepeater, i)
    iter.t, 2
end

@testset "empty iterators" begin
    iters = [Dict(),
             [],
             (),
             MyRepeater("sad",0),
             Iterators.filter(x -> false, MyRepeater(1,1)),
             zeros(0,0,0)
            ]
    for iter in iters
        @test_throws ArgumentError single(iter)
        default = randn()
        @test single(iter, default) == default
    end
end

@testset "singleton iterators" begin
    iters = [Dict(1 => 2),
             [Float64[]],
             ("hi",),
             MyRepeater("sad",1),
             Iterators.filter(x -> true, MyRepeater(1,1)),
             zeros(1,1,1)
            ]

    for iter in iters
        @test single(iter) == first(iter)
        default = randn()
        @test single(iter, default) == single(iter)

        @inferred single(iter)
        default = first(iter)
        @inferred single(iter, default)
    end
end

@testset "big iterators" begin
    iters = [Dict(1 => 2, 2=>3),
             [[],nothing, ""],
             ("hi", "ho"),
             MyRepeater("sad",10),
             Iterators.filter(x -> true, MyRepeater(1,2)),
             zeros(1,1,2)
            ]
    for iter in iters
        @test_throws ArgumentError single(iter)
        default = randn()
        @test_throws ArgumentError single(iter,default)
    end
end
