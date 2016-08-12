function [inside_comp,payload,vol] = SortedInsideComponents(components)

% inside_comp = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
%     ,'RotateToSatBodyFrame',[],'Thermal',[],'InertiaMatrix',[],'Volume',[],'HeatPower',[]);


inside_comp = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[],'Dim'...
    ,[],'CG_XYZ',[],'Vertices',[],'LocationReq',[],'Orientation',[],'Thermal'...
    ,[],'InertiaMatrix',[],'RotateToSatBodyFrame', [],'HeatPower',[]);

vol = 0;
j = 1;
k = 1;
for i = 1:length(components)
    if strcmp(components(i).LocationReq,'Inside')
        inside_comp(j) = components(i);
        inside_mass(j) = components(i).Mass;
        if strcmp(inside_comp(j).Shape,'Cylinder')
            vol = vol + pi*(inside_comp(j).Dim(1)/2)^2*inside_comp(j).Dim(2);
        elseif strcmp(inside_comp(j).Shape,'Sphere')
            vol = vol + pi*(inside_comp.Dim(1)/2)^2;
        else
            vol = vol + inside_comp(j).Dim(1)*inside_comp(j).Dim(2)*inside_comp(j).Dim(3);
        end
        j = j+1;
    elseif strcmp(components(i).Name,'Payload')
        payload(k) = components(i);
        k = k+1;
    end
end

[~,sorted_i] = sort(inside_mass,'descend');
% new = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq','Specific'...
%     ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
for q = 1:length(inside_comp)
    new(q) = inside_comp(sorted_i(q));
end 
inside_comp = new;


end