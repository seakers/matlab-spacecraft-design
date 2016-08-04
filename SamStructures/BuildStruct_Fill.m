function [structures,dim] = BuildStruct_Fill(inside_comp,payload,init_t)

% Define the volume needed for the surroinding structure to hold. Builds the
% structural walls around this volume based on an aspect ratio.
fill_volume = sum(cat(1,inside_comp.Volume));

% Assume L & W of structure are same, and you are adjusting height
% accordingly

if strcmp(payload.Shape,'Rectangle')
L = 1*max(payload.Dim(1));
W = 1*sum(payload.Dim(2));
H = 1.2*fill_volume/((L-2*init_t)*(W-2*init_t));
dim = [L,W,H,init_t];
else
L = 2.1*max(payload(1).Dim(1));
W = 2.1*sum(payload(1).Dim(1));
H = 1.01*fill_volume/(L*W);
dim = [L,W,H,init_t];
end

%% 1, Bottom Panel (Normal to -Z)
bottomVert = [L/2,W/2,0; -L/2,W/2,0; -L/2,-W/2,0; L/2,-W/2,0];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+init_t;

structures(1).Name = 'Zenith Panel';
structures(1).Shape = 'Rectangle';
structures(1).Material = material;
structures(1).Mass = []; % This will be density times volume
structures(1).Dim = [L,W,init_t]; % use the satial paramaters.
structures(1).CG_XYZ = [0,0,init_t/2]; % Make the origin at the middle of the bottom panel.
structures(1).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(1).Top_Vertices = topVert;
structures(1).Plane = 'XY';

% Outside Surface to mount parts on
structures(1).Surface(1).Mountable = 'N/A';     %might need to change? might be radiator.. 
structures(1).Surface(1).buildableDir = 'XY';
structures(1).Surface(1).normalFace = '-Z';
structures(1).Surface(1).availableX = [-L/2,L/2];
structures(1).Surface(1).availableY = [-W/2,W/2];
structures(1).Surface(1).availableZ = [0,-inf];
structures(1).Surface(1).availableA = L*W;
 


%% 2, North Face Panel (Normal to +Y axis)
bottomVert = [L/2,W/2-init_t,init_t; -L/2,W/2-init_t,init_t;
                 -L/2,W/2,init_t; L/2,W/2,init_t];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+H-2*init_t;

structures(2).Name = 'Velocity Vector Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = material;
structures(2).Mass = []; % This will be density times volume
structures(2).Dim = [H-2*init_t,init_t,L]; % use the satial paramaters.
structures(2).CG_XYZ = [0,W/2-init_t/2,(H-init_t)/2+init_t];
structures(2).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(2).Top_Vertices = topVert;
structures(2).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(2).Surface(1).Mountable = 'N/A';
structures(2).Surface(1).buildableDir = 'XZ';
structures(2).Surface(1).normalFace = '+Y';
structures(2).Surface(1).availableX = [L/2,-L/2];
structures(2).Surface(1).availableY = [W/2,inf];
structures(2).Surface(1).availableZ = [0,H];
structures(2).Surface(1).availableA = L*H;

%% 3, South Face Panel (normal to -Y)
bottomVert = [L/2,-(W/2-init_t),init_t; -L/2,-(W/2-init_t),init_t;
                 -L/2,-W/2,init_t; L/2,-W/2,init_t];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+H-2*init_t;

structures(3).Name = '-Velocity Vector Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = [];
structures(3).Mass = []; % This will be density times volume
structures(3).Dim = [H-2*init_t,init_t,L]; % use the satial paramaters.
structures(3).CG_XYZ = [0,-W/2+init_t/2,(H-init_t)/2+init_t];
structures(3).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(3).Top_Vertices = topVert;
structures(3).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(3).Surface(1).Mountable = 'N/A';
structures(3).Surface(1).buildableDir = 'XZ';
structures(3).Surface(1).normalFace = '-Y';
structures(3).Surface(1).availableX = [-L/2,L/2];
structures(3).Surface(1).availableY = [-W/2,-inf];
structures(3).Surface(1).availableZ = [0,H];
structures(3).Surface(1).availableA = L*H;


%% 4, East Face Panel (normal to +X)
bottomVert = [L/2-init_t,-W/2,init_t; L/2-init_t,W/2,init_t;
                 L/2,W/2,init_t;
                 L/2,-W/2,init_t];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+H-2*init_t;

structures(4).Name = '+X Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = [];
structures(4).Mass = []; % This will be density times volume
structures(4).Dim = [H-init_t,init_t,L]; % use the satial paramaters.
structures(4).CG_XYZ = [L/2-init_t/2,0,(H-init_t)/2+init_t];
structures(4).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(4).Top_Vertices = topVert;
structures(4).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(4).Surface(1).Mountable = 'N/A';
structures(4).Surface(1).buildableDir = 'YZ';
structures(4).Surface(1).normalFace = '+X';
structures(4).Surface(1).availableX = [L/2,inf];
structures(4).Surface(1).availableY = [-W/2,W/2];
structures(4).Surface(1).availableZ = [0,H];
structures(4).Surface(1).availableA = L*W;


%% 5, West Face Panel (normal to -X)
bottomVert = [-(L/2-init_t),-W/2,init_t; -(L/2-init_t),W/2,init_t;
                 -L/2,W/2,init_t; -L/2,-W/2,init_t];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+H-2*init_t;

structures(5).Name = '-X Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = [];
structures(5).Mass = []; % This will be density times volume
structures(5).Dim = [H-init_t,init_t,L]; % use the satial paramaters.
structures(5).CG_XYZ = [-L/2+init_t/2,0,(H-init_t)/2+init_t];
structures(5).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(5).Top_Vertices = topVert;
structures(5).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(5).Surface(1).Mountable = 'N/A';
structures(5).Surface(1).buildableDir = 'YZ';
structures(5).Surface(1).normalFace = '-X';
structures(5).Surface(1).availableX = [-L/2,-inf];
structures(5).Surface(1).availableY = [W/2,-W/2];
structures(5).Surface(1).availableZ = [0,H];
structures(5).Surface(1).availableA = L*W;



%% 6, Top Panel (normal to +Z)
bottomVert = [L/2,W/2,H-init_t;
                 -L/2,W/2,H-init_t;
                 -L/2,-W/2,H-init_t;
                 L/2,-W/2,H-init_t];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+init_t;

structures(6).Name = 'Nadir Panel';
structures(6).Shape = 'Rectangle';
structures(6).Material = [];
structures(6).Mass = []; % This will be density times volume
structures(6).Dim = [init_t,W,L]; % use the satial paramaters.
structures(6).CG_XYZ = [0,0,H-init_t/2]; % Make the origin at the base of the bottom panel.
structures(6).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(6).Top_Vertices = topVert;
structures(6).Plane = 'XY';

% Outside Surface to mount parts on
structures(6).Surface(1).Mountable = 'Payload';
structures(6).Surface(1).buildableDir = 'XY';
structures(6).Surface(1).normalFace = '+Z';
structures(6).Surface(1).availableX = -[-L/2,L/2]; % This needs to be in the negative direciton, as if the x direction is facing you and you're mounting into the page
structures(6).Surface(1).availableY = [-W/2,W/2]; 
structures(6).Surface(1).availableZ = [H,+inf];
 




end

