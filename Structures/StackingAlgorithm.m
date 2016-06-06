function [components,structures,needExpand,isFit] = StackingAlgorithm(components,structures,structuresIndices,genParameters)
%% A function that will stack the components assigned to a structure on top of each other along the structure's normal vector

n1 = length(components);
rollRotate = 0;
isFit = zeros(n1,1);

% Go through all the components and convert them to the same rectangular
% shape
for i = 1:n1
    % Calculate the XYZ center of gravity of the component 
    % If it's a rectangle, include the vertece
    
    if strcmp(components(i).Shape,'Rectangle')
        h = components(i).Dim(1);
        w = components(i).Dim(2);
        l = components(i).Dim(3);
        Dim = components(i).Dim; 
        [xyz,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand,isFit(i)] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
        % Check to make sure that the width, length, height stuff is
        % correct.
        xyzVertices = [-l/2 -w/2 -h/2; 
                -l/2 w/2 -h/2; 
                l/2 w/2 -h/2; 
                l/2 -w/2 -h/2; 
                -l/2 -w/2 h/2; 
                -l/2 w/2 h/2; 
                l/2 w/2 h/2; 
                l/2 -w/2 h/2];
            
        X = ones(8,1)*xyz(1);
        Y = ones(8,1)*xyz(2);
        Z = ones(8,1)*xyz(3);
        components(i).Vertices =  xyzVertices + [X,Y,Z];
        components(i).CG_XYZ = xyz;

    elseif strcmp(components(i).Shape,'Sphere')
    	r = components(i).Dim; 
        Dim = [2*r,2*r,2*r];
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand,isFit(i)] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    elseif strcmp(components(i).Shape,'Cylinder')
        h = components(i).Dim(1); 
        r = components(i).Dim(2); 
        Dim = [h,r*2,r*2];
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand,isFit(i)] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    elseif strcmp(components(i).Shape,'Cone')
        
        h = components(i).Dim(1);
        r1 = components(i).Dim(2); 
        r2 = components(i).Dim(2);
        if r1 > r2
            r = r1;
        else
            r = r2;
        end
        Dim = [h,r*2,r*2];
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand,isFit(i)] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    end
    
    % Get the rotation matrix for the component.
    components(i).RotateToSatBodyFrame = RotateFrameToAxes(structures(structuresIndices(1)).Surface(structuresIndices(2)).buildableDir,rollRotate);
end

function [xyz,structureSurface,needExpand,isFit] = StackComponent(Dim,structureSurface,genParameters)
% A function that stacks the given component in the space given to it. This
% reduces the amount of space available on the structures surface.
%   Inputs:
%       Dim                 The dimensions of the given component that has
%                           been transformed into a rectangle
%       structureSurface    the structure variable containing the surface
%                           of the structure 
%       genParameters       The general parameters of the satellite. Used
%                           for the tolerance necessary between components.
%
%   Outputs:
%       xyz                 An xyz coordinate of the CG of the component.
%       structureSurface    The updated structure surface with less space
%                           if the component was fitted.
%       needExpand          Tells if the satellite needs expansion or not.
%       isFit               Tells if the component was fitted or not.
%
%   Cornell University
%   Author Name: Anjit Fageria
%   Author NetID: agf46

xyz = zeros(1,3);
surfaceXYZ = zeros(3,2);
needExpand = [0,0,0,0];
isFit = 1;

h = Dim(1);
w = Dim(2);
l = Dim(3);
surfaceXYZ(1,:) = structureSurface.availableX;
surfaceXYZ(2,:) = structureSurface.availableY;
surfaceXYZ(3,:) = structureSurface.availableZ;

if sum(ismember(structureSurface.buildableDir,'Z'))
    %For expansion along the Z axis

    if strcmp(structureSurface.buildableDir,'+Z')
        xyz(3) = surfaceXYZ(3,1) + h/2;
        surfaceXYZ(3,1) = xyz(3) + h/2 + genParameters.tolerance;
    elseif strcmp(structureSurface.buildableDir,'-Z')
        xyz(3) = surfaceXYZ(3,1) - h/2;
        surfaceXYZ(3,1) = xyz(3) - h/2 - genParameters.tolerance; 
    end
    xyz(1) = (surfaceXYZ(1,1) + surfaceXYZ(1,2))/2;
    xyz(2) = (surfaceXYZ(2,1) + surfaceXYZ(2,2))/2;
    
%     if genParameter.initHeight < height
%         genParameter.initHeight = height;
%         expandHeight(genParameter.initHeight)
%     end
elseif sum(ismember(structureSurface.buildableDir,'Y'))

    
     if strcmp(structureSurface.buildableDir,'+Y')
        xyz(2) = surfaceXYZ(2,1) + w/2;
        surfaceXYZ(2,1) = xyz(2) + w/2 + genParameters.tolerance;
    elseif strcmp(structureSurface.buildableDir,'-Y')
        xyz(2) = surfaceXYZ(2,1) - w/2;
        surfaceXYZ(2,1) = xyz(2) - w/2 - genParameters.tolerance;
    end
    xyz(1) = (surfaceXYZ(1,1) + surfaceXYZ(1,2))/2;
    xyz(3) = (surfaceXYZ(3,1) + surfaceXYZ(3,2))/2;
    
elseif sum(ismember(structureSurface.buildableDir,'X'))
    
    if strcmp(structureSurface.buildableDir,'+X')
        xyz(1) = surfaceXYZ(1,1) + l/2;
        surfaceXYZ(1,1) = xyz(1) + l/2 + genParameters.tolerance;
    elseif strcmp(structureSurface.buildableDir,'-X')
        xyz(1) = surfaceXYZ(1,1) - l/2;
        surfaceXYZ(1,1) = xyz(1) - l/2 - genParameters.tolerance;
    end
    xyz(2) = (surfaceXYZ(2,1) + surfaceXYZ(2,2))/2;
    xyz(3) = (surfaceXYZ(3,1) + surfaceXYZ(3,2))/2;
end
structureSurface.availableX = surfaceXYZ(1,:);
structureSurface.availableY = surfaceXYZ(2,:);
structureSurface.availableZ = surfaceXYZ(3,:);

if abs(surfaceXYZ(3,1)) > abs(surfaceXYZ(3,2))
% If the height expanded to is more than the allotted given height, then
% expand the satellite and put the component as not fitted.
    needExpand = [1, surfaceXYZ(3,1),0,0];
    isFit = 0;
end


