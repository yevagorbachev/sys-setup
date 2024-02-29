% Create SimulationInput for given model, using struct of defaults, overriden by varargin
%   simin = simin_override(model, defaults, varargin)
%   model: name of simulink model
%   defaults: structure of default values
%   varargin: structure or name-value pairs
function si = simin_override(model, defaults, varargin)
    si = Simulink.SimulationInput(model);
    defaults = namedargs2cell(defaults);
    for i = 1:2:length(defaults)
        si = si.setVariable(defaults{i}, defaults{i+1});
    end

    if isstruct(varargin{1})
        overrides = namedargs2cell(varargin{1});
    else 
        overrides = varargin;       
    end

    for i = 1:2:length(overrides)
        si = si.setVariable(overrides{i}, overrides{i+1});
    end
end
