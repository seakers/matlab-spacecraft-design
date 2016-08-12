function [payload_comp,p_dim] = AttachPayload(payload,dim,p)
% Attaches the payload to the +Y nadir face of the structure. Places the
% largest payload in the center, and then places other payloads next to it.

% payload_comp = struct('Name','Payload','Subsystem','Payload','Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
%     ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);

L = payload.Dim(1);
W = payload.Dim(2);
T = payload.Dim(3);

p_dim = [L,W,T];

H = dim(3);

payload_comp = payload;

bottomVert = [L/2,W/2,H; -L/2,W/2,H;
    -L/2,-W/2,H; L/2,-W/2,H];
topVert = [L/2,W/2,H+T; -L/2,W/2,H+T;
    -L/2,-W/2,H+T; L/2,-W/2,H+T];

payload_comp.Vertices = [bottomVert; topVert];
payload_comp.RotateToSatBodyFrame = [1,0,0;0,1,0;0,0,1];
payload_comp.CG_XYZ = [0,0,(2*H+T)/2];



end