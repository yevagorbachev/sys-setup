% add_unit(ruler, unit, publisher)
%   ruler: NumericRuler to get Exponent and TickLabelInterpreter
%   unit: unit text
%   publisher: function to put the text -- probably (xyz)secondarylabel

function add_unit(ruler, unit, publisher)
    terp = get(ruler, "TickLabelInterpreter");
    switch terp
        case "none"
            set(ruler, "TickLabelInterpreter", "tex");
            label_fmt = "\\times 10^%d %s";
        case "tex"
            label_fmt = "\\times 10^%d %s";
        case "latex"
            label_fmt = "$\\times 10^%d \\> \\mathrm{%s}$";
    end

    ex = ruler.Exponent;
    if ex == 0
        text = unit;
    else
        text = sprintf(label_fmt, ex, unit);
    end
    publisher(text);
end
