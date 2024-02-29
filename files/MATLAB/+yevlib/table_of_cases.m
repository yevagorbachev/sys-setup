% table_of_cases(Name, ListOfValues)  
% Turn each name-list pair into a table with all of the combinations
function cases = table_of_cases(varargin)
    keys = 1:2:length(varargin);
    names = [varargin{keys}];
    values = 2:2:length(varargin);
    cases = combinations(varargin{values});
    cases.Properties.VariableNames = names;

    cases.Properties.RowNames = compose("Case %d", (1:height(cases))');
end

% turn the values into a name - very clunky
% row_name_fmt = join(repmat("%s = %%s", size(names)), "; ");
% row_num_fmt = compose(row_name_fmt, names);
% now fill in numbers (extra % delays the filling-in to the next compose() call)
% cases.Properties.RowNames = compose(row_num_fmt, cases.Variables);
