function onepdf_all_figures(name, varargin)
	% name: file name (including file type)
	% varagin: passed to exportgraphics(h, name, ...)
	for (h = findobj("type", "figure")')
		fprintf("Saving Fig. %d to path %s\n", h.Number, name);
		exportgraphics(h, name, varargin{:}, Append = "true");
	end
end
