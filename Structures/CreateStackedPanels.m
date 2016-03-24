function [components,structures] = CreateStackedPanels(height,components,structures,genParameters)
% Create a new panel to mount components on with its bottom created on the given
% height.

bottomVert = [genParameters.initLength/2-genParameters.aluminumThickness,genParameters.initWidth/2-genParameters.aluminumThickness,height;
                 -genParameters.initLength/2+genParameters.aluminumThickness,genParameters.initWidth/2-genParameters.aluminumThickness,height;
                 -genParameters.initLength/2+genParameters.aluminumThickness,-genParameters.initWidth/2+genParameters.aluminumThickness,height;
                 genParameters.initLength/2-genParameters.aluminumThickness,-genParameters.initWidth/2+genParameters.aluminumThickness,height];

topVert = bottomVert;
topVert(:,3) = genParameters.aluminumThickness+height;

% Get the next index for the new mounting panel
n = length(structures)+1;

structures(n).Name = 'Inside Mounting Panel';
structures(n).Shape = 'Rectangle';
structures(n).Material = 'Aluminum';
structures(n).Mass = []; % This will be density times volume
structures(n).Dim = [genParameters.aluminumThickness,genParameters.initWidth,genParameters.initLength]; % use the initial paramaters.
structures(n).CG_XYZ = [0,0,genParameters.aluminumThickness*.5+height];
structures(n).Bottom_Vertices = bottomVert; % The Vertices are the bottom of the satellite.
structures(n).Top_Vertices = topVert;
structures(4).Plane = 'XY';

% Inside Surface to mount parts on
structures(n).Surface(1).Mountable = 'N/A';
structures(n).Surface(1).buildableDir = 'XY';
structures(n).Surface(1).normalFace = '+Z';
structures(n).Surface(1).availableX = -[-genParameters.initLength/2+genParameters.aluminumThickness,genParameters.initLength/2-genParameters.aluminumThickness];
structures(n).Surface(1).availableY = [-genParameters.initWidth/2+genParameters.aluminumThickness,genParameters.initWidth/2-genParameters.aluminumThickness];
structures(n).Surface(1).availableZ = [height+genParameters.aluminumThickness,genParameters.initHeight];

for i = 1:length(components)
    components(i).structuresAssignment = [n,1];
end
genParameters.buildableIndices.Inside = [genParameters.buildableIndices.Inside; n,1];