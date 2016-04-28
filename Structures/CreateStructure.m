function [structures,genParameters] = CreateStructure(genParameters)

if strcmp(genParameters.spacecraftType,'Central Cylinder');
    structures = CylinderStructure(genParameters);
    genParameters = OrderedSurfaces(genParameters);
    
elseif strfind(genParameters.spacecraftType,'Stacked');
    structures = StackedStructure(genParameters);
    genParameters = OrderedSurfaces(genParameters);
end

function structures = StackedStructure(genParameters)
% You will have a structure inside the structure. The main structure tells
% details about the actual shape and object, while the second structure
% tells about the surfaces available to mount components on for the
% structure.

%% 1, Bottom Panel (Normal to -Z)
bottomVert = [genParameters.satLength/2,genParameters.satWidth/2-genParameters.aluminumThickness,0;
                 -genParameters.satLength/2,genParameters.satWidth/2-genParameters.aluminumThickness,0;
                 -genParameters.satLength/2,genParameters.satWidth/2,0;
                 genParameters.satLength/2,genParameters.satWidth/2,0];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.aluminumThickness;

structures(1).Name = 'Bottom Panel';
structures(1).Shape = 'Rectangle';
structures(1).Material = 'Aluminum';
structures(1).Mass = []; % This will be density times volume
structures(1).Dim = [genParameters.aluminumThickness,genParameters.satWidth,genParameters.satLength]; % use the satial paramaters.
structures(1).CG_XYZ = [0,0,genParameters.aluminumThickness/2]; % Make the origin at the middle of the bottom panel.
structures(1).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(1).Top_Vertices = topVert;
structures(1).Plane = 'XY';

% Outside Surface to mount parts on
structures(1).Surface(1).Mountable = 'N/A';
structures(1).Surface(1).buildableDir = 'XY';
structures(1).Surface(1).normalFace = '-Z';
structures(1).Surface(1).availableX = [-genParameters.satLength/2,genParameters.satLength/2];
structures(1).Surface(1).availableY = [-genParameters.satWidth/2,genParameters.satWidth/2];
structures(1).Surface(1).availableZ = [0,-inf];
 


%% 2, North Face Panel (Normal to +Y axis)
bottomVert = [genParameters.satLength/2,genParameters.satWidth/2-genParameters.aluminumThickness,genParameters.aluminumThickness;
                 -genParameters.satLength/2,genParameters.satWidth/2-genParameters.aluminumThickness,genParameters.aluminumThickness;
                 -genParameters.satLength/2,genParameters.satWidth/2,genParameters.aluminumThickness;
                 genParameters.satLength/2,genParameters.satWidth/2,genParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.satHeight-2*genParameters.aluminumThickness;

structures(2).Name = 'North Face Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = 'Aluminum';
structures(2).Mass = []; % This will be density times volume
structures(2).Dim = [genParameters.satHeight-2*genParameters.aluminumThickness,genParameters.aluminumThickness,genParameters.satLength]; % use the satial paramaters.
structures(2).CG_XYZ = [0,genParameters.satWidth/2-genParameters.aluminumThickness/2,(genParameters.satHeight-genParameters.aluminumThickness)/2+genParameters.aluminumThickness];
structures(2).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(2).Top_Vertices = topVert;
structures(2).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(2).Surface(1).Mountable = 'N/A';
structures(2).Surface(1).buildableDir = 'XZ';
structures(2).Surface(1).normalFace = '+Y';
structures(2).Surface(1).availableX = [genParameters.satLength/2,-genParameters.satLength/2];
structures(2).Surface(1).availableY = [genParameters.satWidth/2,inf];
structures(2).Surface(1).availableZ = [0,genParameters.satHeight];

%% 3, South Face Panel (normal to -Y)
bottomVert = [genParameters.satLength/2,-(genParameters.satWidth/2-genParameters.aluminumThickness),genParameters.aluminumThickness;
                 -genParameters.satLength/2,-(genParameters.satWidth/2-genParameters.aluminumThickness),genParameters.aluminumThickness;
                 -genParameters.satLength/2,-genParameters.satWidth/2,genParameters.aluminumThickness;
                 genParameters.satLength/2,-genParameters.satWidth/2,genParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.satHeight-2*genParameters.aluminumThickness;

structures(3).Name = 'South Face Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = 'Aluminum';
structures(3).Mass = []; % This will be density times volume
structures(3).Dim = [genParameters.satHeight-2*genParameters.aluminumThickness,genParameters.aluminumThickness,genParameters.satLength]; % use the satial paramaters.
structures(3).CG_XYZ = [0,-genParameters.satWidth/2+genParameters.aluminumThickness/2,(genParameters.satHeight-genParameters.aluminumThickness)/2+genParameters.aluminumThickness];
structures(3).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(3).Top_Vertices = topVert;
structures(3).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(3).Surface(1).Mountable = 'N/A';
structures(3).Surface(1).buildableDir = 'XZ';
structures(3).Surface(1).normalFace = '-Y';
structures(3).Surface(1).availableX = [-genParameters.satLength/2,genParameters.satLength/2];
structures(3).Surface(1).availableY = [-genParameters.satWidth/2,-inf];
structures(3).Surface(1).availableZ = [0,genParameters.satHeight];


%% 4, East Face Panel (normal to +X)
bottomVert = [genParameters.satLength/2-genParameters.aluminumThickness,-genParameters.satWidth/2,genParameters.aluminumThickness;
                 genParameters.satLength/2-genParameters.aluminumThickness,genParameters.satWidth/2,genParameters.aluminumThickness;
                 genParameters.satLength/2,genParameters.satWidth/2,genParameters.aluminumThickness;
                 genParameters.satLength/2,-genParameters.satWidth/2,genParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.satHeight-2*genParameters.aluminumThickness;

structures(4).Name = 'East Face Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = 'Aluminum';
structures(4).Mass = []; % This will be density times volume
structures(4).Dim = [genParameters.satHeight-genParameters.aluminumThickness,genParameters.aluminumThickness,genParameters.satLength]; % use the satial paramaters.
structures(4).CG_XYZ = [genParameters.satLength/2-genParameters.aluminumThickness/2,0,(genParameters.satHeight-genParameters.aluminumThickness)/2+genParameters.aluminumThickness];
structures(4).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(4).Top_Vertices = topVert;
structures(4).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(4).Surface(1).Mountable = 'N/A';
structures(4).Surface(1).buildableDir = 'YZ';
structures(4).Surface(1).normalFace = '+X';
structures(4).Surface(1).availableX = [genParameters.satLength/2,inf];
structures(4).Surface(1).availableY = [-genParameters.satWidth/2,genParameters.satWidth/2];
structures(4).Surface(1).availableZ = [0,genParameters.satHeight];


%% 5, West Face Panel (normal to -X)
bottomVert = [-(genParameters.satLength/2-genParameters.aluminumThickness),-genParameters.satWidth/2,genParameters.aluminumThickness;
                 -(genParameters.satLength/2-genParameters.aluminumThickness),genParameters.satWidth/2,genParameters.aluminumThickness;
                 -genParameters.satLength/2,genParameters.satWidth/2,genParameters.aluminumThickness;
                 -genParameters.satLength/2,-genParameters.satWidth/2,genParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.satHeight-2*genParameters.aluminumThickness;

structures(5).Name = 'West Face Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = 'Aluminum';
structures(5).Mass = []; % This will be density times volume
structures(5).Dim = [genParameters.satHeight-genParameters.aluminumThickness,genParameters.aluminumThickness,genParameters.satLength]; % use the satial paramaters.
structures(5).CG_XYZ = [-genParameters.satLength/2+genParameters.aluminumThickness/2,0,(genParameters.satHeight-genParameters.aluminumThickness)/2+genParameters.aluminumThickness];
structures(5).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(5).Top_Vertices = topVert;
structures(5).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(5).Surface(1).Mountable = 'N/A';
structures(5).Surface(1).buildableDir = 'YZ';
structures(5).Surface(1).normalFace = '-X';
structures(5).Surface(1).availableX = [-genParameters.satLength/2,-inf];
structures(5).Surface(1).availableY = [genParameters.satWidth/2,-genParameters.satWidth/2];
structures(5).Surface(1).availableZ = [0,genParameters.satHeight];


%% 6, Top Panel (normal to +Z)
bottomVert = [genParameters.satLength/2,genParameters.satWidth/2,genParameters.satHeight-genParameters.aluminumThickness;
                 -genParameters.satLength/2,genParameters.satWidth/2,genParameters.satHeight-genParameters.aluminumThickness;
                 -genParameters.satLength/2,-genParameters.satWidth/2,genParameters.satHeight-genParameters.aluminumThickness;
                 genParameters.satLength/2,-genParameters.satWidth/2,genParameters.satHeight-genParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+genParameters.aluminumThickness;

structures(6).Name = 'Top Panel';
structures(6).Shape = 'Rectangle';
structures(6).Material = 'Aluminum';
structures(6).Mass = []; % This will be density times volume
structures(6).Dim = [genParameters.aluminumThickness,genParameters.satWidth,genParameters.satLength]; % use the satial paramaters.
structures(6).CG_XYZ = [0,0,genParameters.satHeight-genParameters.aluminumThickness/2]; % Make the origin at the base of the bottom panel.
structures(6).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(6).Top_Vertices = topVert;
structures(6).Plane = 'XY';

% Outside Surface to mount parts on
structures(6).Surface(1).Mountable = 'N/A';
structures(6).Surface(1).buildableDir = 'XY';
structures(6).Surface(1).normalFace = '+Z';
structures(6).Surface(1).availableX = -[-genParameters.satLength/2,genParameters.satLength/2]; % This needs to be in the negative direciton, as if the x direction is facing you and you're mounting into the page
structures(6).Surface(1).availableY = [-genParameters.satWidth/2,genParameters.satWidth/2]; 
structures(6).Surface(1).availableZ = [genParameters.satHeight,+inf];
 
%% 7-inf, Inside Mounting Panel (normal to +Z)

for i = 1:size(genParameters.trays,1)
    height = genParameters.trays(i,2);
    bottomVert = [genParameters.satLength/2-genParameters.aluminumThickness,genParameters.satWidth/2-genParameters.aluminumThickness,height;
                     -genParameters.satLength/2+genParameters.aluminumThickness,genParameters.satWidth/2-genParameters.aluminumThickness,height;
                     -genParameters.satLength/2+genParameters.aluminumThickness,-genParameters.satWidth/2+genParameters.aluminumThickness,height;
                     genParameters.satLength/2-genParameters.aluminumThickness,-genParameters.satWidth/2+genParameters.aluminumThickness,height];

    topVert = bottomVert;
    topVert(:,3) = topVert(:,3)+genParameters.aluminumThickness;

    structures(6+i).Name = 'Inside Mounting Panel';
    structures(6+i).Shape = 'Rectangle';
    structures(6+i).Material = 'Aluminum';
    structures(6+i).Mass = []; % This will be density times volume
    structures(6+i).Dim = [genParameters.aluminumThickness,genParameters.satWidth,genParameters.satLength]; % use the satial paramaters.
    structures(6+i).CG_XYZ = [0,0,genParameters.aluminumThickness*1.5];
    structures(6+i).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
    structures(6+i).Top_Vertices = topVert;
    structures(6+i).Plane = 'XY';

    % Inside Surface to mount parts on
    structures(6+i).Surface(1).Mountable = 'N/A';
    structures(6+i).Surface(1).buildableDir = 'XY';
    structures(6+i).Surface(1).normalFace = '+Z';
    structures(6+i).Surface(1).availableX = -[-genParameters.satLength/2+genParameters.aluminumThickness,genParameters.satLength/2-genParameters.aluminumThickness];
    structures(6+i).Surface(1).availableY = [-genParameters.satWidth/2+genParameters.aluminumThickness,genParameters.satWidth/2-genParameters.aluminumThickness];
    structures(6+i).Surface(1).availableZ = [2*genParameters.aluminumThickness+height,genParameters.satHeight-genParameters.aluminumThickness];
end


function structures = CylinderStructure(genParameters)
%%
% A function that creates the structure for a central cylinder-based
% structure.
ratios = genParameters.ratios;
shearWidth = ratios.shear_cylinder*genParameters.cylinderDiam;
panelWidth = ratios.panel_cylinder*genParameters.cylinderDiam;

% Make the width of the panels for now 0.5 meters
%% 1, create the central cylinder

% You will have a structure inside the structure. The main structure tells
% details about the actual shape and object, while the second structure
% tells about the surfaces available to mount components on for the
% structure.

structures(1).Name = 'Central Cylinder';
structures(1).Shape = 'Cylinder Hollow';
structures(1).Material = 'Carbon Fiber';
structures(1).Mass = []; % This will be density times volume
structures(1).Dim = [genParameters.satHeight-2*genParameters.honeycombThickness,genParameters.cylinderDiam/2,genParameters.carbonfiberThickness]; % use the satial paramaters.
structures(1).CG_XYZ = [0,0,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(1).Bottom_Vertices = [0,0,genParameters.honeycombThickness]; % For a cylinder the Vertices are just the bottom center point.
structures(1).Top_Vertices = [0,0,genParameters.satHeight-2*genParameters.honeycombThickness];
structures(1).Plane = 'Z';

% Place fuel tanks inside the central cylinder
structures(1).Surface(1).Mountable = 'Fuel Tank';
structures(1).Surface(1).buildableDir = '+Z';
structures(1).Surface(1).normalFace = '+Z';
structures(1).Surface(1).availableX = [-genParameters.cylinderDiam/2,genParameters.cylinderDiam/2];
structures(1).Surface(1).availableY = [-genParameters.cylinderDiam/2,genParameters.cylinderDiam/2];
structures(1).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];


%% 2, create the North shear panels along the y axis
bottomVert = [genParameters.honeycombThickness/2,genParameters.cylinderDiam/2,genParameters.honeycombThickness;
                 -genParameters.honeycombThickness/2,genParameters.cylinderDiam/2,genParameters.honeycombThickness;
                 -genParameters.honeycombThickness/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness;
                 genParameters.honeycombThickness/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness];
    
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness;

structures(2).Name = 'North Shear Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = 'Honeycomb';
structures(2).Dim = [genParameters.satHeight-2*genParameters.honeycombThickness,shearWidth,genParameters.honeycombThickness];
structures(2).CG_XYZ = [0,genParameters.cylinderDiam/2+shearWidth/2,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(2).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(2).Top_Vertices = topVert;
structures(2).Plane = 'YZ';

% North Shear Panel Face 1
structures(2).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(2).Surface(1).normalFace = '+X';
structures(2).Surface(1).buildableDir = 'YZ';
structures(2).Surface(1).Location = 'Inside';
structures(2).Surface(1).availableX = [genParameters.honeycombThickness/2,inf];
structures(2).Surface(1).availableY = [genParameters.cylinderDiam/2,genParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% North Shear Panel Face 2
structures(2).Surface(2).normalFace = '-X';
structures(2).Surface(2).buildableDir = 'YZ';
structures(2).Surface(2).Location = 'Inside';
structures(2).Surface(2).availableX = [-genParameters.honeycombThickness/2,-inf];
structures(2).Surface(2).availableY = [genParameters.cylinderDiam/2,genParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];


%% 3, create the South shear panels along the y axis

bottomVert = [genParameters.honeycombThickness/2,-genParameters.cylinderDiam/2,genParameters.honeycombThickness;
                 -genParameters.honeycombThickness/2,-genParameters.cylinderDiam/2,genParameters.honeycombThickness;
                 -genParameters.honeycombThickness/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 genParameters.honeycombThickness/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness];
    
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness;

structures(3).Name = 'South Shear Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = 'Honeycomb';
structures(3).Dim = [genParameters.satHeight-2*genParameters.honeycombThickness,shearWidth,genParameters.honeycombThickness];
structures(3).CG_XYZ = [0,-genParameters.cylinderDiam/2-shearWidth/2,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(3).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(3).Top_Vertices = topVert;
structures(3).Plane = 'YZ';

% South Shear Panel Face 1
structures(3).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(1).normalFace = '-X';
structures(3).Surface(1).buildableDir = 'YZ';
structures(3).Surface(1).Location = 'Inside';
structures(3).Surface(1).availableX = [-genParameters.honeycombThickness/2,-inf];
structures(3).Surface(1).availableY = [-genParameters.cylinderDiam/2,-genParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% South Shear Panel Face 2
structures(3).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(2).normalFace = '+X';
structures(3).Surface(2).buildableDir = 'YZ';
structures(3).Surface(2).Location = 'Inside';
structures(3).Surface(2).availableX = [genParameters.honeycombThickness/2,inf];
structures(3).Surface(2).availableY = [-genParameters.cylinderDiam/2,-genParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

%% 4, North panel
bottomVert = [panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2,genParameters.cylinderDiam/2+shearWidth+genParameters.honeycombThickness,genParameters.honeycombThickness;
                  panelWidth/2,genParameters.cylinderDiam/2+shearWidth+genParameters.honeycombThickness,genParameters.honeycombThickness];

topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness;                        


structures(4).Name = 'North Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = 'Honeycomb';
structures(4).Dim = [genParameters.satHeight-2*genParameters.honeycombThickness,genParameters.honeycombThickness,panelWidth];
structures(4).CG_XYZ = [0,shearWidth+genParameters.honeycombThickness/2,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(4).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(4).Top_Vertices = topVert;
structures(4).Plane = 'XZ';

% North Panel Face 1
structures(4).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(1).normalFace = '-Y';
structures(4).Surface(1).buildableDir = 'XZ';
structures(4).Surface(1).Location = 'Inside';
structures(4).Surface(1).availableX = [genParameters.honeycombThickness/2,panelWidth/2];
structures(4).Surface(1).availableY = [genParameters.cylinderDiam/2+shearWidth,genParameters.cylinderDiam/2];
structures(4).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% North Panel Face 2
structures(4).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(2).normalFace = '-Y';
structures(4).Surface(2).buildableDir = 'XZ';
structures(4).Surface(2).Location = 'Inside';
structures(4).Surface(2).availableX = [-genParameters.honeycombThickness/2,-panelWidth/2];
structures(4).Surface(2).availableY = [genParameters.cylinderDiam/2+shearWidth,genParameters.cylinderDiam/2];
structures(4).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% North Panel Outside Face
structures(4).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(4).Surface(3).normalFace = '+Y';
structures(4).Surface(3).buildableDir = 'XZ';
structures(4).Surface(3).Location = 'Outside';
structures(4).Surface(3).availableX = [-panelWidth/2,panelWidth/2];
structures(4).Surface(3).availableY = [genParameters.cylinderDiam/2+shearWidth+genParameters.honeycombThickness,inf];
structures(4).Surface(3).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];


%% 5, South panel
bottomVert = [panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2,-genParameters.cylinderDiam/2-shearWidth-genParameters.honeycombThickness,genParameters.honeycombThickness;
                 panelWidth/2,-genParameters.cylinderDiam/2-shearWidth-genParameters.honeycombThickness,genParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness; 


structures(5).Name = 'South Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = 'Honeycomb';
structures(5).Dim = [genParameters.satHeight-2*genParameters.honeycombThickness,genParameters.honeycombThickness,panelWidth];
structures(5).CG_XYZ = [0,-shearWidth-genParameters.honeycombThickness/2,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(5).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(5).Top_Vertices = topVert;
structures(5).Plane = 'XZ';

% South Panel Face 1
structures(5).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(1).normalFace = '+Y';
structures(5).Surface(1).buildableDir = 'XZ';
structures(5).Surface(1).Location = 'Inside';
structures(5).Surface(1).availableX = [-genParameters.honeycombThickness/2,-panelWidth/2];
structures(5).Surface(1).availableY = [-(genParameters.cylinderDiam/2+shearWidth),-genParameters.cylinderDiam/2];
structures(5).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% South Panel Face 2
structures(5).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(2).normalFace = '+Y';
structures(5).Surface(2).buildableDir = 'XZ';
structures(5).Surface(2).Location = 'Inside';
structures(5).Surface(2).availableX = [genParameters.honeycombThickness/2,panelWidth/2];
structures(5).Surface(2).availableY = [-(genParameters.cylinderDiam/2+shearWidth),-genParameters.cylinderDiam/2];
structures(5).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% South Panel Outside Face
structures(5).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(3).normalFace = '-Y';
structures(5).Surface(3).buildableDir = 'XZ';
structures(5).Surface(3).Location = 'Outside';
structures(5).Surface(3).availableX = [panelWidth/2,-panelWidth/2];
structures(5).Surface(3).availableY = [-(genParameters.cylinderDiam/2+shearWidth+genParameters.honeycombThickness),-inf];
structures(5).Surface(3).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

%% 6, East panel
bottomVert = [panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 panelWidth/2-genParameters.honeycombThickness,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 panelWidth/2-genParameters.honeycombThickness,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness;
                 panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness; 

structures(6).Name = 'East Panel';
structures(6).Shape = 'Rectangle';
structures(6).Material = 'Honeycomb';
structures(6).Dim = [genParameters.satHeight,panelWidth,genParameters.honeycombThickness];
structures(6).CG_XYZ = [panelWidth/2-genParameters.honeycombThickness/2,0,(genParameters.satHeight-2*genParameters.honeycombThickness)/2+genParameters.honeycombThickness];
structures(6).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(6).Top_Vertices = topVert;
structures(6).Plane = 'YZ';

% East Panel Inside Face
structures(6).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(6).Surface(1).normalFace = '-X';
structures(6).Surface(1).buildableDir = 'YZ';
structures(6).Surface(1).Location = 'Inside';
structures(6).Surface(1).availableX = -[panelWidth/2-genParameters.honeycombThickness/2,genParameters.cylinderDiam/2];
structures(6).Surface(1).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth];
structures(6).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% East Panel Outside Face
structures(6).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(6).Surface(2).normalFace = '+X';
structures(6).Surface(2).buildableDir = 'YZ';
structures(6).Surface(2).Location = 'Outside';
structures(6).Surface(2).availableX = [panelWidth/2,inf];
structures(6).Surface(2).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth];
structures(6).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

%% 7, West panel
bottomVert = [-panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2+genParameters.honeycombThickness,-genParameters.cylinderDiam/2-shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2+genParameters.honeycombThickness,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness;
                 -panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight - 2*genParameters.honeycombThickness; 

structures(7).Name = 'West Panel';
structures(7).Shape = 'Rectangle';
structures(7).Material = 'Honeycomb';
structures(7).Dim = [genParameters.satHeight,panelWidth,genParameters.honeycombThickness];
structures(7).CG_XYZ = [-panelWidth/2+genParameters.honeycombThickness/2,0,genParameters.satHeight/2];
structures(7).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(7).Top_Vertices = topVert;
structures(7).Plane = 'YZ';

% West Panel Inside Face
structures(7).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(7).Surface(1).normalFace = '+X';
structures(7).Surface(1).buildableDir = 'YZ';
structures(7).Surface(1).Location = 'Inside';
structures(7).Surface(1).availableX = [-panelWidth/2+genParameters.honeycombThickness/2,-genParameters.cylinderDiam/2];
structures(7).Surface(1).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth-genParameters.honeycombThickness];
structures(7).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

% West Panel Outside Face
structures(7).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(7).Surface(2).normalFace = '-X';
structures(7).Surface(2).buildableDir = 'YZ';
structures(7).Surface(2).Location = 'Outside';
structures(7).Surface(2).availableX = [-panelWidth/2,-inf];
structures(7).Surface(2).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth];
structures(7).Surface(2).availableZ = [genParameters.honeycombThickness,genParameters.satHeight-genParameters.honeycombThickness];

%% 8, Bottom panel
bottomVert = [-panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,0;
                 -panelWidth/2,genParameters.cylinderDiam/2+shearWidth,0;
                 panelWidth/2,genParameters.cylinderDiam/2+shearWidth,0;
                 panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,0];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.honeycombThickness; 

structures(8).Name = 'Bottom Panel';
structures(8).Shape = 'Rectangle';
structures(8).Material = 'Honeycomb';
structures(8).Dim = [genParameters.honeycombThickness,genParameters.cylinderDiam+shearWidth*2+genParameters.honeycombThickness*2,panelWidth];
structures(8).CG_XYZ = [0,0,genParameters.honeycombThickness/2];
structures(8).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(8).Top_Vertices = topVert;
structures(8).Plane = 'XY';

% 
% Bottom Panel Inside Face
structures(8).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(8).Surface(1).normalFace = '+Z';
structures(8).Surface(1).buildableDir = 'XY';
structures(8).Surface(1).Location = 'Inside';
structures(8).Surface(1).availableX = [-panelWidth/2,+panelWidth/2];
structures(8).Surface(1).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth];
structures(8).Surface(1).availableZ = [genParameters.honeycombThickness,genParameters.satHeight];

%% 9, Top panel
bottomVert = [-panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.satHeight-genParameters.honeycombThickness;
                 -panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.satHeight-genParameters.honeycombThickness;
                 panelWidth/2,genParameters.cylinderDiam/2+shearWidth,genParameters.satHeight-genParameters.honeycombThickness;
                 panelWidth/2,-genParameters.cylinderDiam/2-shearWidth,genParameters.satHeight-genParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + genParameters.satHeight; 

structures(9).Name = 'Bottom Panel';
structures(9).Shape = 'Rectangle';
structures(9).Material = 'Honeycomb';
structures(9).Dim = [genParameters.honeycombThickness,genParameters.cylinderDiam+shearWidth*2+genParameters.honeycombThickness*2,panelWidth];
structures(9).CG_XYZ = [0,0,genParameters.satHeight+genParameters.honeycombThickness/2];
structures(9).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(9).Top_Vertices = topVert;
structures(8).Plane = 'XY';

% 
% Bottom Panel Inside Face
structures(9).Surface(1).Mountable = 'Payload'; % Don't need any specifics
structures(9).Surface(1).normalFace = '+Z';
structures(9).Surface(1).buildableDir = '+Z';
structures(9).Surface(1).availableX = [-panelWidth/2,+panelWidth/2];
structures(9).Surface(1).availableY = [-genParameters.cylinderDiam/2-shearWidth,genParameters.cylinderDiam/2+shearWidth];
structures(9).Surface(1).availableZ = [genParameters.satHeight,inf];

function genParameters = OrderedSurfaces(genParameters)
% This allows someone to decide what surfaces to mount on first for inside
% vs outside surfaces. This gives the order that instruments should be
% placed on the satellite in the order of: [index of structure, index of surface on that structure]

if strcmp(genParameters.spacecraftType,'Central Cylinder')
    buildableIndices.Inside = [2,1;
                                3,1;
                                2,2;
                                3,2;
                                4,1;
                                5,1;
                                4,2;
                                5,2;
                                6,1;
                                7,1];
%     structuresIndices.Inside = [4,1];
%                                 2,1];
    buildableIndices.Outside = [4,3;
                                5,3;
                                6,2;
                                7,2];
    buildableIndices.Specific(1).Name = 'Payload';
    buildableIndices.Specific(1).Index = [9,1];
    buildableIndices.Specific(2).Name = 'Fuel Tank';
    buildableIndices.Specific(2).Index = [1,1];
    buildableIndices.Specific(3).Name = 'Thruster';
    buildableIndices.Specific(3).Index = [1,1];
elseif strfind(genParameters.spacecraftType,'Stacked')

    n = size(genParameters.trays,1);
    buildableIndices.Inside = zeros(n,2);
    for i = 1:n
        buildableIndices.Inside(i,:) = [6+i,1]; 
    end
%     structuresIndices.Outside = [3,1];
    buildableIndices.Outside = [2,1;
                                3,1;
                                4,1;
                                5,1;
                                6,1;
                                1,1];
    buildableIndices.Specific(1).Name = 'Payload';
    buildableIndices.Specific(1).Index = [6,1];
end
genParameters.buildableIndices = buildableIndices;


