function is_true = relational(val1, relation, val2)
% RELATIONAL
%   is_true = relational(val1, 'relation', val2);
%
%   Generalized relational operator that compares the input values
%   according a user-defined operator.  The input 'relation' is one of the
%   following strings corresponding to MATLAB's built-in relational
%   operators
%
%       'relation':     MATLAB operator:
%       ----------      ---------------
%          'lt'                <
%          'gt'                >
%          'le'                <=
%          'ge'                >=
%          'eq'                ==
%          'ne'                ~=
%       
%   For example the syntax,
%
%       is_true = relational(val1, 'ge', val2);
%
%   is equivalent to,
%
%       is_true = (val1 >= val2);
%
%
%   Matthew W. Smith <m_smith@mit.edu> -- 11/27/08


% error checking, make sure input relation flag is recognized
if ~strcmp(relation, 'lt') && ...
   ~strcmp(relation, 'gt') && ...
   ~strcmp(relation, 'le') && ...
   ~strcmp(relation, 'ge') && ...
   ~strcmp(relation, 'eq') && ...
   ~strcmp(relation, 'ne');
    fprintf('RELATIONAL: error - Input flag "%s" is not recognized.\n', relation);
    fprintf('                    Must be one of {lt, gt, le, ge, eq, ne}.\n');
    is_true = [];
    return;
end

% perform the relational comparison based on the input flag
if strcmp(relation, 'lt')
    is_true = (val1 < val2);
elseif strcmp(relation, 'gt')
    is_true = (val1 > val2);
elseif strcmp(relation, 'le');
    is_true = (val1 <= val2);
elseif strcmp(relation, 'ge');
    is_true = (val1 >= val2);
elseif strcmp(relation, 'eq');
    is_true = (val1 == val2);
elseif strcmp(relation, 'ne');
    is_true = (val1 ~= val2);
end

return;