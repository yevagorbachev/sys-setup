function add_unit(axis, unit)
    arguments
        axis (1,1) string {ismember(axis, ["x", "y", "z"])};
        unit (1,1) string;
    end

    ax = gca();
    ax = ax.(strcat(upper(axis), "Axis"));

    exponent = ax.Exponent;
    if (exponent == 0)
        t = "";
    else
        t = sprintf("$\\times 10^{%d}$", exponent);
    end
end
