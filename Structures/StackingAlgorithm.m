function [components,structures,needExpand] = StackingAlgorithm(components,structures,structuresIndices,genParameters)
%% A function that will stack the components assigned to it on top of each other along the vector of selection.

n1 = length(components);
rollRotate = 0;

for i = 1:n1
    % Calculate the XYZ center of gravity of the component 
    % If it's a rectangle, include the vertece
    
    if strcmp(components(i).Shape,'Rectangle')
        h = components(i).Dim(1);
        w = components(i).Dim(2);
        l = components(i).Dim(3);
        Dim = components(i).Dim; 
        [xyz,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
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
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    elseif strcmp(components(i).Shape,'Cylinder')
        h = components(i).Dim(1); 
        r = components(i).Dim(2); 
        Dim = [h,r*2,r*2];
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    elseif strcmp(components(i).Shape,'Cone')
        % Come back to this one.
        [components(i).CG_XYZ,structures(structuresIndices(1)).Surface(structuresIndices(2)),needExpand] = StackComponent(Dim,structures(structuresIndices(1)).Surface(structuresIndices(2)),genParameters);
    end
    
    components(i).RotateToSatBodyFrame = RotateFrameToAxes(structures(structuresIndices(1)).Surface(structuresIndices(2)).buildableDir,rollRotate);
end

function [xyz,structureSurface,needExpand] = StackComponent(Dim,structureSurface,genParameters)
% Input of the rectangle's dimensions and the available space for it's location
% isFit = 1;
xyz = zeros(1,3);
surfaceXYZ = zeros(3,2);
needExpand = [0,0];

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

if surfaceXYZ(3,1) > genParameters.initHeight
    needExpand = [1, surfaceXYZ(3,1)];
end



