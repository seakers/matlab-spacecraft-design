function out = stkSetSensor(conid, path, type, varargin)

% stkSetSensor
%   Set sensor parameters in STK.
%
%   out = stkSetSensor(conid, 'path', 'type', angle1, [angle2])
%
%       conid   - ID of connection socket to STK (returned from stkOpen)
%       'path'  - STK path of sensor to be changed
%       'type'  - Type of sensor to add: 'SimpleCone' or 'Rectangular'
%       angle1  - Cone angle for the case of 'SimpleCone', vertical angle
%                 for the case of 'Rectangular'
%       angle2  - horizontal angle for the case of 'Rectangular' (optional)
%
%
%   Matthew W. Smith <m_smith> -- 11/3/08


% -------------------------------------------------------------------------
% Simple conic sensor
% -------------------------------------------------------------------------
if strcmp(type, 'SimpleCone')
    
    % first parameter is the cone angle
    cone_angle = num2str(varargin{1});
    
    call = ['Define ' path ' ' type ' ' cone_angle];
   
% -------------------------------------------------------------------------
% Rectangular conic sensor
% -------------------------------------------------------------------------
elseif strcmp(type, 'Rectangular')
    
    % parameters are vertical and horizontal half angles
    vert_angle  = num2str(varargin{1});
    horiz_angle = num2str(varargin{2});
    
    call = ['Define ' path ' ' type ' ' vert_angle ' ' horiz_angle];

% -------------------------------------------------------------------------
% Rectangular conic sensor
% -------------------------------------------------------------------------
elseif strcmp(type, 'HalfPower')
    
    % parameters are frequency in GHz and Diameter in m
    f_GHz  = num2str(varargin{1});
    D = num2str(varargin{2});
    
    call = ['Define ' path ' ' type ' ' f_GHz ' ' D];

% -------------------------------------------------------------------------
% No other types of sensors supported by this function
% -------------------------------------------------------------------------
else
    fprintf('stkSetSensor: error - STK sensor type %s not recognized.\n', type);
    return;
end

% call the 'Define' STK Connect command
out = stkExec(conid, call);

return;