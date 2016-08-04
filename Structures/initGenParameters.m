function [genParameters]= initGenParameters(components)
% Check the size of the largest component. If the largest component is less
% than 0.3 meters, use a cubesat configuration. If the largest size is
% greater than 0.3 meters, then look for the fuel tank in the list of
% components. Check the size of the tank to make sure it fits the size of
% central cylinders available. Central Cylinders are sized based on the
% size of the payload adapters. If the payload adapters are too small,
% compared to the fuel tank, or if there are more than 2 fuel tanks then
% you can use a panel mounted satellite . If the tanks are too small, then
% we can use a smaller panel mounted configuration. If the tanks are too
% large, then you can use a panel mounted configuration. If there are no
% fuel tanks use a stacked configuration.

tankDiam = 0;
nTanks = 0;
largestComponent = 0;

genParameters.aluminumThickness = .002; % Initial thickness of aluminum
genParameters.carbonfiberThickness = .03; % Initial thickness of carbon fiber
genParameters.honeycombThickness = .02; % Initial thickness of honeycomb panels
genParameters.carbonfiberThickness = .03; % Initial thickness of carbon fiber

% create an initial needExpand variable that has the first entry being that
% the structure needs to be expanded, and the next three entries being the
% height, width, and length that the satellite should be expanded to
genParameters.needExpand = zeros(10,4); 
% create an initial isFit variable that tells if each components are fitted in a location or not
genParameters.isFit = zeros(length(components),1); 

for i = 1:length(components)
% Cycle through all the components, there are different ways that
% the component can be very large in dimension to the satellite.
    if strfind(components(i).Shape,'Rectangle')
    % Check each dimensions of the rectangle
        for j = 1:3
            if largestComponent < components(i).Dim(j)
                largestComponent = components(i).Dim(j);
            end
        end
    elseif strfind(components(i).Shape,'Sphere')
    % Check each dimensions of the sphere
        if largestComponent < components(i).Dim(1)*2
            largestComponent = components(i).Dim(1)*2;
        end
    elseif strfind(components(i).Shape,'Cylinder')
    % If the shape of the component is a cylinder
        for j = 1:2
            if j == 2
                dimension = components(i).Dim(j);
            else 
                dimension = components(i).Dim(j);
            end
            if largestComponent < dimension
                largestComponent = dimension;
            end
        end
    elseif any(strfind(components(i).Shape,'Cone'))
    % If the shape of the component is a cone
        for j = 1:2
            if j == 2
                    dimension = components(i).Dim(j)*2;
            else
                dimension = components(i).Dim(j);
            end
            if largestComponent < dimension
                    largestComponent = dimension;
            end
        end
    end
    if any(strfind(components(i).Name,'Tank'))
    % Get the size of the largest tank on the satellite
        tankSize = components(i).Dim*2;
        nTanks = nTanks + 1;
        if tankDiam < tankSize
            tankDiam = tankSize;
        end
    end
end

% Decide what kind of satellite configuration works best
if largestComponent > 0.3
% If the largest component is greater than 0.3 meters, then search for the
% tankdiameter.
    % If it has a tank, depending on the size, you can do a small satellite,
    % central cylinder, or a larger one. If it doesn't have a tank, you can do
    % a small satellite, or a larger one.
    if tankDiam ~= 0
    % Check to make sure that there is a tank and what the size is. If
    % there are more than one tanks, find the larger one.
        clampbandSize = ClampbandSizer(tankDiam);
        if isempty(clampbandSize) || nTanks > 2
        % If the clampbandSize variable is empty, this means that the fuel
        % tank is larger than any of the clampband sizes, so go with the
        % Panel Mounted Configuration, or if there are more than 2 fuel tanks.
            genParameters.spacecraftType = 'Panel Mounted';
        elseif abs(clampbandSize-tankDiam)/clampbandSize > .30
        % If the tank diameter is so much smaller than the clampband size,
        % 30% difference, then pick a panel mounted configuration
            genParameters.spacecraftType = 'Panel Mounted';
        else
        % Else if the tank diameter fits well within the clampband, then
        % choose the central cylinder configuration
            genParameters.spacecraftType = 'Central Cylinder';
        end
    else
        % If there is no fuel tank then you can use a stacked type
        % configuration
        genParameters.spacecraftType = 'Stacked';
    end 
else
% If there are no components greater than 0.3, go with the cubesat design
    genParameters.spacecraftType = 'Stacked - Cubesat'; 
end

% Define different initial parameters depending on the satellite type.
if strfind(genParameters.spacecraftType,'Central Cylinder')
% Create a central cylinder type satellite

    % Aspect ratios used for the satellite.
    genParameters.spacecraftType = 'Central Cylinder';
    genParameters.cylinderDiam = clampbandSize;
    ratios.shear_cylinder = 0.3;
    ratios.panel_cylinder = 1.2;
    genParameters.tolerance = 0.025; % tolerance for space between components.
    genParameters.ratios = ratios;
    
    genParameters.satHeight = 0.2;
    genParameters.satLength = ratios.panel_cylinder*genParameters.cylinderDiam;
    genParameters.satWidth = genParameters.cylinderDiam+(ratios.shear_cylinder*genParameters.cylinderDiam + genParameters.honeycombThickness)*2;
 
elseif strfind(genParameters.spacecraftType,'Stacked')
% Create a stacked satellite

    genParameters.tolerance = 0.001; % tolerance for space between components.
    genParameters.trays = [1,genParameters.aluminumThickness]; % a parameter that says the number of trays on the satellite and where they should start.
    if largestComponent <= 0.3
    % Create a cubesat
        % If the largest component is smaller than 30 centimeters, create a
        % cubesat shape
        genParameters.satWidth = .1; % Initial Length
        genParameters.satLength = .1; % Initial Width
        genParameters.satHeight = .1; % Initial Height    
    else 
    % Create a normal stacked satellite
        % Else just use a ratio that scales the size of the satellite
        % compared to the biggest component to get the width, length, and
        % height
        ratios.size_component = 1.01; 
        genParameters.satWidth = ratios.size_component*largestComponent; % Initial Length
        genParameters.satLength = ratios.size_component*largestComponent; % Initial Width
        genParameters.satHeight = 0; % Initial Height   
        %genParameters.satHeight = ratios.size_component*largestComponent;
    end
elseif strfind(genParameters.spacecraftType,'Panel Mounted')
% Create a panel mounted satellite
        % Else just use a ratio that scales the size of the satellite
        % compared to the biggest component to get the width, length, and
        % height
        genParameters.tolerance = 0.001; % tolerance for space between components.
     
        ratios.size_component = 1.01;
        genParameters.satWidth = ratios.size_component*largestComponent; % Initial Length
        genParameters.satLength = ratios.size_component*largestComponent; % Initial Width
        genParameters.satHeight = .1; % Initial Height  
        %genParameters.satHeight = ratios.size_component*largestComponent;
end

function clampbandSize = ClampbandSizer(tankDiam)
% A function that checks the tank diameter to find the size of the LV
% payload adapter needed if possible.

load('payloadAdapter.mat');
i = 1;
while i <= size(payloadAdapter,1) && tankDiam > payloadAdapter(i,1) 
% If the tank diameter size is smaller or equal to the available clampband of the
% diameter
    i = i+1;
end

if i <= size(payloadAdapter,1)
    % Make the size of the cylinder the size of the smallest payload adapter able
    % to fit the fuel tank.
    clampbandSize = payloadAdapter(i);
else
    % If none of the tank diameters fit in the given clampbands
    clampbandSize = [];
end




