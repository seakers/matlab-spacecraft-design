function out = stkGetReport(conid, path, style, type, varargin)

% out = stkGetReport(conid, path, style, type, file)
%   Set Figure of Merit parameters of a given CoverageDefinition in STK.
%
%   out = stkGetReport(conid, 'path', 'style', 'type', varargin)
%
%       conid   - ID of connection socket to STK (returned from stkOpen)
%       'path'  - STK path of FOM (Revisit Time) to be computed
%       'type'  - Type of FOM to set. Examples: 'Display', 'File'
%       'style' - Report style. Example: Value By Grid Point
%
%   Daniel Selva <dselva> -- 11/11/08


% -------------------------------------------------------------------------
% Revisit Time
% -------------------------------------------------------------------------
if strcmp(type, 'File')
    filename = varargin{1};
    call = ['ReportCreate ' path ' Type ' type ' Style "' style '" Save "' filaneme '"'];
else
    call = ['FOMDefine ' path ' ' 'Definition ' type];
end


   
% -------------------------------------------------------------------------
% No other types of FOM supported by this function
% -------------------------------------------------------------------------
else
    fprintf('stkSetCoverageFOM: error - STK FOM type %s not recognized.\n', type);
    return;
end

% call the 'Define' STK Connect command
out = stkExec(conid, call);

return;