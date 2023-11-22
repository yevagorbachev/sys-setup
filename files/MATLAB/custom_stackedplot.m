%% custom_stackedplot({tbl1, tbl2, ...}, legends=[leg1, leg2, ...][, specs=[spec1, spec2]])
function custom_stackedplot(tables, name_value_args)
    arguments
        tables (1, :) cell;
        name_value_args.legends (1, :) string ...
            {check_equal_size(tables, name_value_args.legends)};
        name_value_args.specs (1, :) string ...
            {check_equal_size(tables, name_value_args.specs)} = repmat("", 1, numel(tables));
    end
    % the regular stackedplot is nice but has barely any customization, so I wrote this

    % unpack from struct for convenience
    legends = name_value_args.legends;
    specs = name_value_args.specs;

    % get all of the unique names
    names = arrayfun(@(t) t{1}.Properties.VariableNames, tables, UniformOutput=false);
    names = string(unique(horzcat(names{:})));

    % create layout
    n_plots = length(names);
    tiledlayout(n_plots, 1, TileSpacing="tight");


    for i_plot = 1:n_plots
        nexttile(i_plot);
        hold on; grid on;
        plot_name = names(i_plot);

        for i_table = 1:length(tables)
            % grab the "current" legend, linespec, and tabl3
            leg = legends(i_table);
            spec = specs(i_table);
            tbl = tables{i_table};
            tbl_names = tbl.Properties.VariableNames;

            if leg == ""
                args = {"HandleVisibility", "off"};
            else
                args = {"DisplayName", leg};
            end

            name_cmp = strcmp(tbl_names, plot_name);
            % table might not contain this variable at all, so skip if it doesn't
            if ~any(name_cmp)
                continue;
            end

            plot(seconds(tbl.Time), tbl.(plot_name), spec, args{:});

            % add units if they are defined
            plot_unit = tbl.Properties.VariableUnits{name_cmp};
            if plot_unit ~= ""
                scale_text = get_multiplier_text(gca().YAxis); % preserve exponent
                ysecondarylabel(strcat(scale_text, " ", plot_unit));
            end
                
            % can't just index, because the property could be empty, so check whether it is
            descriptions = tbl.Properties.VariableDescriptions;
            if ~isempty(descriptions) && descriptions{name_cmp} ~= ""
                % if the description exists and is non-empty, use it as the variable name
                ylabel(descriptions{name_cmp});
            else
                % use the table variable name (monospaced)
                ylabel(sprintf("\\verb|%s|", plot_name));
            end
        end

        % take the ticks off of all plots except the last
        if (i_plot ~= n_plots)
            set(gca(), XTickLabel = []);
        end
    end

    % create legend
    nexttile(1);
    legend(Location="northoutside", Orientation="horizontal");

    % create time axis
    nexttile(n_plots);
    xlabel("Time"); 
    scale_text = get_multiplier_text(gca().XAxis);
    xsecondarylabel(strcat(scale_text, " ", "sec"));

end

function t = get_multiplier_text(ax)
    exponent = ax.Exponent;
    if (exponent == 0)
        t = "";
    else
        t = sprintf("$\\times 10^{%d}$", exponent);
    end
end
function check_equal_size(x, y)
    if numel(x) ~= numel(y)
        eid = 'Size:notEqual';
        msg = "Arguments must have the same size.";
        throwAsCaller(MException(eid, msg))
    end
end
