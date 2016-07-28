function [inside_comp,payload] = SortedInsideComponents(components)

inside_comp = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
    ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
    ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'Volume',[]);

j = 1;
k = 1;
for i = 1:length(components)
    if strcmp(components(i).LocationReq,'Inside')
        if strcmp(components(i).Shape,'Cylinder')
            inside_comp(j) = components(i);
            inside_mass(j) = components(i).Mass;
            inside_comp(j).Shape = 'Rectangle';
            inside_comp(j).Volume = pi*components(i).Dim(1)^2*components(i).Dim(2);
            j = j+1;
        elseif strcmp(components(i).Shape,'Sphere')
            inside_comp(j) = components(i);
            inside_mass(j) = components(i).Mass;
            inside_comp(j).Shape = 'Rectangle';
            inside_comp(j).Volume = components(i).Dim(1)^2*pi;
            j = j+1;
        else
            inside_comp(j) = components(i);
            inside_mass(j) = components(i).Mass;
            inside_comp(j).Volume = components(i).Dim(1)*components(i).Dim(2)*components(i).Dim(3);
            j = j+1;
        end
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