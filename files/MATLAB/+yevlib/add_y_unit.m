% add_x_unit(unit)
% add_x_unit(ax, unit)
function add_y_unit(varargin)
    import yevlib.add_unit
    switch nargin 
        case 1
            ax = gca;
            unit = varargin{1};
        case 2
            ax = varargin{1};
            unit = varargin{2};
    end

    add_unit(ax.YAxis, unit, @ysecondarylabel);
end
