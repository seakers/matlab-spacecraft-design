function sat_plot(sats, field_x, field_y, varargin)

% SAT_PLOT
%   sat_plot(sats, 'xfield', 'yfield', ['cfield'], ['rel'], [val])
%
%   Generalized plotting function for arrays of CRISIS-sat structures.
%   Plots the values of 'yfield' versus 'xfield' for all of the satellite 
%   designs in the sats array.  
%
%   Returns a column vector of all values found in xfield (xdata), a column
%   vector of all values found in yfield (ydata), and an index array that 
%   has rows of (i,j,k,l,m) addresses corresponding to a given (xdata, 
%   ydata) pair.  
%
%   For example, the plotted pair (xdata(p), ydata(p)) corresponds to the
%   structure sats(index(p,1), index(p,2), index(p,3), ...)
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
%       sat_plot(..., 'Aperture', 'gt', 1.3);
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
n_params = length(sats(1).Fields);


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

x_no  = [];
y_no  = [];
i_no  = [];
x_yes = [];
y_yes = [];
i_yes = [];

if n_params == 1
    
    % build output arrays by getting field values
    z_yes = 1;
    z_no  = 1;
    [len1] = length(sats);
    for i = 1:len1
        
        % get data out of the struct
        temp_x = getfield(sats, {i}, field_x);   % get value of field_x
        temp_y = getfield(sats, {i}, field_y);   % get value of field_y
        temp_i = i;
        
        % put data in different vectors depending on constraint satisfaction
        if nargin == 6
            val_c = getfield(sats, {i}, field_c);
            if relational(val_c, rel, val)                  % satisfies constraint
                x_yes(z_yes)    = temp_x;
                y_yes(z_yes)    = temp_y;
                i_yes(z_yes,:)  = temp_i;
                z_yes = z_yes + 1;
            else                                            % does not satisfy constraint
                x_no(z_no)      = temp_x;
                y_no(z_no)      = temp_y;
                i_no(z_no,:)    = temp_i;
                z_no = z_no + 1;
            end
        else
            x_yes(z_yes)    = temp_x;
            y_yes(z_yes)    = temp_y;
            i_yes(z_yes,:)  = temp_i;
            z_yes = z_yes + 1;
        end
        
    end

elseif n_params == 2
    
    % build output arrays by getting field values
    z_yes = 1;
    z_no  = 1;
    [len1,len2] = size(sats);
    for i = 1:len1
        for j = 1:len2
        
            % get data out of the struct
            temp_x = getfield(sats, {i,j}, field_x);   % get value of field_x
            temp_y = getfield(sats, {i,j}, field_y);   % get value of field_y
            temp_i = [i j];
        
            % put data in different vectors depending on constraint satisfaction
            if nargin == 6
                val_c = getfield(sats, {i,j}, field_c);
                if relational(val_c, rel, val)                  % satisfies constraint
                    x_yes(z_yes)    = temp_x;
                    y_yes(z_yes)    = temp_y;
                    i_yes(z_yes,:)  = temp_i;
                    z_yes = z_yes + 1;
                else                                            % does not satisfy constraint
                    x_no(z_no)      = temp_x;
                    y_no(z_no)      = temp_y;
                    i_no(z_no,:)    = temp_i;
                    z_no = z_no + 1;
                end
            else
                x_yes(z_yes)    = temp_x;
                y_yes(z_yes)    = temp_y;
                i_yes(z_yes,:)  = temp_i;
                z_yes = z_yes + 1;
            end
            
        end
    end

elseif n_params == 3
    
    % build output arrays by getting field values
    z_yes = 1;
    z_no  = 1;
    [len1,len2,len3] = size(sats);
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                
                % get data out of the struct
                temp_x = getfield(sats, {i,j,k}, field_x);   % get value of field_x
                temp_y = getfield(sats, {i,j,k}, field_y);   % get value of field_y
                temp_i = [i j k];
        
                % put data in different vectors depending on constraint satisfaction
                if nargin == 6
                    val_c = getfield(sats, {i,j,k}, field_c);
                    if relational(val_c, rel, val)                  % satisfies constraint
                        x_yes(z_yes)    = temp_x;
                        y_yes(z_yes)    = temp_y;
                        i_yes(z_yes,:)  = temp_i;
                        z_yes = z_yes + 1;
                    else                                            % does not satisfy constraint
                        x_no(z_no)      = temp_x;
                        y_no(z_no)      = temp_y;
                        i_no(z_no,:)    = temp_i;
                        z_no = z_no + 1;
                    end
                else
                    x_yes(z_yes)    = temp_x;
                    y_yes(z_yes)    = temp_y;
                    i_yes(z_yes,:)  = temp_i;
                    z_yes = z_yes + 1;
                end
                
            end
        end
    end

elseif n_params == 4
    
    % build output arrays by getting field values
    z_yes = 1;
    z_no  = 1;
    [len1,len2,len3,len4] = size(sats);
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                for l = 1:len4
                    
                    % get data out of the struct
                    temp_x = getfield(sats, {i,j,k,l}, field_x);   % get value of field_x
                    temp_y = getfield(sats, {i,j,k,l}, field_y);   % get value of field_y
                    temp_i = [i j k l];
        
                    % put data in different vectors depending on constraint satisfaction
                    if nargin == 6
                        val_c = getfield(sats, {i,j,k,l}, field_c);
                        if relational(val_c, rel, val)                  % satisfies constraint
                            x_yes(z_yes)    = temp_x;
                            y_yes(z_yes)    = temp_y;
                            i_yes(z_yes,:)  = temp_i;
                            z_yes = z_yes + 1;
                        else                                            % does not satisfy constraint
                            x_no(z_no)      = temp_x;
                            y_no(z_no)      = temp_y;
                            i_no(z_no,:)    = temp_i;
                            z_no = z_no + 1;
                        end
                    else
                        x_yes(z_yes)    = temp_x;
                        y_yes(z_yes)    = temp_y;
                        i_yes(z_yes,:)  = temp_i;
                        z_yes = z_yes + 1;
                    end
                    
                end
            end
        end
    end

elseif n_params == 5

    % build output arrays by getting field values
    z_yes = 1;
    z_no  = 1;
    [len1,len2,len3,len4,len5] = size(sats);    
    for i = 1:len1
        for j = 1:len2
            for k = 1:len3
                for l = 1:len4
                    for m = 1:len5
                        
                        % get data out of the struct
                        temp_x = getfield(sats, {i,j,k,l,m}, field_x);   % get value of field_x
                        temp_y = getfield(sats, {i,j,k,l,m}, field_y);   % get value of field_y
                        temp_i = [i j k l m];
        
                        % put data in different vectors depending on constraint satisfaction
                        if nargin == 6
                            val_c = getfield(sats, {i,j,k,l,m}, field_c);
                            if relational(val_c, rel, val)                  % satisfies constraint
                                x_yes(z_yes)    = temp_x;
                                y_yes(z_yes)    = temp_y;
                                i_yes(z_yes,:)  = temp_i;
                                z_yes = z_yes + 1;
                            else                                            % does not satisfy constraint
                                x_no(z_no)      = temp_x;
                                y_no(z_no)      = temp_y;
                                i_no(z_no,:)    = temp_i;
                                z_no = z_no + 1;
                            end
                        else
                            x_yes(z_yes)    = temp_x;
                            y_yes(z_yes)    = temp_y;
                            i_yes(z_yes,:)  = temp_i;
                            z_yes = z_yes + 1;
                        end
                        
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
dh_no  = plot(ah, x_no, y_no, 'x', 'LineWidth', 2, 'Color', 'r');
dh_yes = plot(ah, x_yes, y_yes, 'x', 'LineWidth', 2, 'Color', 'b');

% execute callbacks when the mouse is clicked on a data point
set(dh_no , 'ButtonDownFcn', {@click, ah, sats, dh_yes, x_yes, y_yes, i_yes, dh_no, x_no, y_no, i_no, n_params});
set(dh_yes, 'ButtonDownFcn', {@click, ah, sats, dh_yes, x_yes, y_yes, i_yes, dh_no, x_no, y_no, i_no, n_params});

% add labels and title
xlabel(field_x);
ylabel(field_y);
title(fig_name);

    % ---------------------------------------------------------------------
    function [] = click(ph, eventdata, ah, sats, dh_yes, x_yes, y_yes, i_yes, dh_no, x_no, y_no, i_no, n_params)
    % Nested function that controls the behavior after the mouse click.  It
    % highlights the data point that the user clicks on, and displays
    % relevant parts of the sat structure at that point.
    % 
    % ph        - handle of the data point being plotted
    % eventdata - struct containing info about the event (empty)
    % ah        - handle of the axis currently being used
    % sats      - structure of satellite designs
    % npar      - number of parameters being varied
    % xvec      - vector of x-axis data points
    % yvec      - vector of y-axis data points
    % index     - vector of addresses

    
    % figure out if selected point is a 'yes' or 'no'
    if ph == dh_yes
        is_yes = true;
    elseif ph == dh_no
        is_yes = false;
    end
    
    % get mouse pointer location in axes coordinates
    mouse = get(ah, 'CurrentPoint');
    xmouse = mouse(1,1);
    ymouse = mouse(1,2);
    
    % get data points
    xdata = get(ph, 'XData');
    ydata = get(ph, 'YData');
    
    % find (xdata,ydata) closest to (xmouse,ymouse)
    xscale = max(xdata);
    yscale = max(ydata);
    z      = find((abs(xdata - xmouse) < 0.001*xscale).*(abs(ydata - ymouse) < 0.001*yscale));
    if is_yes
        xpoint = x_yes(z);
        ypoint = y_yes(z);
    else
        xpoint = x_no(z);
        ypoint = y_no(z);
    end
    
    % refresh the data using standard markers
    set(ah, 'NextPlot', 'replacechildren');
    dh_no  = plot(ah, x_no, y_no, 'x', 'LineWidth', 2, 'Color', 'r');
    set(ah, 'NextPlot', 'add');
    dh_yes = plot(ah, x_yes, y_yes, 'x', 'LineWidth', 2, 'Color', 'b');
    
    % set callbacks
    set(dh_no , 'ButtonDownFcn', {@click, ah, sats, dh_yes, x_yes, y_yes, i_yes, dh_no, x_no, y_no, i_no, n_params});
    set(dh_yes, 'ButtonDownFcn', {@click, ah, sats, dh_yes, x_yes, y_yes, i_yes, dh_no, x_no, y_no, i_no, n_params});

    % add a green circle around the selected data point
    line(xpoint, ypoint, 'Color', 'g', 'Marker', 'o', 'LineStyle', 'none');

    % display message in command window with data
    if is_yes
        ind = i_yes(z,:);
    else
        ind = i_no(z,:);
    end

    if n_params == 1 && numel(ind)~=0
        sat     = sats(ind(1));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1)}, field1);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d)\n', ind(1));
        fprintf('%25s: %-f\n\n', field1, val1);
        
    elseif n_params == 2 && numel(ind)~=0
        sat     = sats(ind(1), ind(2));
        field1  = sat.Fields{1};
        val1    = getfield(sats, {ind(1), ind(2)}, field1);   
        field2  = sat.Fields{2};
        val2    = getfield(sats, {ind(1), ind(2)}, field2);
        fprintf('Point at (%f, %f)\n', xpoint, ypoint);
        fprintf('Architecture (%d,%d)\n', ind(1), ind(2));
        fprintf('%25s: %-f\n', field1, val1);
        fprintf('%25s: %-f\n\n', field2, val2);
        
    elseif n_params == 3 && numel(ind)~=0
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

    elseif n_params == 4 && numel(ind)~=0
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
    
    elseif n_params == 5 && numel(ind)~=0
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