__precompile__(true)

module Single
export single

"""
    single(x [,default])

Returns the one and single element of collection `x`, and throws an error if the collection
has zero or multiple elements. If `default` is provided, `default` is returned in the case of
an empty iterators instead of throwing an error. For iterators with more then one element,
an error is still thrown.
"""
function single end

# https://github.com/JuliaLang/julia/pull/25078
Base.@propagate_inbounds function single(iter)
    i0 = start(iter)
    @boundscheck if done(iter, i0)
        throw(ArgumentError("Collection is empty, must contain exactly one element"))
    end
    (ret, i1) = next(iter, i0)
    @boundscheck if !done(iter, i1)
        throw(ArgumentError("Collection has multiple elements, must contain exactly one element"))
    end
    ret
end

Base.@propagate_inbounds function single(iter, default)
    i0 = start(iter)
    @boundscheck if done(iter, i0)
        return default
    end
    (ret, i1) = next(iter, i0)
    @boundscheck if !done(iter, i1)
        throw(ArgumentError("Collection has multiple elements, must contain exactly one element"))
    end
    return ret
end

# Collections of known size
single(::Tuple{}, default) = default
single(x::Tuple{Any}) = x[1]
single(x::Tuple{Any}, default) = x[1]

single(a::AbstractArray{<:Any, 0}) = @inbounds return a[]

end # module
