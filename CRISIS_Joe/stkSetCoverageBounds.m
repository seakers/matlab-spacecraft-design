function out = stkSetCoverageBounds(conid, path, lat_min, lat_max)

% stkSetCoverageBounds
%   Set coverage grid latitude bounds in STK.
%
%   out = stkSetCoverageGrid(conid, 'path', lat_min, lat_max)
%
%       conid   - ID of connection socket to STK (returned from stkOpen)
%       'path'  - STK path of the coverage definition object to be set
%       lat_min - minimum latitude bound (degrees, must be >= -90)
%       lat_max - maximum latitude bound (degrees, must be <= +90)
%
%
%   Matthew W. Smith <m_smith> -- 11/3/08


% error checking
if lat_min < -90
    fprintf('stkSetCoverageBounds: error - min latitude out of range, must be >= -90 degrees.\n');
    return;
end
if lat_max > 90
    fprintf('stkSetCoverageBounds: error - max latitude out of range, must be <= +90 degrees.\n');
    return;
end

% convert inputs to strings
lat_min = num2str(lat_min);
lat_max = num2str(lat_max);

% assemble the call to STK connect
call = ['Cov ' path ' Grid Definition LatBounds ' lat_min ' ' lat_max];

% call the 'Define' STK Connect command
out = stkExec(conid, call);

return;