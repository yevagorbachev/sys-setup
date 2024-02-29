% Usage: tt_utl.convert(tt, from, to, fun)
%   tt:     input timetable
%   from:   unit to convert 
%   to:     unit to convert all "from" to
%   fun:    function to use to convert (must output same-size output!)
function tt = convert(tt, from, to, fun)
    arguments 
        tt timetable;
        from (1,1) string;
        to (1,1) string;
        fun function_handle;
    end

    from_cols = tt.Properties.VariableUnits == from;
    
    if ~any(from_cols)
        error("Unit ""%s"" does not exist in the input timetable", from);
    end

    tt{:, from_cols} = fun(tt{:, from_cols});
    tt.Properties.VariableUnits(from_cols) = to;
end
