function [SA] = SurfaceAreaCalculator(height,length,width)
% Calculates the surface area of the satellite based on Height, Length, and
% Width.
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

SA = height*length*2 + width*length*2 + height*width*2;
