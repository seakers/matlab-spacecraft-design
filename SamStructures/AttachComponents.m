function [stowed_comp, deploy_comp] = AttachComponents(components,structures,dim)
% After building the structure frame and filling it with the inside
% components, add the outside components such as solar panels, sensors,
% radiators, etc.

L = dim(1);
W = dim(2);
H = dim(3);

% outside_comp = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
%     ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'Volume',[]);

j = 1;
for i = 1:length(components)
    if strcmp(components(i).LocationReq,'Outside') || strcmp(components(i).LocationReq,'Specific') 
        outside_comp(j) = components(i);
%         outside_comp(j).Name = components(i).Name;
%         outside_comp(j).Mass = components(i).Mass;
%         outside_comp(j).Volume = components(i).Dim(1)*components(i).Dim(2)*components(i).Dim(3);
%         outside_comp(j).Dim = components(i).Dim;
       j = j+1;
    end
end

s = 1;
p = 1;
for k = 1:length(outside_comp)
    if strcmp(outside_comp(k).Name,'Solar Panel')
        if s ==1
            [solar_stowed, solar_deploy] = AttachSolarPanels(outside_comp(k)...
                ,structures.structures(s+3),dim,s);
            s = s+1;
        else
            [solar_stowed2, solar_deploy2] = AttachSolarPanels(outside_comp(k)...
                ,structures.structures(s+3),dim,s);
        end
    elseif strcmp(outside_comp(k).Name,'Payload')
        payload_comp(p) = AttachPayload(outside_comp(k),dim,p);
        p = p+1;
    elseif strcmp(outside_comp(k).Name,'Antenna')
        antenna = AttachAntenna(outside_comp(k),dim);
%    elseif strcmp(stowed_comp(k).... what else? sun sensor, maybe star
%    sensor... and then payload yes radiator?
    end
end

stowed_comp = [solar_stowed solar_stowed2 payload_comp antenna];
deploy_comp = [solar_deploy solar_deploy2 payload_comp antenna];


end