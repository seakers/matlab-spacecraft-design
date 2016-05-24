function [genParameters]= initGenParameters(components)
% Check the size of the tank to make sure it fits the size of central
% cylinders available. Central Cylinders are sized based on the size of the
% payload adapters. If the payload adapters are too small, then you can
% place the tanks symmetrically on the base of the satellite. If it's too
% small, then we can use a smaller satellite.

% Get size of multiple fuel tanks if there are multiple fuel tanks.
tankInd = [];
for i = 1:length(components) 
    if strfind(components(i).Name,'Tank')
        tankInd = [tankInd,i];
    end
end

% If it has a tank, depending on the size, you can do a small satellite,
% central cylinder, or a larger one. If it doesn't have a tank, you can do
% a small satellite, or a larger one.
if ~isempty(tankInd)
    % Check to make sure that there is a tank and what the size is. If
    % there are more than one tanks, find the larger one.
    tankDiam = 0;
    for i = 1:size(tankInd,1)
        placeHolder = components(tankInd(i)).Dim*2;
        if tankDiam <= placeHolder
            tankDiam = placeHolder;
        end
    end
    largestComponent = ClampbandSizer(tankDiam);
    structureType = 'Central Cylinder';
else
    % If there is no tank find the largest component on the satellite.
    largestComponent = 0;
    for i = 1:length(components)
    % Cycle through all the components, there are different ways that
    % the component can be very large in dimension to the satellite.
        if strcmp(components(i).Shape,'Rectangle')
            % Check each dimensions of the rectangle
            for j = 1:3
                if largestComponent < components(i).Dim(j)
                    largestComponent = components(i).Dim(j);
                end
            end
        elseif strcmp(components(i).Shape,'Sphere')
            % Check each dimensions of the sphere
            if largestComponent < components(i).Dim(1)*2
                largestComponent = components(i).Dim(1)*2;
            end
        elseif strcmp(components(i).Shape,'Cylinder')
            
        elseif strcmp(components(i).Shape,'Cone')

        end
    end
    structureType = 'Stacked';
% [structures,buildableIndices,genParameters] = InitStructure('Stacked');
end

genParameters.isFit = zeros(length(components),1);
% Define different general parameters depending on the satellite type.
if strcmp(structureType,'Central Cylinder')
    % the component is the tank
    % Aspect ratios used for the satellite.
    genParameters.spacecraftType = 'Central Cylinder';
    genParameters.cylinderDiam = largestComponent;
    ratios.shear_cylinder = 0.3;
    ratios.panel_cylinder = 1.2;
    genParameters.tolerance = 0.025; % tolerance for space between components.

    genParameters.honeycombThickness = .02;
    genParameters.carbonfiberThickness = .03;
    genParameters.ratios = ratios;
    
    genParameters.satHeight = 0.2;
    genParameters.satLength = ratios.panel_cylinder*genParameters.cylinderDiam;
    genParameters.satWidth = genParameters.cylinderDiam+(ratios.shear_cylinder*genParameters.cylinderDiam + genParameters.honeycombThickness)*2;
 
elseif strcmp(structureType,'Stacked')
    genParameters.tolerance = 0.001; % tolerance for space between components.
    genParameters.aluminumThickness = .002; % Initial thickness of aluminum
    genParameters.carbonfiberThickness = .03; % Initial thickness of carbon fiber
    genParameters.trays = [1,genParameters.aluminumThickness]; % a parameter that says the number of trays on the satellite and where they should start.
    if largestComponent <= 0.3
        % Create a stacked satellite
        genParameters.spacecraftType = 'Stacked - Cubesat';
        % If the largest component is smaller than 10 centimeters, create a
        % cubesat shape
        genParameters.satWidth = .1; % Initial Length
        genParameters.satLength = .1; % Initial Width
        genParameters.satHeight = .1; % Initial Height    
    else 
        % Create a stacked satellite
        genParameters.spacecraftType = 'Stacked';
        % Else just use a ratio that scales the size of the satellite
        % compared to the biggest component to get the width, length, and
        % height
        ratios.size_component = .5;
        genParameters.satWidth = ratios.size_component*largestComponent; % Initial Length
        genParameters.satLength = ratios.size_component*largestComponent; % Initial Width
        genParameters.satHeight = .1; % Initial Height    
    end
end

function clampbandSize = ClampbandSizer(componentSize,tank_part)
% A function that checks the component size to verify the size of the payload adapter needed. 
% the tank size to make sure that it doesn't fit

load('payloadAdapter.mat');
i = 1;
while i <= size(payloadAdapter,1) && componentSize > payloadAdapter(i,1) 
    i = i+1;
end

if i <= size(payloadAdapter,1)
    % Make the size of the cylinder the size of the smallest payload adapter able
    % to fit the fuel tank.
    clampbandSize = payloadAdapter(i);
else
    clampbandSize = [];
end




