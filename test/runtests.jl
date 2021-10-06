using PrintTools
using Test

@testset "PrintTools.jl" begin

    tfile = tempname()
    rm(tfile; force = true)
    token = string(rand(UInt))
    
    try
        # print functions
        for printfun in [
                print_inmw, println_inmw, print_ifmw, println_ifmw,
                tagprint_inmw, tagprintln_inmw, tagprint_ifmw, tagprintln_ifmw
            ]
            open(tfile, "w") do io
                printfun(io, token)
            end
            str = read(tfile, String)
            @test contains(str, token)
            rm(tfile; force = true)
        end
        
        # print err
        open(tfile, "w") do io
            try; error("ERROR: ", token)
                catch err; printerr(io, err) 
            end
        end
        str = read(tfile, String)
        @test contains(str, token)
        rm(tfile; force = true)

        # sci
        println("\nsci_str")
        for f in [1.0, rand() * 1e3, rand() * 1e-12]
            println(sci_str(f; d = 1))
            println(sci_str(f; d = 3))
            println(sci_str(f; d = 5))
            @test true
        end
        println()

    finally
        rm(tfile; force = true)
    end
end;