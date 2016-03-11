function [components]= ComponentSort(components)
% Sorts the components by mass in descending order and sends the indices of
% how they should be sorted back.
sortedComponentIndices = MassSort(components);


function sortedComponentIndices = MassSort(components)
 %% sort mass
nr = length(components);

massList = zeros(nr,1);
for i = 1:nr
    massList(i) = components(i).Mass;
end

[~,sortedComponentIndices] = sort(massList,'descend');
components = components(sortedComponentIndices);

% ind = massListnew == massList;
