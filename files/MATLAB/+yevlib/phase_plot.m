% Usage: phase_plot(x, y, ds, sz, ...)
% x: vector of x values
% y: vector of y values (same size)
% ds: arrow spacing (x,y must allow for at least one arrow)
% sz: size of each arrow
% ... (varargin): passed to plot() and plot_triangles()
function phase_plot(x, y, ds, sz, varargin)
    dx = diff(x);
    dy = diff(y);
    point_distances = sqrt(dx .^ 2 + dy .^ 2);
    travel_length = [0; cumsum(point_distances)]; % distance of every point from start

    n_arrows = floor(max(travel_length) / ds);
    % find the indices that split up the travel length into equally spaced points
    [point_interval_number, ~] = discretize(travel_length, n_arrows); 

    % put arrows wherever the point interval number changes (wherever diff=/=0)
    arrow_indices = find(diff(point_interval_number)); 
    theta = atan2(dy(arrow_indices), dx(arrow_indices)); % calculate the heading of each arrow
    ax = x(arrow_indices);
    ay = y(arrow_indices);
    
    % plot
    gchold = ishold(); % remember hold state to put it back the way it was
    line = plot(x, y, varargin{:}); % save the line object to take its color
    hold on;
    plot_triangles(ax, ay, theta, ...
        sz, 1.5, line.Color); % same color as the plot
    axis equal;
    if ~gchold
        hold off; % turn hold back off if it was off before
    end
end

% Usage: plot_triangles(x, y, theta, scale, aspect, ...)
% x, y: vectors of positions
% theta: vector of angles (x, y, theta must be the same size!)
% scale: how long the arrows are
% aspect: aspect ratio (height / base)
% color: fill color
function patch = plot_triangles(x, y, theta, scale, aspect, color)
    % I don't like what quiver() looks like, so I made this

    % in order to use <pagemtimes> to do all the rotations at once, the theta
    % index needs to be third 
    move_to_third = @(v) permute(v(:), [2 3 1]);
    % convert everything
    x = move_to_third(x);
    y = move_to_third(y);
    theta = move_to_third(theta);

    rotm = [cos(theta) -sin(theta); sin(theta) cos(theta)]; 
    % ^ [1 2] are the rotation matrix elements, [3] is which theta
    base = 1 / aspect;

    polygon = [0 0 1; -base/2 base/2 0] * scale; % 2xN describing each triangle

    % use pagemtimes to apply a bunch of rotation matrices to <polygon> and get a bunch of results
    polygons = pagemtimes(rotm, polygon) + [x; y]; % rotate and shift every triangle
    % fill interprets each column as a polygon, but we started with each row being x and y
    % so turn that row into a column and put the polygon index into the second place
    px = permute(polygons(1, :, :), [2 3 1]);
    py = permute(polygons(2, :, :), [2 3 1]);

    % finally, plot all the triangles
    patch = fill(px, py, color, "LineStyle", "none", "HandleVisibility", "off");
    % turn off the line so it's just the filled region
    % turn off the handle visibility so this doesn't create hundreds of legend entries
end
