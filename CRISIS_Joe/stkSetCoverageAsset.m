function out = stkSetCoverageAsset(conid, coverage_def, asset)

% stkSetCoverageAsset
%   Assign an asset (e.g. a sensor) to a coverage definition
%
%   out = stkSetCoverageGrid(conid, 'coverage_def', 'asset')
%
%       conid           - ID of connection socket to STK (returned from stkOpen)
%       'coverage_def'  - STK path of the coverage definition object
%       'asset'         - STK path of the asset to be assigned
%
%
%   Matthew W. Smith <m_smith> -- 11/3/08


% assemble the call to STK connect
call = ['Cov ' coverage_def ' Asset ' asset ' Assign'];

% call the 'Define' STK Connect command
out = stkExec(conid, call);

return;