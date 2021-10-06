"""
    print the err text
"""
printerr(io::IO, err) = print(io, sprint(showerror, err, catch_backtrace()))
printerr(err) = printerr(stdout, err)