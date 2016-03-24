function sat_designs = sat_compare(varargin)

% SAT_COMPARE
%   sat_designs = sat_compare('Field1', vector1, 'Field2', vector2, ...);
%
%   Creates families of CRISIS-sat system designs and returns them in an
%   array sat_designs.  The satellite system designs structures are held 
%   constant except for the fields specified by 'Field1', 'Field2', etc.  
%   These fields are varied according to vector1, vector2, etc.  
%
%   Fields and vectors are entered in pairs, with the field variable being
%   a string specifying the field to vary and the vector variable being a
%   one-dimensional array.  The number of field/vector pairs must be
%   between 1 and 5.  The output sat_designs is an array of structures
%   whose dimensonality matches the number of fields being varied.  The
%   length of each dimension matches the number of values a given field
%   takes.  
%
%   Example:
%
%       sat_designs = sat_compare('Altitude', [100:100:1000], ...
%                                 'Diameter', [0.5:0.1:1], ...);
%
%       This returns a 10x6 array of sat structs where the Altitude field
%       changes along the first dimension and the Diameter field changes
%       along the second dimensions
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   13 Oct 2008


% check the number of parameters
if nargin > 10
    fprintf('SAT_COMPARE: error - number of parameters to compare cannot exceed 5.\n');
    sat_designs = [];
    return;
end

% create sat struct and assign default values
sat = sat_initialize;

% number of parameters to vary
n_params = nargin/2;

% 1 varying field
if n_params == 1
    field1      = varargin{1};  % get name of the field to vary
    vec1        = varargin{2};  % get the range over which to vary it
    fields{1}   = field1;
    for i = 1:length(vec1)
        temp = sat;             % build array of structs w/ varying fields
        temp = setfield(temp, field1, vec1(i));
        temp = setfield(temp, 'Fields', fields);
        sat_designs(i) = temp;        
    end

% 2 varying field
elseif n_params == 2
    field1      = varargin{1};  % same as above but with two fields now
    vec1        = varargin{2};
    field2      = varargin{3};
    vec2        = varargin{4};
    fields{1}   = field1;
    fields{2}   = field2;
    for i = 1:length(vec1)      % array is 2D now that 2 fields are varied
        for j = 1:length(vec2)
            temp = sat;
            temp = setfield(temp, field1, vec1(i));
            temp = setfield(temp, field2, vec2(j));
            temp = setfield(temp, 'Fields', fields);
            sat_designs(i,j) = temp;
        end
    end
    
% 3 varying field
elseif n_params == 3
    field1      = varargin{1};
    vec1        = varargin{2};
    field2      = varargin{3};
    vec2        = varargin{4};
    field3      = varargin{5};
    vec3        = varargin{6};
    fields{1}   = field1;
    fields{2}   = field2;
    fields{3}   = field3;
    for i = 1:length(vec1)
        for j = 1:length(vec2)
            for k = 1:length(vec3)
                temp = sat;
                temp = setfield(temp, field1, vec1(i));
                temp = setfield(temp, field2, vec2(j));
                temp = setfield(temp, field3, vec3(k));
                temp = setfield(temp, 'Fields', fields);
                sat_designs(i,j,k) = temp;
            end
        end
    end

% 4 varying fields
elseif n_params == 4
    field1  = varargin{1};
    vec1    = varargin{2};
    field2  = varargin{3};
    vec2    = varargin{4};
    field3  = varargin{5};
    vec3    = varargin{6};
    field4  = varargin{7};
    vec4    = varargin{8};
    fields{1}   = field1;
    fields{2}   = field2;
    fields{3}   = field3;
    fields{4}   = field4;
    for i = 1:length(vec1)
        for j = 1:length(vec2)
            for k = 1:length(vec3)
                for l = 1:length(vec4)
                    temp = sat;
                    temp = setfield(temp, field1, vec1(i));
                    temp = setfield(temp, field2, vec2(j));
                    temp = setfield(temp, field3, vec3(k));
                    temp = setfield(temp, field4, vec4(l));
                    temp = setfield(temp, 'Fields', fields);
                    sat_designs(i,j,k,l) = temp;
                end
            end
        end
    end
    
% 5 varying fields
elseif n_params == 5
    field1  = varargin{1};
    vec1    = varargin{2};
    field2  = varargin{3};
    vec2    = varargin{4};
    field3  = varargin{5};
    vec3    = varargin{6};
    field4  = varargin{7};
    vec4    = varargin{8};
    field5  = varargin{9};
    vec5    = varargin{10};
    fields{1}   = field1;
    fields{2}   = field2;
    fields{3}   = field3;
    fields{4}   = field4;
    fields{5}   = field5;
    for i = 1:length(vec1)
        for j = 1:length(vec2)
            for k = 1:length(vec3)
                for l = 1:length(vec4)
                    for m = 1:length(vec5)
                        temp = sat;
                        temp = setfield(temp, field1, vec1(i));
                        temp = setfield(temp, field2, vec2(j));
                        temp = setfield(temp, field3, vec3(k));
                        temp = setfield(temp, field4, vec4(l));
                        temp = setfield(temp, field5, vec5(m));
                        temp = setfield(temp, 'Fields', fields);
                        sat_designs(i,j,k,l,m) = temp;
                    end
                end
            end
        end
    end
end
    
return;