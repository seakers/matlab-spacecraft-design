function out = stkSetCoverageFOM(conid, path, type)
%% stkSetCoverageFOM.m
% stkSetCoverageFOM(conid, path, type)
%   Set Figure of Merit parameters of a given CoverageDefinition in STK.
%
%   out = stkSetCoverageFOM(conid, 'path', 'type')
%
%       conid   - ID of connection socket to STK (returned from stkOpen)
%       'path'  - STK path of FOM to be changed
%       'type'  - Type of FOM to set. Examples: 'Revisit Time', 'Coverage
%       Time', 'Response Time'
%
%
%   Daniel Selva <dselva> -- 11/6/08

% -------------------------------------------------------------------------
%% Revisit Time
% -------------------------------------------------------------------------
if strcmp(type, 'RevisitTime')
   
    call = ['FOMDefine ' path ' ' 'Definition ' type];

% -------------------------------------------------------------------------
%% Response Time
% -------------------------------------------------------------------------
elseif strcmp(type, 'ResponseTime')
   
    call = ['FOMDefine ' path ' ' 'Definition ' type];
% -------------------------------------------------------------------------
% No other types of FOM supported by this function
% -------------------------------------------------------------------------
else
    fprintf('stkSetCoverageFOM: error - STK FOM type %s not recognized.\n', type);
    return;
end

%% call the 'Define' STK Connect command
out = stkExec(conid, call);

return;