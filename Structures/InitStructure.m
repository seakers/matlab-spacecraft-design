function [structures,buildableIndices,generalParameters] = InitStructure(componentSize,structureType)


if strcmp(structureType,'Central Cylinder')
    % the component is the tank
    % Aspect ratios used for the satellite.
    generalParameters.cylinderDiam = componentSize;
    generalParameters.initHeight = 1;
    generalParameters.tolerance = 0.025; % tolerance for space between components.
    ratios.shear_cylinder = 0.3;
    ratios.panel_cylinder = 1.2;
    generalParameters.honeycombThickness = .02;
    generalParameters.carbonfiberThickness = .03;
    
    [structures] = CylinderStructure(generalParameters,ratios);  
    buildableIndices = OrderedSurfaces(structureType);
elseif strcmp(structureType,'Stacked')
    % Create a stacked satellite
    generalParameters.tolerance = 0.01; % tolerance for space between components.
    generalParameters.aluminumThickness = .002; % Initial thickness of aluminum
    generalParameters.carbonfiberThickness = .03; % Initial thickness of carbon fiber
    generalParameters.initWidth = .1; % Initial Length
    generalParameters.initLength = .1; % Initial Width
    generalParameters.initHeight = .1; % Initial Height
    
    structures = StackedStructure(generalParameters);
    buildableIndices = OrderedSurfaces(structureType);
end

function structures = StackedStructure(initParameters)
% You will have a structure inside the structure. The main structure tells
% details about the actual shape and object, while the second structure
% tells about the surfaces available to mount components on for the
% structure.

%% 1, Bottom Panel (Normal to -Z)
bottomVert = [initParameters.initLength/2,initParameters.initWidth/2,0;
                 -initParameters.initLength/2,initParameters.initWidth/2,0;
                 -initParameters.initLength/2,-initParameters.initWidth/2,0;
                 initParameters.initLength/2,-initParameters.initWidth/2,0];

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

% Outside Surface to mount parts on <- Check out the z face start
structures(2).Surface(1).Mountable = 'N/A';
structures(2).Surface(1).buildableDir = 'XZ';
structures(2).Surface(1).normalFace = '+Y';
structures(2).Surface(1).availableX = [initParameters.initLength/2,-initParameters.initLength/2];
structures(2).Surface(1).availableY = [initParameters.initWidth/2,inf];
structures(2).Surface(1).availableZ = [initParameters.aluminumThickness,initParameters.initHeight-initParameters.aluminumThickness];

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

% Outside Surface to mount parts on <- Check out the z face start
structures(3).Surface(1).Mountable = 'N/A';
structures(3).Surface(1).buildableDir = 'XZ';
structures(3).Surface(1).normalFace = '-Y';
structures(3).Surface(1).availableX = [-initParameters.initLength/2,initParameters.initLength/2];
structures(3).Surface(1).availableY = [-initParameters.initWidth/2,-inf];
structures(3).Surface(1).availableZ = [initParameters.aluminumThickness,initParameters.initHeight-initParameters.aluminumThickness];


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

% Outside Surface to mount parts on <- Check out the z face start
structures(4).Surface(1).Mountable = 'N/A';
structures(4).Surface(1).buildableDir = 'YZ';
structures(4).Surface(1).normalFace = '+X';
structures(4).Surface(1).availableX = [initParameters.initLength/2,inf];
structures(4).Surface(1).availableY = [-initParameters.initWidth/2,initParameters.initWidth/2];
structures(4).Surface(1).availableZ = [initParameters.aluminumThickness,initParameters.initHeight-initParameters.aluminumThickness];


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

% Outside Surface to mount parts on <- Check out the z face start
structures(5).Surface(1).Mountable = 'N/A';
structures(5).Surface(1).buildableDir = 'YZ';
structures(5).Surface(1).normalFace = '-X';
structures(5).Surface(1).availableX = [-initParameters.initLength/2,-inf];
structures(5).Surface(1).availableY = [initParameters.initWidth/2,-initParameters.initWidth/2];
structures(5).Surface(1).availableZ = [initParameters.aluminumThickness,initParameters.initHeight-initParameters.aluminumThickness];


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

% Outside Surface to mount parts on
structures(6).Surface(1).Mountable = 'N/A';
structures(6).Surface(1).buildableDir = 'XY';
structures(6).Surface(1).normalFace = '+Z';
structures(6).Surface(1).availableX = [-initParameters.initLength/2,initParameters.initLength/2];
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

% Outside Surface to mount parts on
structures(7).Surface(1).Mountable = 'N/A';
structures(7).Surface(1).buildableDir = 'XY';
structures(7).Surface(1).normalFace = '+Z';
structures(7).Surface(1).availableX = [-initParameters.initLength/2+initParameters.aluminumThickness,initParameters.initLength/2-initParameters.aluminumThickness];
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
structures(1).Dim = [initParameters.initHeight,initParameters.cylinderDiam/2,initParameters.carbonfiberThickness]; % use the initial paramaters.
structures(1).CG_XYZ = [0,0,initParameters.initHeight/2];
structures(1).Bottom_Vertices = [0,0,0]; % For a cylinder the Vertices are just the bottom center point.
structures(1).Top_Vertices = [0,0,initParameters.initHeight];

% Place fuel tanks inside the central cylinder
structures(1).Surface(1).Mountable = 'Fuel Tank';
structures(1).Surface(1).buildableDir = '+Z';
structures(1).Surface(1).normalFace = '+Z';
structures(1).Surface(1).availableX = [-initParameters.cylinderDiam/2,initParameters.cylinderDiam/2];
structures(1).Surface(1).availableY = [-initParameters.cylinderDiam/2,initParameters.cylinderDiam/2];
structures(1).Surface(1).availableZ = [0,initParameters.initHeight];
 
% Surface to mount payload on
structures(1).Surface(2).Mountable = 'Payload';
structures(1).Surface(2).normalFace = '+Z';
structures(1).Surface(2).buildableDir = '+Z'; % Maybe fix this if you want to put multiple payloads
structures(1).Surface(2).availableX = [-panelWidth/2,panelWidth/2];
structures(1).Surface(2).availableY = [-(initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness),initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness];
structures(1).Surface(2).availableZ = [initParameters.initHeight,inf];


%% 2, create the North shear panels along the y axis
northShearBase = [initParameters.honeycombThickness/2,initParameters.cylinderDiam/2,0;
                 -initParameters.honeycombThickness/2,initParameters.cylinderDiam/2,0;
                 -initParameters.honeycombThickness/2,initParameters.cylinderDiam/2+shearWidth,0;
                 initParameters.honeycombThickness/2,initParameters.cylinderDiam/2+shearWidth,0];
    
northShearTop = northShearBase;
northShearTop(:,3) = initParameters.initHeight;

structures(2).Name = 'North Shear Panel';
structures(2).Shape = 'Rectangle';
structures(2).Material = 'Honeycomb';
structures(2).Dim = [initParameters.initHeight,shearWidth,initParameters.honeycombThickness];
structures(2).CG_XYZ = [0,initParameters.cylinderDiam/2+shearWidth/2,initParameters.initHeight/2];
structures(2).Bottom_Vertices = northShearBase; % For a cylinder the Vertices are just the bottom center point.
structures(2).Top_Vertices = northShearTop;

% North Shear Panel Face 1
structures(2).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(2).Surface(1).normalFace = '+X';
structures(2).Surface(1).buildableDir = 'YZ';
structures(2).Surface(1).Location = 'Inside';
structures(2).Surface(1).availableX = [initParameters.honeycombThickness/2,inf];
structures(2).Surface(1).availableY = [initParameters.cylinderDiam/2,initParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(1).availableZ = [0,initParameters.initHeight];

% North Shear Panel Face 2
structures(2).Surface(2).normalFace = '-X';
structures(2).Surface(2).buildableDir = 'YZ';
structures(2).Surface(2).Location = 'Inside';
structures(2).Surface(2).availableX = [-initParameters.honeycombThickness/2,-inf];
structures(2).Surface(2).availableY = [initParameters.cylinderDiam/2,initParameters.cylinderDiam/2+shearWidth];
structures(2).Surface(2).availableZ = [0,initParameters.initHeight];


%% 3, create the South shear panels along the y axis

southShearBase = [initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2,0;
                 -initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2,0;
                 -initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2-shearWidth,0;
                 initParameters.honeycombThickness/2,-initParameters.cylinderDiam/2-shearWidth,0];
    
southShearTop = southShearBase;
southShearTop(:,3) = initParameters.initHeight;

structures(3).Name = 'South Shear Panel';
structures(3).Shape = 'Rectangle';
structures(3).Material = 'Honeycomb';
structures(3).Dim = [initParameters.initHeight,shearWidth,initParameters.honeycombThickness];
structures(3).CG_XYZ = [0,-initParameters.cylinderDiam/2-shearWidth/2,initParameters.initHeight/2];
structures(3).Bottom_Vertices = southShearBase; % For a cylinder the Vertices are just the bottom center point.
structures(3).Top_Vertices = southShearTop;

% South Shear Panel Face 1
structures(3).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(1).normalFace = '-X';
structures(3).Surface(1).buildableDir = 'YZ';
structures(3).Surface(1).Location = 'Inside';
structures(3).Surface(1).availableX = [-initParameters.honeycombThickness/2,-inf];
structures(3).Surface(1).availableY = [-initParameters.cylinderDiam/2,-initParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(1).availableZ = [0,initParameters.initHeight];

% South Shear Panel Face 2
structures(3).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(3).Surface(2).normalFace = '+X';
structures(3).Surface(2).buildableDir = 'YZ';
structures(3).Surface(2).Location = 'Inside';
structures(3).Surface(2).availableX = [initParameters.honeycombThickness/2,inf];
structures(3).Surface(2).availableY = [-initParameters.cylinderDiam/2,-initParameters.cylinderDiam/2-shearWidth];
structures(3).Surface(2).availableZ = [0,initParameters.initHeight];

%% 4, North panel
northPanelBase = [panelWidth/2,initParameters.cylinderDiam/2+shearWidth,0;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth,0;
                 -panelWidth/2,initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,0;
                  panelWidth/2,initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,0];

northPanelTop = northPanelBase;
northPanelTop(:,3) = initParameters.initHeight;                       


structures(4).Name = 'North Panel';
structures(4).Shape = 'Rectangle';
structures(4).Material = 'Honeycomb';
structures(4).Dim = [initParameters.initHeight,initParameters.honeycombThickness,panelWidth];
structures(4).CG_XYZ = [0,shearWidth+initParameters.honeycombThickness/2,initParameters.initHeight/2];
structures(4).Bottom_Vertices = northPanelBase; % For a cylinder the Vertices are just the bottom center point.
structures(4).Top_Vertices = northPanelTop;

% North Panel Face 1
structures(4).Surface(1).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(1).normalFace = '-Y';
structures(4).Surface(1).buildableDir = 'XZ';
structures(4).Surface(1).Location = 'Inside';
structures(4).Surface(1).availableX = [initParameters.honeycombThickness/2,panelWidth/2];
structures(4).Surface(1).availableY = [initParameters.cylinderDiam/2+shearWidth,initParameters.cylinderDiam/2];
structures(4).Surface(1).availableZ = [0,initParameters.initHeight];

% North Panel Face 2
structures(4).Surface(2).Mountable = 'N/A'; % Don't need any specifics 
structures(4).Surface(2).normalFace = '-Y';
structures(4).Surface(2).buildableDir = 'XZ';
structures(4).Surface(2).Location = 'Inside';
structures(4).Surface(2).availableX = [-initParameters.honeycombThickness/2,-panelWidth/2];
structures(4).Surface(2).availableY = [initParameters.cylinderDiam/2+shearWidth,initParameters.cylinderDiam/2];
structures(4).Surface(2).availableZ = [0,initParameters.initHeight];

% North Panel Outside Face
structures(4).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(4).Surface(3).normalFace = '+Y';
structures(4).Surface(3).buildableDir = 'XZ';
structures(4).Surface(3).Location = 'Outside';
structures(4).Surface(3).availableX = [-panelWidth/2,panelWidth/2];
structures(4).Surface(3).availableY = [initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness,inf];
structures(4).Surface(3).availableZ = [0,initParameters.initHeight];


%% 5, South panel
southPanelBase = [panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,0;
                 -panelWidth/2,-initParameters.cylinderDiam/2-shearWidth,0;
                 -panelWidth/2,-initParameters.cylinderDiam/2-shearWidth-initParameters.honeycombThickness,0;
                 panelWidth/2,-initParameters.cylinderDiam/2-shearWidth-initParameters.honeycombThickness,0];
             
southPanelTop = southPanelBase;
southPanelTop(:,3) = initParameters.initHeight; 


structures(5).Name = 'South Panel';
structures(5).Shape = 'Rectangle';
structures(5).Material = 'Honeycomb';
structures(5).Dim = [initParameters.initHeight,initParameters.honeycombThickness,panelWidth];
structures(5).CG_XYZ = [0,-shearWidth-initParameters.honeycombThickness/2,initParameters.initHeight/2];
structures(5).Bottom_Vertices = southPanelBase; % For a cylinder the Vertices are just the bottom center point.
structures(5).Top_Vertices = southPanelTop;

% North Panel Face 1
structures(5).Surface(1).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(1).normalFace = '+Y';
structures(5).Surface(1).buildableDir = 'XZ';
structures(5).Surface(1).Location = 'Inside';
structures(5).Surface(1).availableX = [-initParameters.honeycombThickness/2,-panelWidth/2];
structures(5).Surface(1).availableY = [-(initParameters.cylinderDiam/2+shearWidth),-initParameters.cylinderDiam/2];
structures(5).Surface(1).availableZ = [0,initParameters.initHeight];

% North Panel Face 2
structures(5).Surface(2).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(2).normalFace = '+Y';
structures(5).Surface(2).buildableDir = 'XZ';
structures(5).Surface(2).Location = 'Inside';
structures(5).Surface(2).availableX = [initParameters.honeycombThickness/2,panelWidth/2];
structures(5).Surface(2).availableY = [-(initParameters.cylinderDiam/2+shearWidth),-initParameters.cylinderDiam/2];
structures(5).Surface(2).availableZ = [0,initParameters.initHeight];

% North Panel Outside Face
structures(5).Surface(3).Mountable = 'N/A'; % Don't need any specifics
structures(5).Surface(3).normalFace = '-Y';
structures(5).Surface(3).buildableDir = 'XZ';
structures(5).Surface(3).Location = 'Outside';
structures(5).Surface(3).availableX = [panelWidth/2,-panelWidth/2];
structures(5).Surface(3).availableY = [-(initParameters.cylinderDiam/2+shearWidth+initParameters.honeycombThickness),-inf];
structures(5).Surface(3).availableZ = [0,initParameters.initHeight];
    


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
                                5,2];
%     structuresIndices.Inside = [4,1];
%                                 2,1];
    structuresIndices.Outside = [4,3;
                                5,3];
    structuresIndices.Specific(1).Name = 'Payload';
    structuresIndices.Specific(1).Index = [1,2];
    structuresIndices.Specific(2).Name = 'Fuel Tank';
    structuresIndices.Specific(2).Index = [1,1];
    structuresIndices.Specific(3).Name = 'Thruster';
    structuresIndices.Specific(3).Index = [1,1];
elseif strcmp(structureType,'Stacked')
    structuresIndices.Inside = [2,1];                                
    structuresIndices.Outside = [2,1;
                                3,1;
                                4,1;
                                5,1;
                                6,1;
                                1,1];
    
end
% Idk about this idea, but could be possible.

