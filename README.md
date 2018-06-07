# Single

Return the single element of a container. Stolen from [here](https://github.com/JuliaLang/julia/pull/25078).

```julia
julia> using Single

julia> single([])
ERROR: ArgumentError: Collection is empty, must contain exactly one element

julia> single(["TheHighlander"])
"TheHighlander"

julia> single([1,2])
ERROR: ArgumentError: Collection has multiple elements, must contain exactly one element

julia> single([], "default")
"default"
```
