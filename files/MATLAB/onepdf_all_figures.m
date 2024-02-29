function onepdf_all_figures(name, varargin)
	% name: file name (including file type)
	% varagin: passed to exportgraphics(h, name, ...)
    figs = findobj(type = "figure");
    [~, si] = sort([figs.Number]);
	for i = 1:length(si)
        fig = figs(si(i));
		fprintf("Saving Fig. %d to path %s\n", fig.Number, name);
		exportgraphics(fig, name, varargin{:}, Append = true);
	end
end
