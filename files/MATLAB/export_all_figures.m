function export_all_figures(name_fmt, varargin)
    % usage: export_all_figures(name_fmt, ...)
	% name_fmt: %1$d for number, %2$s for name -- must have extension
	% ... : passed to exportgraphics(h, filename, ...)
	% 	defaults to {"BackgroundColor", "none", "ContentType", "vector"} if empty

    % sort the array of figures by number
    handles = findobj("type", "figure")';
    nums = [handles.Number];
    [~, i] = sort(nums);
    handles = handles(i);

    % send the sorted array to files
	for h = handles
		filename = sprintf(name_fmt, h.Number, h.Name);
		fprintf("Saving Fig. %d to path %s\n", h.Number, filename);
		if isempty(varargin)
			varargin = {"BackgroundColor", "none", "ContentType", "vector"}; %#ok
		end
		exportgraphics(h, filename, varargin{:});
	end
end
