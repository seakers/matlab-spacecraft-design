function LV = LV_selection(payload,structures)

LVData = GetLVData();
n1 = length(LVData);
index = [];
% See which launch vehicles fit the satellite
for i = 1:n1
    if structures.width < LVData(i).diameter && structures.height < LVData(i).height
        index = [index,i];
    end
end

% Select only the launch vehicles that fit
LVData = LVData(index);

% Sort from cheapest to most expensive
[~, ind]=sort([LVData.cost]);
LVData=LVData(ind);

% See if the cheapest will be able to take the satellite there or not. If
% not, keep cycling to the next one.
n1 = length(LVData);
index = strfind(fieldnames(LVData),payload.Orbit);

i = 1;
keepGoing = 1;
while i <= n1 && keepGoing
%     index = ismember(structuresAssignment,[i,j],'rows');
    n2 = size(index,1);
    j = 1;
    while j <= n2 && keepGoing
        if ~isempty(index{j})
            LV_orbit = struct2cell(LVData(j));
            LV_orbit = LV_orbit{j};
            if CanReachOrbit(payload,LV_orbit)
                keepGoing = 0;
                LV = LVData(i);
            end
        end
        j = j + 1;
    end
end
if keepGoing 
    fprintf('The Payload does not fit in any of the specified locations\n')
end

function yn = CanReachOrbit(payload_orbit,LV_orbit)
    
    if payload_orbit.h <= LV_orbit(1)
        yn = 1;
    else 
        yn = 0;
    end
%     
    

% See which LVs will reach the orbit required.
