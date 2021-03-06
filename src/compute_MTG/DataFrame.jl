"""
    DataFrame(mtg::Node,vars::T[,type::Union{Union,DataType}=Any])

Convert an MTG into a DataFrame.

# Arguments

- `mtg::Node`: An mtg node (usually the root node).
- `key`: The key, or attribute name. Used to list the variables that must be added to the
`DataFrame`. It is given either as Symbols (faster) or String, or an Array of (or a Tuple).

# Examples

```julia
# Importing the mtg from the github repo:
mtg = read_mtg(download("https://raw.githubusercontent.com/VEZY/MTG.jl/master/test/files/simple_plant.mtg"))

DataFrame(mtg, :Length)
```
"""
function DataFrames.DataFrame(mtg::Node, key::T) where T <: Union{AbstractArray,Tuple}
    node_vec = get_printing(mtg)
    df = DataFrame(tree = node_vec)

    for var in key
        insertcols!(df, var => [descendants(mtg, var, self = true)...])
    end
    df
end

function DataFrames.DataFrame(mtg::Node, key::T) where T <: Symbol
    DataFrame([get_printing(mtg), [descendants(mtg, key, self = true)...]], [:tree,key])
end

function DataFrames.DataFrame(mtg::Node, key::T) where T <: AbstractString
    key = Symbol(key)
    DataFrame([get_printing(mtg), [descendants(mtg, key, self = true)...]], [:tree,key])
end
