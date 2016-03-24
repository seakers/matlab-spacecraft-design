function out = stkGetReport(conid, path, style, type, varargin)
%% stkGetReport.m
%   Get a Report from STK using ReportCreate STK function and either displays it, saves it as a text file
%   or exports it as a CSV file.
%
%   out = stkGetReport(conid, 'path', 'style', 'type', varargin)
%
%       conid       - ID of connection socket to STK (returned from stkOpen)
%       'path'      - STK path of the object of the report (e.g. Revisit Time) 
%       'type'      - Type of Output. Examples: 'Display', 'Save'
%       'style'     - Report style. Example: "Value By Grid Point"
%       'varargin'  - Name of the output file for save/export types.
%
%   Daniel Selva <dselva> -- 11/11/08

%% Options
% Save option
if strcmp(type, 'Save')
    filename = varargin{1};
    call = ['ReportCreate ' path ' Type ' type ' Style "' style '" File "' filename '"'];

% Export option
elseif strcmp(type, 'Export')
    filename = varargin{1};
    call = ['ReportCreate ' path ' Type ' type ' Style "' style '" File "' filename '"'];

% Display option   
elseif strcmp(type, 'Display')
    call = ['ReportCreate ' path ' Type ' type ' Style "' style '"'];
  
% -------------------------------------------------------------------------
% No other types of output supported by this function
% -------------------------------------------------------------------------
else
    fprintf('stkGetReport: error - STK Report type %s not recognized.\n', type);
    return;
end

%% Call the 'ReportCreate' STK Connect command
out = stkExec(conid, call);

return;
%% end of stkGetReport.m