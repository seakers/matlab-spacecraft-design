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
            for k = 1:len3
                for l = 1:len4
                    for m = 1:len5
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

% plot the two fields of interest
fig_name = [field2 ' vs. ' field1];
figure('Name', fig_name);
plot(out1, out2, 'x');
xlabel(field1);
ylabel(field2);
title(fig_name);


return;