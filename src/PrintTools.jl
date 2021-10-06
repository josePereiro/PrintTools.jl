module PrintTools

    using Distributed
    using Printf
    using Dates

    include("inmw.jl")
    include("sci.jl")
    include("printerr.jl")

    export printerr
    export sci_str
    export print_inmw, println_inmw, print_ifmw, println_ifmw,
            tagprint_inmw, tagprintln_inmw, tagprint_ifmw, tagprintln_ifmw

end
