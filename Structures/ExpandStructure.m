function [components,structures, genParameters] = ExpandStructure(components,structures,genParameters)
% Function that expands all the heights of the satellite to the highest height availabe
% for the component.

% Checks to see if this is a stacking satellite or otherwise
newHeight = max(genParameters.needExpand(:,2));
if strfind(genParameters.spacecraftType,'Cubesat')
    % If the newHeight to expand to is less than the current top height of
    % the spacecraft, just add another panel
    % Create more panels in which to pack the components on.
    if newHeight >= genParameters.initHeight
        % If the height is more than the current top height of the spacecraft,
        % expand the top height and then create a new panel.
        if genParameters.initWidth == .1 && genParameters.initLength == .1 && newHeight <= 0.3
            % If the satellite is a cubesat, expand the satellite up until 3u
            structureHeight = genParameters.initHeight + 0.1;
        else
            % Else just add an arbitrary height.
            structureHeight = newHeight + .1;
        end
        % Actually expand the structure
        structures = Expansion(structures,structureHeight,genParameters.initHeight);
        genParameters.initHeight = structureHeight;
    end
    % Create the panel 
    [components,structures] = CreateStackedPanels(newHeight,components,structures,genParameters);
elseif strfind(genParameters.spacecraftType,'Stacked')

else
    % Expand the structure for any structure that doesn't have mounting
    % panels
    if newHeight >= genParameters.initHeight
        structureHeight = newHeight;
        structures = Expansion(structures,structureHeight,genParameters.initHeight);
        genParameters.initHeight = structureHeight;
    end
end
genParameters(:,:).needExpand = 0;


function structures = Expansion(structures,newHeight,oldHeight)
% Expands all the structures to the current height
n1 = length(structures);
for i = 1:n1
    n2 = length(structures(i).Surface);
    if strcmp(structures(i).Surface(1).buildableDir,'XY')
    % If the components being expanded are racks or panels normal to Z,
    % don't change their dimensions, only change the location of the
    % component for the top panel.
        if  structures(i).Top_Vertices(:,3) == oldHeight
            thick = structures(i).Top_Vertices(1,3) - structures(i).Bottom_Vertices(1,3);
            structures(i).Bottom_Vertices(:,3) = newHeight;
            structures(i).Top_Vertices(:,3) = newHeight + thick;
            structures(i).CG_XYZ(3) = newHeight + thick/2;
        end
        if ~strcmp(structures(i).Surface(1).Mountable,'Payload')
            structures(i).Surface(1).availableZ(2) = newHeight;
        elseif strcmp(structures(1).Surface(1).Mountable,'Payload')
            structures(i).Surface(1).availableZ(1) = newHeight+thick;
        end
    else
    % Include something about height - thickness or something like that.
        structures(i).Top_Vertices(:,3) = newHeight;
        if strcmp(structures(i).Shape,'Rectangle') || ~isempty(strfind(structures(i).Shape,'Cylinder'))
        % Expand certain shapes in certain ways
            structures(i).Dim(1) = newHeight;
        end
        structures(i).CG_XYZ(3) = newHeight/2;
        for j = 1:n2
            if ~strcmp(structures(i).Surface(j).Mountable,'Payload')
                structures(i).Surface(j).availableZ(2) = newHeight;
            elseif strcmp(structures(i).Surface(j).Mountable,'Payload')
                structures(i).Surface(j).availableZ(1) = newHeight;
            end
        end
    end
end
