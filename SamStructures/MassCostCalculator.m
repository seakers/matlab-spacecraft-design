function [structures,structuresMass,structuresCost,componentsMass,totalMass] = MassCostCalculator(components,structures)
% A function for calculating the total Mass All dimensions are assumed to
% be in meters and mass in kg.
%   Inputs:
%       components      a structure array that contains all the components
%                       for the satellite, see the excel sheet for the
%                       required format of the components
%       structures      a structure array that contains all the structures
%                       for the satellite, see the excel sheet for the
%                       required format of the components
%
%   Outputs:
%       structures      The updated structure array that contains all the structures
%                       for the satellite with their calculated mass based
%                       on the volume and material that they use.
%       structuresMass  The total mass of the structures
%       structuresCost  The total cost of the structures (SHOULD BE
%                       REVISED) Current cost is in $, should be in
%                       thousands of dollars
%       componentsMass  The total mass of the components
%       totalMass       The total mass of the components and structure


% load the material data. The material table has cost in $/kg, gathered
% from the internet and not taking into account labor costs.
materials = MaterialTable();

n1 = length(structures);
structuresCost = zeros(n1,1);
for i = 1:n1
% Go through each of the structures and see if the material for the
% component can be found in the materials table.
    found = 0;
    matInd = 1;
    while matInd <= length(materials) && ~found
    % Search in the materials table for the component material in order to
    % get its density.
        if strcmp(structures(i).Material,materials(matInd).Name)
            found = 1;
        end
        matInd = matInd + 1;
    end    
    if found
    % If the structures material is located in the database, then find the
    % volume and then the mass.
        if strcmp(structures(i).Shape,'Rectangle')
            h = structures(i).Dim(1);
            w = structures(i).Dim(2);
            l = structures(i).Dim(3);
            volume = h*w*l;
        elseif strcmp(structures(i).Shape,'Cylinder Hollow')
            h = structures(i).Dim(1);
            r = structures(i).Dim(2);
            t = structures(i).Dim(3);
            volume = (pi*r^2 - pi*(r-t)^2)*h;
        elseif strcmp(structures(i).Shape,'Cylinder')
            h = structures(i).Dim(1);
            r = structures(i).Dim(2);
            volume = (pi*r^2)*h; 
        elseif strcmp(structures(i).Shape,'Sphere')
            r = structures(i).Dim(1);
            volume = (4/3*pi*r^3);
        end
        % Multiply the density by the volume to get mass and therefore
        % cost.
        structures(i).Mass = materials(matInd-1).Density*volume/2;
        structuresCost(i) = materials(matInd-1).Cost*structures(i).Mass;
    end
end

componentsMass = sum([components.Mass]);
structuresMass = sum([structures.Mass]);

structuresCost = sum(structuresCost)/1000;

totalMass = componentsMass + structuresMass;