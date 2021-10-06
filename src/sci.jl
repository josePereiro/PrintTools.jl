const _SCI_FUN_POOL = Dict{Int, Symbol}()
let
    empty!(_SCI_FUN_POOL)
    ds = 1:10
    for d in ds
        srtf = "%0.$(d)e"
        fun = Symbol("_sci", d)
        @eval begin
            $fun(n) = @sprintf($srtf, n)
        end
        _SCI_FUN_POOL[d] = fun
    end
end

function sci_str(n; d::Int = 1) 
    d = clamp(d, 1, 10)
    scifun = getproperty(@__MODULE__, _SCI_FUN_POOL[d])
    scifun(n)
end