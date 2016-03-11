function [structures,buildableIndices,genParameters]= StructureBuilder(components)
% STRUCTUREBUILDER: Building the structures based on the components that
% are inputted.
% 
%   XYG = Configuration(POSE,XYR) returns the 2D point in global coordinates
%   corresponding to a 2D point in robot coordinates.
% 
%   INPUTS
%       pose    robot's current pose [x y z alpha beta gamma] (1-by-6)
%               alpha = rotation around x axis; beta = rotation around y axis; gamma = rotation around z axis;
%       xyR     3D point in robot coordinates (1-by-3)
% 
%   OUTPUTS
%       xyG     3D point in global coordinates (1-by-3)
% 
% 
% 

% Check the size of the tank to make sure it fits the size of central
% cylinders available. Central Cylinders are sized based on the size of the
% payload adapters. If the payload adapters are too small, then you can
% place the tanks symmetrically on the base of the satellite. If it's too
% small, then we can use a smaller satellite.

% Get size of multiple fuel tanks if there are multiple fuel tanks.
tankInd = [];
for i = 1:size(components,1) 
    if strcmp(components(i).Name,'Fuel Tank')
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
    for i = 1:size(tankInd)
        placeHolder = components(tankInd(i)).Dim*2;
        if tankDiam <= placeHolder
            tankDiam = placeHolder;
        end
    end
    cylinderDiam = ClampbandSizer(tankDiam);
    [structures,buildableIndices,genParameters] = InitStructure(cylinderDiam,'Central Cylinder');
else
    % If there is no tank find the largest component on the satellite.
    
    % Include more here.
    [structures,buildableIndices,genParameters] = InitStructure(cylinderDiam,'Stacked');
% [structures,buildableIndices,genParameters] = InitStructure('Stacked');
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
end




