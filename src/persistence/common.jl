abstract type AbstractGraphFormat end

"""
    loadgraph(file, gname="graph", format=LGFormat())

Read a graph named `gname` from `file` in the format `format`.

### Implementation Notes
`gname` is graph-format dependent and is only used if the file contains
multiple graphs; if the file format does not support multiple graphs, this
value is ignored. The default value may change in the future.
"""
function loadgraph(fn::AbstractString, gname::AbstractString, format::AbstractGraphFormat)
    GZip.open(fn, "r") do io
        loadgraph(io, gname, format)
    end
end

# loadgraph with a name but without a format
loadgraph(fn::AbstractString, gname::AbstractString) = loadgraph(fn, gname, LGFormat())

# loadgraph without a name but with an optional format.
loadgraph(fn::AbstractString, format::AbstractGraphFormat=LGFormat()) = loadgraph(fn, "graph", format)



"""
    loadgraphs(file, format=LGFormat)

Load multiple graphs from `file` in the format `format`.
Return a dictionary mapping graph name to graph.

### Implementation Notes
For unnamed graphs the default name \"graph\" will be used. This default
may change in the future.
"""
function loadgraphs(fn::AbstractString, format::AbstractGraphFormat=LGFormat())
    GZip.open(fn, "r") do io
        loadgraphs(io, format)
    end
end


"""
    savegraph(file, g, gname="graph", format=LGFormat(); compress=true)

Saves a graph `g` with name `gname` to `file` in the format `format`.
If `compress = true`, use GZip compression when writing the file.
Return the number of graphs written.

### Implementation Notes
The default graph name assigned to `gname` may change in the future.
"""
function savegraph(
    fn::AbstractString, g::AbstractGraph, 
    gname::AbstractString="graph", 
    format::AbstractGraphFormat=LGFormat(); 
    compress=true
    )
    openfn = compress ? GZip.open : open
    retval = -1
    openfn(fn, "w") do io
        retval = savegraph(io, g, gname, format)
    end
    return retval
end

# save a graph without a name but with a format
savegraph(fn::AbstractString, g::AbstractGraph, format::AbstractGraphFormat; compress=true) = savegraph(fn, g, "graph", format; compress=compress)
"""
    savegraph(file, d, format=LGFormat(); compress=true)

Save a dictionary of `graphname => graph` to `file` in the format `format`.
If `compress = true`, use GZip compression when writing the file.
Return the number of graphs written.

### Implementation Notes
Will only work if the file format supports multiple graph types.
"""
function savegraph(fn::AbstractString, d::Dict{T,U},
    format::AbstractGraphFormat=LGFormat(); compress=true) where T<:AbstractString where U<:AbstractGraph
    openfn = compress ? GZip.open : open
    retval = -1
    openfn(fn, "w") do io
        retval = savegraph(io, d, format)
    end
    return retval
end
