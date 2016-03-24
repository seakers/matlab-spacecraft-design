function [out_x, out_y, index] = sat_plot2(sat_designs, field_x, field_y, varargin)

% SAT_PLOT2
%   [xdata, ydata, index] = sat_plot2(sat_designs, 'xfield', 'yfield', ['cfield'], ['rel'], [val])
%
%   Generalized plotting function for arrays of CRISIS-sat structures.
%   Plots the values of 'yfield' versus 'xfield' for all of the satellite 
%   designs in the sat_designs array.  
%
%   Returns a column vector of all values found in xfield (xdata), a column
%   vector of all values found in yfield (ydata), and an index array that 
%   has rows of (i,j,k,l,m) addresses corresponding to a given (xdata, 
%   ydata) pair.  
%
%   For example, the plotted pair (xdata(p), ydata(p)) corresponds to the
%   structure sat_designs(index(p,1), index(p,2), index(p,3), ...)
%
%   The optional arguments 'cfield', 'rel', and val are used to highlight
%   certain data points that satisfy a constraint.  The field subject to
%   the constraint is 'cfield' while 'rel' is a relational operator.  This
%   function uses the following codes for relational operators:
%
%       'rel' tag:      MATLAB operator:
%       ---------       ---------------
%         'lt'                 <              
%         'gt'                 >
%         'le'                 <=
%         'ge'                 >=
%         'eq'                 ==
%         'ne'                 ~=
%
%   Finally val is the numerical value against which 'cfield' is compared.
%   For example, to highlight all archietctures where the optical aperture
%   is larger than 1.3 m, use the following syntax:
%
%       [...] = sat_plot(..., 'Aperture', 'gt', 1.3);
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   13 Oct 2008


% -------------------------------------------------------------------------
% Determine number of parameters being varied
% -------------------------------------------------------------------------
fields   = sat_designs.Fields;
n_params = length(fields);


% -------------------------------------------------------------------------
% Optional case where there is a constraint
% -------------------------------------------------------------------------
if nargin == 6
    
    % assign variables
    field_c = varargin{1};
    rel     = varargin{2};
    val     = varargin{3};
    
    % error checking, make sure input relation flag is recognized
    if ~strcmp(rel, 'lt') &&    ...
       ~strcmp(rel, 'gt') &&    ...
       ~strcmp(rel, 'le') && ...
       ~strcmp(rel, 'ge') && ...
       ~strcmp(rel, 'eq') && ...
       ~strcmp(rel, 'ne');
        fprintf('RELATIONAL: error - Input flag "%s" is not recognized.\n', relation);
        fprintf('                    Must be one of {lt, gt, le, ge, eq, ne}.\n');
        out_x = [];
        out_y = [];
        index = [];
        return;
    end
end


% -------------------------------------------------------------------------
% Extract the data of interest from the structure
% -------------------------------------------------------------------------

if n_params == 1
    [len1] = length(sat_designs);
    n_designs = len1;                       % number of designs along this dimension
    out_x    = zeros(n_designs, 1);         % pre-allocate the output arrays
    out_y    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    
    % build output arrays by getting field values
    z = 1;
    for i = 1:len1
        
        % get data out of the struct
        out_x(z) = getfield(sat_designs, {i}, field_x);     % get value of field_x
        out_y(z) = getfield(sat_designs, {i}, field_y);     % get value of field_y
        index(z,:) = i;                                     % get address in the sat array
        
        % assign different colors depending on the constraint
        if nargin == 6
            val_c = getfield(sat_designs, {i}, field_c);
            if relational(val_c, rel, val)
                col(z) = 'b';                   % blue if constraint is satisfied
            else
                col(z) = 'r';                   % red if constraint is not satisfied
            end
        else
            col(z) = 'b';                       % blue if no constraint at all
        end
        
        z = z+1;
    end

elseif n_params == 2
    [len1,len2] = size(sat_designs);
    n_designs = len1*len2;
    out_x    = zeros(n_designs, 1);          
    out_y    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    
    % build output arrays by getting field values
    z = 1;
    for i = 1:len1
        for j = 1:len2
            
            % get data out of the struct
            out_x(z) = getfield(sat_designs, {i,j}, field_x);
            out_y(z) = getfield(sat_designs, {i,j}, field_y);
            index(z,:) = [i j];
            
            % assign different colors depending on the constraint
            if nargin == 6
                val_c = getfield(sat_designs, {i,j}, field_c);
                if relational(val_c, rel, val)
                    col(z) = 'b';
                else
                    col(z) = 'r';
                end
            else
                col(z) = 'b';
            end
            
            z = z+1;
        end
    end

elseif n_params == 3
    [len1,len2,len3] = size(sat_designs);
    n_designs = len1*len2*len3;
    out_x    = zeros(n_designs, 1);          
    out_y    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    
    % build output arrays by getting field values
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                
                % get data out of the struct
                out_x(z) = getfield(sat_designs, {i,j,k}, field_x);
                out_y(z) = getfield(sat_designs, {i,j,k}, field_y);
                index(z,:) = [i j k];
                
                % assign different colors depending on the constraint
                if nargin == 6
                    val_c = getfield(sat_designs, {i,j,k}, field_c);
                    if relational(val_c, rel, val)
                        col(z) = 'b';
                    else
                        col(z) = 'r';
                    end
                else
                    col(z) = 'b';
                end
                
                z = z+1;
            end
        end
    end

elseif n_params == 4
    [len1,len2,len3,len4] = size(sat_designs);
    n_designs = len1*len2*len3*len4;
    out_x    = zeros(n_designs, 1);          
    out_y    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    
    % build output arrays by getting field values
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                for l = 1:len4
                    
                    % get data out of the struct
                    out_x(z) = getfield(sat_designs, {i,j,k,l}, field_x);
                    out_y(z) = getfield(sat_designs, {i,j,k,l}, field_y);
                    index(z,:) = [i j k l];
                    
                    % assign different colors depending on the constraint
                    if nargin == 6
                        val_c = getfield(sat_designs, {i,j,k,l}, field_c);
                        if relational(val_c, rel, val)
                            col(z) = 'b';
                        else
                            col(z) = 'r';
                        end
                    else
                        col(z) = 'b';
                    end
                    
                    z = z+1;
                end
            end
        end
    end

elseif n_params == 5
    [len1,len2,len3,len4,len5] = size(sat_designs);
    n_designs = len1*len2*len3*len4*len5;
    out_x    = zeros(n_designs, 1);          
    out_y    = zeros(n_designs, 1);          
    index   = zeros(n_designs, n_params); 
    
    % build output arrays by getting field values
    z = 1;
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                for l = 1:len4
                    for m = 1:len5
                        
                        % get data out of the struct
                        out_x(z) = getfield(sat_designs, {i,j,k,l,m}, field_x);
                        out_y(z) = getfield(sat_designs, {i,j,k,l,m}, field_y);
                        index(z,:) = [i j k l m];
                        
                        % assign different colors depending on the constraint
                        if nargin == 6
                            val_c = getfield(sat_designs, {i,j,k,l,m}, field_c);
                            if relational(val_c, rel, val)
                                col(z) = 'b';
                            else
                                col(z) = 'r';
                            end
                        else
                            col(z) = 'b';
                        end
                        
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
fig_name = [field_y ' vs. ' field_x];
fh = figure('Name', fig_name);

% add an axis (ah is the axis handle)
ah = axes('Parent', fh, 'NextPlot', 'add');

% add data to the axes (dh is a vector of handles to the data points)
for ii = 1:z-1
    dh(ii) = line(out_x(ii), out_y(ii),    ...
                'Marker', 'x',          ...
                'LineWidth', 2,         ...
                'LineStyle', 'none',    ...
                'Color', col(ii),        ...
                'ButtonDownFcn', {@mouseclick_callback, ah, sat_designs, n_params, out_x, out_y, index});
end

% add labels and title
xlabel(field_x);
ylabel(field_y);
title(fig_name);

    % ---------------------------------------------------------------------
    function [] = mouseclick_callback(point_handle, eventdata, axis_handle, sats, npar, xvec, yvec, index)
    % Nested function that controls the behavior after the mouse click.  It
    % highlights the data point that the user clicks on, and displays
    % relevant parts of the sat structure at that point.
    % 
    % point_handle - handle of the data point being plotted
    % eventdata    - struct containing info about the event (empty)
    % axis_handle  - handle of the axis currently being used
    % sats         - structure of satellite designs
    % npar         - number of parameters being varied
    % xvec         - vector of x-axis data points
    % yvec         - vector of y-axis data points
    % index        - vector of addresses

    % get mouse pointer location in axes coordinates
    mouse = get(axis_handle, 'CurrentPoint');
    xmouse = mouse(1,1);
    ymouse = mouse(1,2);
        
    % get data points and index
    xpoint = get(point_handle, 'XData');
    ypoint = get(point_handle, 'YData');
    z     = find((xvec==xpoint).*(yvec==ypoint));
    
    % clear plot
    set(axis_handle, 'NextPlot', 'replacechildren');
    line(out_x(1), out_y(1), 'Marker', 'x', 'LineWidth', 2, 'LineStyle', 'none', 'Color', col(1));
    set(axis_handle, 'NextPlot', 'add');
    
    % refresh the data, using the standard markers
    for ii = 1:z-1
        dh(ii) = line(out_x(ii), out_y(ii),    ...
                      'Marker', 'x',          ...
                      'LineWidth', 2,         ...
                      'LineStyle', 'none',    ...
                      'Color', col(ii),        ...
                      'ButtonDownFcn', {@mouseclick_callback, ah, sat_designs, n_params, out_x, out_y, index});
    end
    
    % add a green circle around the selected data point
    line(xpoint, ypoint, 'Color', 'g', 'Marker', 'o', 'LineStyle', 'none');
    
    % display message in command window with data
    ind = index(z,:);
    if npar == 1 
        sat     = sats(ind(1));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1)}, field1);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d)\n', ind(1));
        fprintf('%25s: %-f\n\n', field1, val1);
        
    elseif npar == 2
        sat     = sats(ind(1), ind(2));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2)}, field1);   
        field2  = sat.Fields{2};
        val2    = getfield(sats, {ind(1), ind(2)}, field2);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d)\n', ind(1), ind(2));
        fprintf('%25s: %-f\n', field1, val1);
        fprintf('%25s: %-f\n\n', field2, val2);
        
    elseif npar == 3
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

    elseif npar == 4
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
    
    elseif npar == 5
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