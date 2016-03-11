function [structures, genParameters] = ExpandStructure(structures, genParameters)
% Function that expands all the heights of the satellite to the highest height availabe
% for the component.

newHeight = max(genParameters.needExpand(:,2));

n1 = length(structures);
for i = 1:n1
    n2 = length(structures(i).Surface);
    structures(i).Top_Vertices(:,3) = newHeight;
    if strcmp(structures(i).Shape,'Rectangle') || ~isempty(strfind(structures(i).Shape,'Cylinder'))
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
genParameters.initHeight = newHeight;
genParameters.needExpand = zeros(n1,2);

