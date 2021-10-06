"""
    The id of the master worker
"""
MASTERW = 1
_set_MASTERW(w) = (global MASTERW = w)
set_MASTERW(MW::Int, ws::Vector{Int} = workers()) = 
    (remotecall_wait.([_set_MASTERW], ws, [MW]); MW)

print_inmw(io::IO, ss...) = (remotecall_wait(Base.print, MASTERW, io, ss...); nothing)
print_inmw(ss...) = (remotecall_wait(Base.print, MASTERW, ss...); nothing)
println_inmw(io::IO, ss...) = (remotecall_wait(Base.println, MASTERW, io, ss...); nothing)
println_inmw(ss...) = (remotecall_wait(Base.println, MASTERW, ss...); nothing)
print_ifmw(io::IO, ss...) = (myid() == MASTERW) ? Base.print(io, ss...) : nothing
print_ifmw(ss...) = (myid() == MASTERW) ? Base.print(ss...) : nothing
println_ifmw(io::IO, ss...) = (myid() == MASTERW) ? Base.println(io, ss...) : nothing
println_ifmw(ss...) = (myid() == MASTERW) ? Base.println(ss...) : nothing


function wtag(io::IO)
    ws = min(displaysize(io) |> last, 80) 
    return lpad(
        string( " Worker ", myid(), " (", getpid(), ") [", Time(now()), "] "), 
        ws, "-"
    )
end

_tagprint(printfun::Function, io::IO, ss...; tag::String = wtag(io)) = 
    !isempty(tag) ? printfun(io, tag, "\n", ss...) : printfun(io, ss...)
_tagprint(printfun::Function, ss...; kwargs...) = _tagprint(printfun, stdout, ss...; kwargs...)

tagprint(ss...; kwargs...) = _tagprint(print, ss...; kwargs...)
tagprintln(ss...; kwargs...) = _tagprint(println, ss...; kwargs...)

tagprint_inmw(ss...; tag::String = wtag(stdout)) = _tagprint(print_inmw, ss...; tag)
tagprintln_inmw(ss...; tag::String = wtag(stdout)) = _tagprint(println_inmw, ss...; tag)

tagprint_ifmw(ss...; tag::String = wtag(stdout)) = _tagprint(print_ifmw, ss...; tag)
tagprintln_ifmw(ss...; tag::String = wtag(stdout)) = _tagprint(println_ifmw, ss...; tag)