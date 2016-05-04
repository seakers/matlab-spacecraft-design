function R = RotateFrameToAxes(normalAxes,rollRotate)
% Assuming the component starts out planning on being mounted on the YZ
% plane, this function will send out the rotation matrix for rotating the
% body from this axis to the appropriate axes.

% Rotate the X axis to face the normal of the surface. Then rotate the
% other axes of the object if necessary.

roll = 0;
pitch = 0;
yaw = 0;

if strcmp(normalAxes,'+X')
% Do nothing if the normal axis is +X because this is the same as it is
% now.
elseif strcmp(normalAxes,'+Y')
% Rotate around the Z axis in order to get the Y and the X aligned.
    yaw = pi/2;
elseif strcmp(normalAxes,'+Z')
% Rotate around the Y axis in order to get the Z and the X aligned.
    pitch = -pi/2; 
%     % Rotate around the Z axis in order to get the Y and the X aligned.
%     yaw = -pi/2;
%     roll = -pi/2;
%     pitch = 0;
elseif strcmp(normalAxes,'-X')
% % Rotate the spacecraft by 180;
%     yaw = pi;
elseif strcmp(normalAxes,'-Y')
% Rotate around the Z axis in order to get the Y and the X aligned.
    yaw = -pi/2;
elseif strcmp(normalAxes,'-Z')
% Rotate around the Y axis in order to get the Z and the X aligned.
%     roll = pi/2; 
%     yaw = -pi/2;
end

if rollRotate
% Rotate the body around the roll axis (X).    
    roll = pi;
end

R = euler2Rot(roll,pitch,yaw);