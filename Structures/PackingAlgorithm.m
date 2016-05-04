function [components,structures,needExpand,isFit] = PackingAlgorithm(components,structures,structuresIndices,genParameters)

% Function that packs the components on a panel.

% Convert the components from their shapes to rectangles in order to be
% compatible with the packing algorithm
[rectangleDim,rectangleMass] = ComponentConversionForPacking(components);

% Convert the structures so that they are initially in the 'YZ' plane to
% work with the packing algorithm
[panelWidth,panelHeight,panelLength] = StructuresConversionForPacking(structures(structuresIndices(1)).Surface(structuresIndices(2)));

% Use the limited Sleator Packing Algorithm.
% if strfind(genParameters.spacecraftType,'Stacked')
%     % If it is a spacecraft that uses a stacking type configuration, with
%     % components on shelfs inside, especially cubesats, then a limited
%     % packing algorithm that will restrict the panel size will be used.
%     
%     if strcmp(structures(structuresIndices(1)).Surface(structuresIndices(2)).buildableDir,'XY')
%     % If the panel is in the XY direction, then use the limited packing algorithm                
%         [rectangleCG,rectangleDim,needExpand,isFit] = SleatorPacking_Limited(rectangleDim,rectangleMass,genParameters.tolerance,abs(panelWidth(2)-panelWidth(1)),abs(panelLength(2)-panelLength(1)),panelHeight(2)-panelHeight(1));      
%     else
%     % If not, use the normal limitless algorithm.
%         [rectangleCG,rectangleDim,needExpand,isFit] = SleatorPacking_Limitless(rectangleDim,rectangleMass,genParameters.tolerance,abs(panelWidth(2)-panelWidth(1)),abs(panelLength(2)-panelLength(1)),panelHeight(2)-panelHeight(1));
%     end
% else 
%     % If it is a Cylinder or Panel Mounted, the design can expand in the Z
%     % direction until everything fits.
%     [rectangleCG,rectangleDim,needExpand,isFit] = SleatorPacking_Limitless(rectangleDim,rectangleMass,genParameters.tolerance,abs(panelWidth(2)-panelWidth(1)),abs(panelLength(2)-panelLength(1)),panelHeight(2)-panelHeight(1));
% end



[rectangleCG,rectangleDim,needExpand,isFit] = SleatorPacking_Limitless(rectangleDim,rectangleMass,genParameters.tolerance,abs(panelWidth(2)-panelWidth(1)),abs(panelLength(2)-panelLength(1)),panelHeight(2)-panelHeight(1));      



[rectangleCG,rotationMatrix,needExpand] = StructuresConversionFromAlgorithm(rectangleCG,structures(structuresIndices(1)).Surface(structuresIndices(2)),panelWidth,panelHeight,panelLength,needExpand);
% Convert from Algorithm Format to the original format by rotating the components around and converting back to the original shapes.         
components(isFit) = ComponentsConversionFromAlgorithm(rectangleCG,rectangleDim,components(isFit),rotationMatrix);


function [panelWidth,panelHeight,panelLength] = StructuresConversionForPacking(structures)
% A function to convert the panel structures to something more easily used
% for the mounting algorithm.

if strcmp(structures.buildableDir,'XZ')
    if strcmp(structures.normalFace,'+Y')
        panelWidth = -structures.availableX;
    else
        panelWidth = structures.availableX;
    end
    panelHeight = structures.availableZ;
    panelLength = structures.availableY;
elseif strcmp(structures.buildableDir,'YZ')
    panelWidth = structures.availableY;
    panelHeight = structures.availableZ;
    panelLength = structures.availableX;
elseif strcmp(structures.buildableDir,'XY')
    panelWidth = structures.availableX;
    panelHeight = structures.availableY;
    panelLength = structures.availableZ;
end



function [rectangleCG,rotationMatrix,needExpand] = StructuresConversionFromAlgorithm(rectangleCG,structures,panelWidth,panelHeight,panelLength,needExpand)
% Edit the CG to reflect the location of the panels. If it is on the YZ
% plane, then it should be fine, but then if it is along the XZ or XY
% plane, rotate the CG's of the components to reflect the new location.

rotationMatrix = RotateFrameToAxes(structures.normalFace,0);
% rotationMatrix = RotateFrameToAxes('-X',0);

% Flip the location depending on the components depending on the code.

% Check to see if the Y goes in the negative direction
% if ~isempty(strfind(structures.normalFace,'X')) % This doesn't stand for the Y axis.
if abs(panelWidth(2)) >= abs(panelWidth(1)) && panelWidth(2) < panelWidth(1)
    if ~strcmp(structures.normalFace,'+Z')
        % This is only necessary if the normal face isn't in the Z axis.
        rectangleCG(:,2) = -rectangleCG(:,2);
    end
end
% elseif ~isempty(strfind(structures.normalFace,'Y'))
%    if abs(panelWidth(2)) >= abs(panelWidth(1)) && panelWidth(2) > panelWidth(1)
%         rectangleCG(:,2) = -rectangleCG(:,2);
%     end
% end

% Check To see if the Z goes in the negative direction
if abs(panelHeight(2)) >= abs(panelHeight(1)) && panelHeight(2) < panelHeight(1)
    rectangleCG(:,3) = -rectangleCG(:,3);
end

% Check to see if the X goes in the negative direction
if abs(panelLength(2)) >= abs(panelLength(1)) && panelLength(2) < panelLength(1)
    if strcmp(structures.normalFace,'+Y') || strcmp(structures.normalFace,'-X')
        rectangleCG(:,1) = -rectangleCG(:,1);
    end
end
% Rotate the center of gravity of the locations
rectangleCG = (rotationMatrix*rectangleCG')';

% Add the center of gravities to the first places that a satellite can fit
% it on that panel
rectangleCG(:,1) = rectangleCG(:,1) + structures.availableX(1);
rectangleCG(:,2) = rectangleCG(:,2) + structures.availableY(1);
rectangleCG(:,3) = rectangleCG(:,3) + structures.availableZ(1);


if strcmp(structures.buildableDir,'XY')
    expandHeight = needExpand(4);
    expandWidth = needExpand(3);
    expandLength = needExpand(2);
elseif strcmp(structures.buildableDir,'XZ')
    expandHeight = needExpand(2);
    expandWidth = needExpand(4);
    expandLength = needExpand(3);
elseif strcmp(structures.buildableDir,'YZ')
    expandHeight = needExpand(2);
    expandWidth = needExpand(3);
    expandLength = needExpand(4);
else
    expandHeight = 0;
    expandWidth = 0;
    expandLength = 0;
end

needExpand(2) = expandHeight + structures.availableZ(1);
needExpand(3) = expandWidth;
needExpand(4) = expandLength;



function [rectangleDim,rectangleMass] = ComponentConversionForPacking(components)
% Converts allocated components into a format useable by the algorithm
% Assumes that the component will be mounted along it's 'zy' axis.

% rectangleDim = [h, w, l]
% rectangleMass = [m]

nr = length(components);
rectangleDim = zeros(nr,3);
rectangleMass = zeros(nr,1);
for i = 1:nr
    % If it is a sphere
    if strcmp(components(i).Shape,'Rectangle')
        h = components(i).Dim(1);
        w = components(i).Dim(2);
        l = components(i).Dim(3);
    elseif strcmp(components(i).Shape,'Sphere')
        r = components(i).Dim;
        h = 2*r;
        w = 2*r;
        l = 2*r;
    elseif strcmp(components(i).Shape,'Cone')
        h = components(i).Dim(1);
        r1 = components(i).Dim(2);
        r2 = components(i).Dim(3);
        if r1 > r2
            l = r1*2;
            w = r1*2;
        else
            l = r2*2;
            w = r2*2;
        end
    % If it is a cylinder
    elseif strcmp(components(i).Shape,'Cylinder')
        h = components(i).Dim(1);
        r = components(i).Dim(2);
        w = 2*r;
        l = 2*r;
    end
    rectangleDim(i,:) = [h,w,l];
    rectangleMass(i) = components(i).Mass;
end

function components = ComponentsConversionFromAlgorithm(rectangleCG,rectangleDim,components,rotationMatrix)
% Converts components already packed by the algorithm into a format
% readable by the rest of the code.

% if panelWidth(1) >= panelWidth(2) && abs(panelWidth(1)) <= abs(panelWidth(2))
%     if strcmp(structures.buildableDir,'YZ')
%         rectangleCG(:,2) = -rectangleCG(:,2);
%     elseif strcmp(structures.buildableDir,'XZ')
%         rectangleCG(:,1) = -rectangleCG(:,1);
%     elseif strcmp(structures.buildableDir,'XY')
%         rectangleCG(:,1) = -rectangleCG(:,1);
%     end
% end


n1 = size(rectangleCG,1);

for i = 1:n1
    components(i).RotateToSatBodyFrame = rotationMatrix;
    if strcmp(components(i).Shape,'Rectangle')
        h = rectangleDim(i,1);
        w = rectangleDim(i,2);
        l = rectangleDim(i,3);
        components(i).Dim = [h,w,l];
        components(i).CG_XYZ = (components(i).RotateToSatBodyFrame*rectangleCG(i,:)')';
        components(i).CG_XYZ = rectangleCG(i,:);
        xyzVertices = [-l/2 -w/2 -h/2; 
                    -l/2 w/2 -h/2; 
                    l/2 w/2 -h/2; 
                    l/2 -w/2 -h/2; 
                    -l/2 -w/2 h/2;
                    -l/2 w/2 h/2; 
                    l/2 w/2 h/2; 
                    l/2 -w/2 h/2];
        xyzVertices = (components(i).RotateToSatBodyFrame*xyzVertices')';
        
        X = ones(8,1)*components(i).CG_XYZ(1);
        Y = ones(8,1)*components(i).CG_XYZ(2);
        Z = ones(8,1)*components(i).CG_XYZ(3);
        components(i).Vertices =  xyzVertices + [X,Y,Z];
             
    elseif strcmp(components(i).Shape,'Sphere')
        r = h/2;
        components(i).Dim = r;
        components(i).CG_XYZ = (components(i).RotateToSatBodyFrame*rectangleCG(i,:)')';
    elseif strcmp(components(i).Shape,'Cone')
        components(i).CG_XYZ = (components(i).RotateToSatBodyFrame*rectangleCG(i,:)')';
    % If it is a cylinder
    elseif strcmp(components(i).Shape,'Cylinder')
        r1 = components(i).Dim(2);
        r2 = components(i).Dim(3);
        if r1 > r2
            l = r1*2;
            w = r1*2;
        else
            l = r2*2;
            w = r2*2;
        end
        % Need to find a way to record the height and the width here.
%         h = components(i).Dim(1);
%         r = components(i).Dim(2);
%         w = 2*r;
%         l = 2*r;
%         components(i).CG_XYZ = (components(i).RotateToSatBodyFrame*rectangleCG(i,:)')';
        components(i).CG_XYZ = rectangleCG(i,:);
    end
end


