function [structures,generalParameters] = InitStructure(componentSize,structureType)


if strcmp(structureType,'Central Cylinder')
    % the component is the tank
    % Aspect ratios used for the satellite.
    generalParameters.spacecraftType = 'Central Cylinder';
    generalParameters.cylinderDiam = componentSize;
    generalParameters.initHeight = 1;
    generalParameters.tolerance = 0.025; % tolerance for space between components.
    ratios.shear_cylinder = 0.3;
    ratios.panel_cylinder = 1.2;
    generalParameters.honeycombThickness = .02;
    generalParameters.carbonfiberThickness = .03;
    
    [structures] = CylinderStructure(generalParameters,ratios);  
    generalParameters.buildableIndices = OrderedSurfaces(structureType);
elseif strcmp(structureType,'Stacked')
    generalParameters.tolerance = 0.001; % tolerance for space between components.
    generalParameters.aluminumThickness = .002; % Initial thickness of aluminum
    generalParameters.carbonfiberThickness = .03; % Initial thickness of carbon fiber
    if componentSize <= 0.3
        % Create a stacked satellite
        generalParameters.spacecraftType = 'Stacked - Cubesat';
        % If the largest component is smaller than 10 centimeters, create a
        % cubesat shape
        generalParameters.initWidth = .1; % Initial Length
        generalParameters.initLength = .1; % Initial Width
        generalParameters.initHeight = .1; % Initial Height    
    else 
        % Create a stacked satellite
        generalParameters.spacecraftType = 'Stacked';
        % Else just use a ratio that scales the size of the satellite
        % compared to the biggest component to get the width, length, and
        % height
        ratios.size_component = 1.8;
        generalParameters.initWidth = ratios.size_component*componentSize; % Initial Length
        generalParameters.initLength = ratios.size_component*componentSize; % Initial Width
        generalParameters.initHeight = .1; % Initial Height    
    end

    structures = StackedStructure(generalParameters);
    generalParameters.buildableIndices = OrderedSurfaces(structureType);
end

function structures = StackedStructure(initParameters)
% You will have a structure inside the structure. The main structure tells
% details about the actual shape and object, while the second structure
% tells about the surfaces available to mount components on for the
% structure.

%% 1, Bottom Panel (Normal to -Z)
bottomVert = [initParameters.initLength/2,initParameters.initWidth/2-initParameters.aluminumThickness,0;
                 -initParameters.initLength/2,initParameters.initWidth/2-initParameters.aluminumThickness,0;
                 -initParameters.initLength/2,initParameters.initWidth/2,0;
                 initParameters.initLength/2,initParameters.initWidth/2,0];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.aluminumThickness;

structures(1).Name = 'Bottom Panel';
structures(1).Shape = 'Rectangle';
structures(1).Material = 'Aluminum';
structures(1).Mass = []; % This will be density times volume
structures(1).Dim = [initParameters.aluminumThickness,initParameters.initWidth,initParameters.initLength]; % use the initial paramaters.
structures(1).CG_XYZ = [0,0,initParameters.aluminumThickness/2]; % Make the origin at the middle of the bottom panel.
structures(1).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(1).Top_Vertices = topVert;
structures(1).Plane = 'XY';

% Outside Surface to mount parts on
structures(1).Surface(1).Mountable = 'N/A';
structures(1).Surface(1).buildableDir = 'XY';
structures(1).Surface(1).normalFace = '-Z';
structures(1).Surface(1).availableX = [-initParameters.initLength/2,initParameters.initLength/2];
structures(1).Surface(1).availableY = [-initParameters.initWidth/2,initParameters.initWidth/2];
structures(1).Surface(1).availableZ = [0,-inf];
 


%% 2, North Face Panel (Normal to +Y axis)
bottomVert = [initParameters.initLength/2,initParameters.initWidth/2-initParameters.aluminumThickness,initParameters.aluminumThickness;
                 -initParameters.initLength/2,initParameters.initWidth/2-initParameters.aluminumThickness,initParameters.aluminumThickness;
                 -initParameters.initLength/2,initParameters.initWidth/2,initParameters.aluminumThickness;
                 initParameters.initLength/2,initParameters.initWidth/2,initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.initHeight-2*initParameters.aluminumThickness;

structures(2).Name = 'North Face Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = 'Aluminum';
structures(2).Mass = []; % This will be density times volume
structures(2).Dim = [initParameters.initHeight-2*initParameters.aluminumThickness,initParameters.aluminumThickness,initParameters.initLength]; % use the initial paramaters.
structures(2).CG_XYZ = [0,initParameters.initWidth/2-initParameters.aluminumThickness/2,(initParameters.initHeight-initParameters.aluminumThickness)/2+initParameters.aluminumThickness];
structures(2).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(2).Top_Vertices = topVert;
structures(2).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(2).Surface(1).Mountable = 'N/A';
structures(2).Surface(1).buildableDir = 'XZ';
structures(2).Surface(1).normalFace = '+Y';
structures(2).Surface(1).availableX = [initParameters.initLength/2,-initParameters.initLength/2];
structures(2).Surface(1).availableY = [initParameters.initWidth/2,inf];
structures(2).Surface(1).availableZ = [0,initParameters.initHeight];

%% 3, South Face Panel (normal to -Y)
bottomVert = [initParameters.initLength/2,-(initParameters.initWidth/2-initParameters.aluminumThickness),initParameters.aluminumThickness;
                 -initParameters.initLength/2,-(initParameters.initWidth/2-initParameters.aluminumThickness),initParameters.aluminumThickness;
                 -initParameters.initLength/2,-initParameters.initWidth/2,initParameters.aluminumThickness;
                 initParameters.initLength/2,-initParameters.initWidth/2,initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.initHeight-2*initParameters.aluminumThickness;

structures(3).Name = 'South Face Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = 'Aluminum';
structures(3).Mass = []; % This will be density times volume
structures(3).Dim = [initParameters.initHeight-2*initParameters.aluminumThickness,initParameters.aluminumThickness,initParameters.initLength]; % use the initial paramaters.
structures(3).CG_XYZ = [0,-initParameters.initWidth/2+initParameters.aluminumThickness/2,(initParameters.initHeight-initParameters.aluminumThickness)/2+initParameters.aluminumThickness];
structures(3).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(3).Top_Vertices = topVert;
structures(3).Plane = 'XZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(3).Surface(1).Mountable = 'N/A';
structures(3).Surface(1).buildableDir = 'XZ';
structures(3).Surface(1).normalFace = '-Y';
structures(3).Surface(1).availableX = [-initParameters.initLength/2,initParameters.initLength/2];
structures(3).Surface(1).availableY = [-initParameters.initWidth/2,-inf];
structures(3).Surface(1).availableZ = [0,initParameters.initHeight];


%% 4, East Face Panel (normal to +X)
bottomVert = [initParameters.initLength/2-initParameters.aluminumThickness,-initParameters.initWidth/2,initParameters.aluminumThickness;
                 initParameters.initLength/2-initParameters.aluminumThickness,initParameters.initWidth/2,initParameters.aluminumThickness;
                 initParameters.initLength/2,initParameters.initWidth/2,initParameters.aluminumThickness;
                 initParameters.initLength/2,-initParameters.initWidth/2,initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.initHeight-2*initParameters.aluminumThickness;

structures(4).Name = 'East Face Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = 'Aluminum';
structures(4).Mass = []; % This will be density times volume
structures(4).Dim = [initParameters.initHeight-initParameters.aluminumThickness,initParameters.aluminumThickness,initParameters.initLength]; % use the initial paramaters.
structures(4).CG_XYZ = [initParameters.initLength/2-initParameters.aluminumThickness/2,0,(initParameters.initHeight-initParameters.aluminumThickness)/2+initParameters.aluminumThickness];
structures(4).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(4).Top_Vertices = topVert;
structures(4).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(4).Surface(1).Mountable = 'N/A';
structures(4).Surface(1).buildableDir = 'YZ';
structures(4).Surface(1).normalFace = '+X';
structures(4).Surface(1).availableX = [initParameters.initLength/2,inf];
structures(4).Surface(1).availableY = [-initParameters.initWidth/2,initParameters.initWidth/2];
structures(4).Surface(1).availableZ = [0,initParameters.initHeight];


%% 5, West Face Panel (normal to -X)
bottomVert = [-(initParameters.initLength/2-initParameters.aluminumThickness),-initParameters.initWidth/2,initParameters.aluminumThickness;
                 -(initParameters.initLength/2-initParameters.aluminumThickness),initParameters.initWidth/2,initParameters.aluminumThickness;
                 -initParameters.initLength/2,initParameters.initWidth/2,initParameters.aluminumThickness;
                 -initParameters.initLength/2,-initParameters.initWidth/2,initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.initHeight-2*initParameters.aluminumThickness;

structures(5).Name = 'West Face Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = 'Aluminum';
structures(5).Mass = []; % This will be density times volume
structures(5).Dim = [initParameters.initHeight-initParameters.aluminumThickness,initParameters.aluminumThickness,initParameters.initLength]; % use the initial paramaters.
structures(5).CG_XYZ = [-initParameters.initLength/2+initParameters.aluminumThickness/2,0,(initParameters.initHeight-initParameters.aluminumThickness)/2+initParameters.aluminumThickness];
structures(5).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(5).Top_Vertices = topVert;
structures(5).Plane = 'YZ';

% Outside Surface to mount parts on <- Check out the z face start
structures(5).Surface(1).Mountable = 'N/A';
structures(5).Surface(1).buildableDir = 'YZ';
structures(5).Surface(1).normalFace = '-X';
structures(5).Surface(1).availableX = [-initParameters.initLength/2,-inf];
structures(5).Surface(1).availableY = [initParameters.initWidth/2,-initParameters.initWidth/2];
structures(5).Surface(1).availableZ = [0,initParameters.initHeight];


%% 6, Top Panel (normal to +Z)
bottomVert = [initParameters.initLength/2,initParameters.initWidth/2,initParameters.initHeight-initParameters.aluminumThickness;
                 -initParameters.initLength/2,initParameters.initWidth/2,initParameters.initHeight-initParameters.aluminumThickness;
                 -initParameters.initLength/2,-initParameters.initWidth/2,initParameters.initHeight-initParameters.aluminumThickness;
                 initParameters.initLength/2,-initParameters.initWidth/2,initParameters.initHeight-initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.aluminumThickness;

structures(6).Name = 'Top Panel';
structures(6).Shape = 'Rectangle';
structures(6).Material = 'Aluminum';
structures(6).Mass = []; % This will be density times volume
structures(6).Dim = [initParameters.aluminumThickness,initParameters.initWidth,initParameters.initLength]; % use the initial paramaters.
structures(6).CG_XYZ = [0,0,initParameters.initHeight-initParameters.aluminumThickness/2]; % Make the origin at the base of the bottom panel.
structures(6).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(6).Top_Vertices = topVert;
structures(6).Plane = 'XY';

% Outside Surface to mount parts on
structures(6).Surface(1).Mountable = 'N/A';
structures(6).Surface(1).buildableDir = 'XY';
structures(6).Surface(1).normalFace = '+Z';
structures(6).Surface(1).availableX = -[-initParameters.initLength/2,initParameters.initLength/2]; % This needs to be in the negative direciton, as if the x direction is facing you and you're mounting into the page
structures(6).Surface(1).availableY = [-initParameters.initWidth/2,initParameters.initWidth/2]; 
structures(6).Surface(1).availableZ = [initParameters.initHeight,+inf];
 
%% 7, Inside Mounting Panel (normal to +Z)
bottomVert = [initParameters.initLength/2-initParameters.aluminumThickness,initParameters.initWidth/2-initParameters.aluminumThickness,initParameters.aluminumThickness;
                 -initParameters.initLength/2+initParameters.aluminumThickness,initParameters.initWidth/2-initParameters.aluminumThickness,initParameters.aluminumThickness;
                 -initParameters.initLength/2+initParameters.aluminumThickness,-initParameters.initWidth/2+initParameters.aluminumThickness,initParameters.aluminumThickness;
                 initParameters.initLength/2-initParameters.aluminumThickness,-initParameters.initWidth/2+initParameters.aluminumThickness,initParameters.aluminumThickness];

topVert = bottomVert;
topVert(:,3) = topVert(:,3)+initParameters.aluminumThickness;

structures(7).Name = 'Inside Mounting Panel';
structures(7).Shape = 'Rectangle';
structures(7).Material = 'Aluminum';
structures(7).Mass = []; % This will be density times volume
structures(7).Dim = [initParameters.aluminumThickness,initParameters.initWidth,initParameters.initLength]; % use the initial paramaters.
structures(7).CG_XYZ = [0,0,initParameters.aluminumThickness*1.5];
structures(7).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(7).Top_Vertices = topVert;
structures(7).Plane = 'XY';

% Inside Surface to mount parts on
structures(7).Surface(1).Mountable = 'N/A';
structures(7).Surface(1).buildableDir = 'XY';
structures(7).Surface(1).normalFace = '+Z';
structures(7).Surface(1).availableX = -[-initParameters.initLength/2+initParameters.aluminumThickness,initParameters.initLength/2-initParameters.aluminumThickness];
structures(7).Surface(1).availableY = [-initParameters.initWidth/2+initParameters.aluminumThickness,initParameters.initWidth/2-initParameters.aluminumThickness];
structures(7).Surface(1).availableZ = [2*initParameters.aluminumThickness,initParameters.initHeight-initParameters.aluminumThickness];


function [structures] = CylinderStructure(initParameters,ratios)
%%
% A function that creates the structure for a central cylinder-based
% structure.
shearWidth = ratios.shear_cylinder*initParameters.cylinderDiam;
panelWidth = ratios.panel_cylinder*initParameters.cylinderDiam;

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
structures(1).Dim = [initParameters.initHeight-2*initParameters.honeycombThickness,initParameters.cylinderDiam/2,initParameters.carbonfiberThickness]; % use the initial paramaters.
structures(1).CG_XYZ = [0,0,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(1).Bottom_Vertices = [0,0,initParameters.honeycombThickness]; % For a cylinder the Vertices are just the bottom center point.
structures(1).Top_Vertices = [0,0,initParameters.initHeight-2*initParameters.honeycombThickness];
structures(1).Plane = 'Z';

% Place fuel tanks inside the central cylinder
structures(1).Surface(1).Mountable = 'Fuel Tank';
structures(1).Surface(1).buildableDir = '+Z';
structures(1).Surface(1).normalFace = '+Z';
structures(1).Surface(1).availableX = [-initParameters.cylinderDiam/2,initParameters.cylinderDiam/2];
structures(1).Surface(1).availableY = [-initParameters.cylinderDiam/2,initParameters.cylinderDiam/2];
structures(1).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];


%% 2, create the North shear panels along the y axis
bottomVert = [initParameters.honeycombThickness/2,initParameters.cylinderDiam/2,initParameters.honeycombThickness;
                 -initParameters.honeycombThickness/2,initParameters.cylinderDiam/2,initParameters.honeycombThickness;
                 -initParameters.honeycombThickness/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness;
                 initParameters.honeycombThickness/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness];
    
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness;

structures(2).Name = 'North Shear Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = 'Honeycomb';
structures(2).Dim = [initParameters.initHeight-2*initParameters.honeycombThickness,shearWidth,initParameters.honeycombThickness];
structures(2).CG_XYZ = [0,initParameters.cylinderDiam/2+shearWidth/2,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(2).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(2).Top_Vertices = topVert;
structures(2).Plane = 'YZ';

% North Shear Panel Face 1
structures(2).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(2).Surface(1).normalFace = '+X';
structures(2).Surface(1).buildableDir = 'YZ';
structures(2).Surface(1).Location = 'Inside';
structures(2).Surface(1).availableX = [initParameters.honeycombThickness/2,inf];
structures(2).Surface(1).availableY = [initParameters.cylinderDiam/2,initParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% North Shear Panel Face 2
structures(2).Surface(2).normalFace = '-X';
structures(2).Surface(2).buildableDir = 'YZ';
structures(2).Surface(2).Location = 'Inside';
structures(2).Surface(2).availableX = [-initParameters.honeycombThickness/2,-inf];
structures(2).Surface(2).availableY = [initParameters.cylinderDiam/2,initParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];


%% 3, create the South shear panels along the y axis

bottomVert = [initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2,initParameters.honeycombThickness;
                 -initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2,initParameters.honeycombThickness;
                 -initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness];
    
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness;

structures(3).Name = 'South Shear Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = 'Honeycomb';
structures(3).Dim = [initParameters.initHeight-2*initParameters.honeycombThickness,shearWidth,initParameters.honeycombThickness];
structures(3).CG_XYZ = [0,-initParameters.cylinderDiam/2-shearWidth/2,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(3).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(3).Top_Vertices = topVert;
structures(3).Plane = 'YZ';

% South Shear Panel Face 1
structures(3).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(1).normalFace = '-X';
structures(3).Surface(1).buildableDir = 'YZ';
structures(3).Surface(1).Location = 'Inside';
structures(3).Surface(1).availableX = [-initParameters.honeycombThickness/2,-inf];
structures(3).Surface(1).availableY = [-initParameters.cylinderDiam/2,-initParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% South Shear Panel Face 2
structures(3).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(2).normalFace = '+X';
structures(3).Surface(2).buildableDir = 'YZ';
structures(3).Surface(2).Location = 'Inside';
structures(3).Surface(2).availableX = [initParameters.honeycombThickness/2,inf];
structures(3).Surface(2).availableY = [-initParameters.cylinderDiam/2,-initParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

%% 4, North panel
bottomVert = [panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,initParameters.honeycombThickness;
                  panelWidth/2,initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,initParameters.honeycombThickness];

topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness;                        


structures(4).Name = 'North Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = 'Honeycomb';
structures(4).Dim = [initParameters.initHeight-2*initParameters.honeycombThickness,initParameters.honeycombThickness,panelWidth];
structures(4).CG_XYZ = [0,shearWidth+initParameters.honeycombThickness/2,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(4).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(4).Top_Vertices = topVert;
structures(4).Plane = 'XZ';

% North Panel Face 1
structures(4).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(1).normalFace = '-Y';
structures(4).Surface(1).buildableDir = 'XZ';
structures(4).Surface(1).Location = 'Inside';
structures(4).Surface(1).availableX = [initParameters.honeycombThickness/2,panelWidth/2];
structures(4).Surface(1).availableY = [initParameters.cylinderDiam/2+shearWidth,initParameters.cylinderDiam/2];
structures(4).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% North Panel Face 2
structures(4).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(2).normalFace = '-Y';
structures(4).Surface(2).buildableDir = 'XZ';
structures(4).Surface(2).Location = 'Inside';
structures(4).Surface(2).availableX = [-initParameters.honeycombThickness/2,-panelWidth/2];
structures(4).Surface(2).availableY = [initParameters.cylinderDiam/2+shearWidth,initParameters.cylinderDiam/2];
structures(4).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% North Panel Outside Face
structures(4).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(4).Surface(3).normalFace = '+Y';
structures(4).Surface(3).buildableDir = 'XZ';
structures(4).Surface(3).Location = 'Outside';
structures(4).Surface(3).availableX = [-panelWidth/2,panelWidth/2];
structures(4).Surface(3).availableY = [initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,inf];
structures(4).Surface(3).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];


%% 5, South panel
bottomVert = [panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2,-initParameters.cylinderDiam/2-shearWidth-initParameters.honeycombThickness,initParameters.honeycombThickness;
                 panelWidth/2,-initParameters.cylinderDiam/2-shearWidth-initParameters.honeycombThickness,initParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness; 


structures(5).Name = 'South Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = 'Honeycomb';
structures(5).Dim = [initParameters.initHeight-2*initParameters.honeycombThickness,initParameters.honeycombThickness,panelWidth];
structures(5).CG_XYZ = [0,-shearWidth-initParameters.honeycombThickness/2,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(5).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(5).Top_Vertices = topVert;
structures(5).Plane = 'XZ';

% South Panel Face 1
structures(5).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(1).normalFace = '+Y';
structures(5).Surface(1).buildableDir = 'XZ';
structures(5).Surface(1).Location = 'Inside';
structures(5).Surface(1).availableX = [-initParameters.honeycombThickness/2,-panelWidth/2];
structures(5).Surface(1).availableY = [-(initParameters.cylinderDiam/2+shearWidth),-initParameters.cylinderDiam/2];
structures(5).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% South Panel Face 2
structures(5).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(2).normalFace = '+Y';
structures(5).Surface(2).buildableDir = 'XZ';
structures(5).Surface(2).Location = 'Inside';
structures(5).Surface(2).availableX = [initParameters.honeycombThickness/2,panelWidth/2];
structures(5).Surface(2).availableY = [-(initParameters.cylinderDiam/2+shearWidth),-initParameters.cylinderDiam/2];
structures(5).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% South Panel Outside Face
structures(5).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(3).normalFace = '-Y';
structures(5).Surface(3).buildableDir = 'XZ';
structures(5).Surface(3).Location = 'Outside';
structures(5).Surface(3).availableX = [panelWidth/2,-panelWidth/2];
structures(5).Surface(3).availableY = [-(initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness),-inf];
structures(5).Surface(3).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

%% 6, East panel
bottomVert = [panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 panelWidth/2-initParameters.honeycombThickness,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 panelWidth/2-initParameters.honeycombThickness,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness;
                 panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness; 

structures(6).Name = 'East Panel';
structures(6).Shape = 'Rectangle';
structures(6).Material = 'Honeycomb';
structures(6).Dim = [initParameters.initHeight,panelWidth,initParameters.honeycombThickness];
structures(6).CG_XYZ = [panelWidth/2-initParameters.honeycombThickness/2,0,(initParameters.initHeight-2*initParameters.honeycombThickness)/2+initParameters.honeycombThickness];
structures(6).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(6).Top_Vertices = topVert;
structures(6).Plane = 'YZ';

% East Panel Inside Face
structures(6).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(6).Surface(1).normalFace = '-X';
structures(6).Surface(1).buildableDir = 'YZ';
structures(6).Surface(1).Location = 'Inside';
structures(6).Surface(1).availableX = -[panelWidth/2-initParameters.honeycombThickness/2,initParameters.cylinderDiam/2];
structures(6).Surface(1).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth];
structures(6).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% East Panel Outside Face
structures(6).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(6).Surface(2).normalFace = '+X';
structures(6).Surface(2).buildableDir = 'YZ';
structures(6).Surface(2).Location = 'Outside';
structures(6).Surface(2).availableX = [panelWidth/2,inf];
structures(6).Surface(2).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth];
structures(6).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

%% 7, West panel
bottomVert = [-panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2+initParameters.honeycombThickness,-initParameters.cylinderDiam/2-shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2+initParameters.honeycombThickness,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight - 2*initParameters.honeycombThickness; 

structures(7).Name = 'West Panel';
structures(7).Shape = 'Rectangle';
structures(7).Material = 'Honeycomb';
structures(7).Dim = [initParameters.initHeight,panelWidth,initParameters.honeycombThickness];
structures(7).CG_XYZ = [-panelWidth/2+initParameters.honeycombThickness/2,0,initParameters.initHeight/2];
structures(7).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(7).Top_Vertices = topVert;
structures(7).Plane = 'YZ';

% West Panel Inside Face
structures(7).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(7).Surface(1).normalFace = '+X';
structures(7).Surface(1).buildableDir = 'YZ';
structures(7).Surface(1).Location = 'Inside';
structures(7).Surface(1).availableX = [-panelWidth/2+initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2];
structures(7).Surface(1).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth-initParameters.honeycombThickness];
structures(7).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

% West Panel Outside Face
structures(7).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(7).Surface(2).normalFace = '-X';
structures(7).Surface(2).buildableDir = 'YZ';
structures(7).Surface(2).Location = 'Outside';
structures(7).Surface(2).availableX = [-panelWidth/2,-inf];
structures(7).Surface(2).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth];
structures(7).Surface(2).availableZ = [initParameters.honeycombThickness,initParameters.initHeight-initParameters.honeycombThickness];

%% 8, Bottom panel
bottomVert = [-panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,0;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth,0;
                 panelWidth/2,initParameters.cylinderDiam/2+shearWidth,0;
                 panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,0];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.honeycombThickness; 

structures(8).Name = 'Bottom Panel';
structures(8).Shape = 'Rectangle';
structures(8).Material = 'Honeycomb';
structures(8).Dim = [initParameters.honeycombThickness,initParameters.cylinderDiam+shearWidth*2+initParameters.honeycombThickness*2,panelWidth];
structures(8).CG_XYZ = [0,0,initParameters.honeycombThickness/2];
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
structures(8).Surface(1).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth];
structures(8).Surface(1).availableZ = [initParameters.honeycombThickness,initParameters.initHeight];

%% 9, Top panel
bottomVert = [-panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.initHeight-initParameters.honeycombThickness;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.initHeight-initParameters.honeycombThickness;
                 panelWidth/2,initParameters.cylinderDiam/2+shearWidth,initParameters.initHeight-initParameters.honeycombThickness;
                 panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,initParameters.initHeight-initParameters.honeycombThickness];
             
topVert = bottomVert;
topVert(:,3) = bottomVert(:,3) + initParameters.initHeight; 

structures(9).Name = 'Bottom Panel';
structures(9).Shape = 'Rectangle';
structures(9).Material = 'Honeycomb';
structures(9).Dim = [initParameters.honeycombThickness,initParameters.cylinderDiam+shearWidth*2+initParameters.honeycombThickness*2,panelWidth];
structures(9).CG_XYZ = [0,0,initParameters.initHeight+initParameters.honeycombThickness/2];
structures(9).Bottom_Vertices = bottomVert; % For a cylinder the Vertices are just the bottom center point.
structures(9).Top_Vertices = topVert;
structures(8).Plane = 'XY';

% 
% Bottom Panel Inside Face
structures(9).Surface(1).Mountable = 'Payload'; % Don't need any specifics
structures(9).Surface(1).normalFace = '+Z';
structures(9).Surface(1).buildableDir = '+Z';
structures(9).Surface(1).availableX = [-panelWidth/2,+panelWidth/2];
structures(9).Surface(1).availableY = [-initParameters.cylinderDiam/2-shearWidth,initParameters.cylinderDiam/2+shearWidth];
structures(9).Surface(1).availableZ = [initParameters.initHeight,inf];
% 
% % West Panel Outside Face
% structures(6).Surface(1).Mountable = 'N/A'; % Don't need any specifics
% structures(6).Surface(1).normalFace = '-X';
% structures(6).Surface(1).buildableDir = 'YZ';
% structures(6).Surface(1).Location = 'Outside';
% structures(6).Surface(1).availableX = [-panelWidth/2,-inf];
% structures(6).Surface(1).availableY = [-initParameters.cylinderDiam/2-shearWidth+initParameters.honeycombThickness,initParameters.cylinderDiam/2+shearWidth-initParameters.honeycombThickness];
% structures(6).Surface(1).availableZ = [0,initParameters.initHeight];
 

function structuresIndices = OrderedSurfaces(structureType)
% This allows someone to decide what surfaces to mount on first for inside
% vs outside surfaces. This gives the order that instruments should be
% placed on the satellite in the order of: [index of structure, index of surface on that structure]

if strcmp(structureType,'Central Cylinder')
    structuresIndices.Inside = [2,1;
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
    structuresIndices.Outside = [4,3;
                                5,3;
                                6,2;
                                7,2];
    structuresIndices.Specific(1).Name = 'Payload';
    structuresIndices.Specific(1).Index = [9,1];
    structuresIndices.Specific(2).Name = 'Fuel Tank';
    structuresIndices.Specific(2).Index = [1,1];
    structuresIndices.Specific(3).Name = 'Thruster';
    structuresIndices.Specific(3).Index = [1,1];
elseif strcmp(structureType,'Stacked')
    structuresIndices.Inside = [7,1]; 
    structuresIndices.Outside = [3,1];
%     structuresIndices.Outside = [2,1;
%                                 3,1;
%                                 4,1;
%                                 5,1;
%                                 6,1;
%                                 1,1];
    structuresIndices.Specific(1).Name = 'Payload';
    structuresIndices.Specific(1).Index = [6,1];
end
% Idk about this idea, but could be possible.

