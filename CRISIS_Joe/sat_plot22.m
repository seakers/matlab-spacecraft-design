function [out1, out2, index] = sat_plot(sat_designs, field1, field2)

% SAT_PLOT
%   [xdata, ydata, index] = sat_plot(sat_designs, 'field1', 'field2')
%
%   Generalized plotting function for arrays of CRISIS-sat structures.
%   Plots the values of 'field2' versus 'field1' (i.e. y vs. x) for all of
%   the satellite designs in the sat_designs array.  
%
%   Returns a column vector of all values found in field1 (xdata), a column
%   vector of all values found in field2 (ydata), and an index array that 
%   has rows of (i,j,k,l,m) addresses corresponding to a given (xdata, 
%   ydata) pair.  
%
%   For example, the plotted pair (xdata(p), ydata(p)) corresponds to the
%   structure sat_designs(index(p,1), index(p,2), index(p,3), ...)
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   13 Oct 2008


% -------------------------------------------------------------------------
% Extract the data of interest from the structure
% -------------------------------------------------------------------------

n_params = ndims(sat_designs);

if n_params == 1
    [len1] = size(sat_designs);
    n_designs = len1;                       % number of designs along this dimension
    out1    = zeros(n_designs, 1);          % pre-allocate the output arrays
    out2    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    z = 1;                                  % index for output vectors
    for i = 1:len1                          % build output arrays by getting field values
        out1(z) = getfield(sat_designs, {i}, field1);
        out2(z) = getfield(sat_designs, {i}, field2);
        index(z,:) = i;
        z = z+1;
    end

elseif n_params == 2
    [len1,len2] = size(sat_designs);
    n_designs = len1*len2;
    out1    = zeros(n_designs, 1);          
    out2    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    z = 1;
    for i = 1:len1
        for j = 1:len2
            out1(z) = getfield(sat_designs, {i,j}, field1);
            out2(z) = getfield(sat_designs, {i,j}, field2);
            index(z,:) = [i j];
            z = z+1;
        end
    end

elseif n_params == 3
    [len1,len2,len3] = size(sat_designs);
    n_designs = len1*len2*len3;
    out1    = zeros(n_designs, 1);          
    out2    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                out1(z) = getfield(sat_designs, {i,j,k}, field1);
                out2(z) = getfield(sat_designs, {i,j,k}, field2);
                index(z,:) = [i j k];
                z = z+1;
            end
        end
    end

elseif n_params == 4
    [len1,len2,len3,len4] = size(sat_designs);
    n_designs = len1*len2*len3*len4;
    out1    = zeros(n_designs, 1);          
    out2    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                for l = 1:len4
                        out1(z) = getfield(sat_designs, {i,j,k,l}, field1);
                        out2(z) = getfield(sat_designs, {i,j,k,l}, field2);
                        index(z,:) = [i j k l];
                        z = z+1;
                end
            end
        end
    end

elseif n_params == 5
    [len1,len2,len3,len4,len5] = size(sat_designs);
    n_designs = len1*len2*len3*len4*len5;
    out1    = zeros(n_designs, 1);          
    out2    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:2
                for l = 1:3
                    for m = 1:3
                        disp([ num2str(i) ' ' num2str(j) ' ' num2str(k) ' ' num2str(l) ' ' num2str(m)]);
                        out1(z) = getfield(sat_designs, {i,j,k,l,m}, field1);
                        out2(z) = getfield(sat_designs, {i,j,k,l,m}, field2);
                        index(z,:) = [i j k l m];
                        z = z+1;
                    end
                end
            end
        end
    end
end


% -------------------------------------------------------------------------
% Plot the data in a GUI
% -------------------------------------------------------------------------

% create the GUI figure (fh is the figure handle)
fig_name = [field2 ' vs. ' field1];
fh = figure('Name', fig_name);

% add an axis (ah is the axis handle)
ah = axes('Parent', fh, 'NextPlot', 'replacechildren');

% add sample data to the axes (dh is the handle to the data points)
x = 0 : 0.1 : 10;
y = x.^2;
dh = plot(ah, out1, out2, 'x', 'LineWidth', 2);

% add labels and title
xlabel(field1);
ylabel(field2);
title(fig_name);

% execute mouseclick_callback when the mouse is clicked on a data point
set(dh, 'ButtonDownFcn', {@mouseclick_callback, ah, sat_designs, index});

    % ---------------------------------------------------------------------
    function [] = mouseclick_callback(point_handle, eventdata, axis_handle, sats, index)
    % Nested function that controls the behavior after the mouse click.  It
    % highlights the data point that the user clicks on, and displays
    % relevant parts of the sat structure at that point.
    % 
    % point_handle - handle of the data points being plotted
    % eventdata    - struct containing info about the event (empty)
    % axis_handle  - handle of the axis currently being used
    
    % get mouse pointer location in axes coordinates
    mouse = get(axis_handle, 'CurrentPoint');
    xmouse = mouse(1,1);
    ymouse = mouse(1,2);
        
    % get data points
    xdata = get(point_handle, 'XData');
    ydata = get(point_handle, 'YData');
        
    % find xdata closest to xmouse (could have done ydata/ymouse too)
    [val, i] = min(abs(xdata - xmouse));
    xpoint   = xdata(i);
    ypoint   = ydata(i);
    
    % refresh the data, using the standard markers
    dh = plot(ah, xdata, ydata, 'x', 'LineWidth', 2);
    set(dh, 'ButtonDownFcn', {@mouseclick_callback, ah, sat_designs, index});
    
    % add a red circle around the selected data point
    line(xpoint, ypoint, 'Color', 'r', 'Marker', 'o', 'LineStyle', 'none');
    
    % display message in command window with data
    ind = index(i,:);
    if ndims(sats) == 1 
        sat     = sats(ind(1));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1)}, field1);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d)\n', ind(1));
        fprintf('%25s: %-f\n\n', field1, val1);
    elseif ndims(sats) == 2
        sat     = sats(ind(1), ind(2));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2)}, field1);   
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d)\n', ind(1), ind(2));
        fprintf('%25s: %-f\n', field1, val1);
        
        if size(sats,1) ~= 1
            field2  = sat.Fields{2};
            val2    = getfield(sats, {ind(1), ind(2)}, field2);
            fprintf('%25s: %-f\n\n', field2, val2);
        end
        
    elseif ndims(sats) == 3
        sat = sats(ind(1), ind(2), ind(3));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2), ind(3)}, field1);
        field2  = sat.Fields{2};
        val2    = getfield(sats, {ind(1), ind(2), ind(3)}, field2);
        field3  = sat.Fields{3};
        val3    = getfield(sats, {ind(1), ind(2), ind(3)}, field3);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d,%d)\n', ind(1), ind(2), ind(3));
        fprintf('%25s: %-f\n', field1, val1);
        fprintf('%25s: %-f\n', field2, val2);
        fprintf('%25s: %-f\n\n', field3, val3);

    elseif ndims(sats) == 4
        sat = sats(ind(1), ind(2), ind(3), ind(4));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2), ind(3), ind(4)}, field1);
        field2  = sat.Fields{2};
        val2    = getfield(sats, {ind(1), ind(2), ind(3), ind(4)}, field2);
        field3  = sat.Fields{3};
        val3    = getfield(sats, {ind(1), ind(2), ind(3), ind(4)}, field3);
        field4  = sat.Fields{4};
        val4    = getfield(sats, {ind(1), ind(2), ind(3), ind(4)}, field4);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d,%d,%d)\n', ind(1), ind(2), ind(3), ind(4));
        fprintf('%25s: %-f\n', field1, val1);
        fprintf('%25s: %-f\n', field2, val2);
        fprintf('%25s: %-f\n', field3, val3);
        fprintf('%25s: %-f\n\n', field4, val4);
    elseif ndims(sats) == 5
        sat = sats(ind(1), ind(2), ind(3), ind(4), ind(5));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2), ind(3), ind(4), ind(5)}, field1);
        field2  = sat.Fields{2};
        val2    = getfield(sats, {ind(1), ind(2), ind(3), ind(4), ind(5)}, field2);
        field3  = sat.Fields{3};
        val3    = getfield(sats, {ind(1), ind(2), ind(3), ind(4), ind(5)}, field3);
        field4  = sat.Fields{4};
        val4    = getfield(sats, {ind(1), ind(2), ind(3), ind(4), ind(5)}, field4);
        field5  = sat.Fields{5};
        val5    = getfield(sats, {ind(1), ind(2), ind(3), ind(4), ind(5)}, field5);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d,%d,%d,%d)\n', ind(1), ind(2), ind(3), ind(4), ind(5));
        fprintf('%25s: %-f\n', field1, val1);
        fprintf('%25s: %-f\n', field2, val2);
        fprintf('%25s: %-f\n', field3, val3);
        fprintf('%25s: %-f\n', field4, val4);
        fprintf('%25s: %-f\n\n', field5, val5);
    end    
    
    end
    % ---------------------------------------------------------------------

end

% end sat_plot.m