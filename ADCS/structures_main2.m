function [structures] = structures_main2(components)
% Calculates the optimal structure for a set of inputted components.
% All dimensions are assumed to be in meters and mass in kg.
%   Inputs:
%       components     a structure array that contains all the components
%                       for the satellite, see the excel sheet for the
%                       required format of the components
%
%   Outputs:
%       STRUCTURES:     a structure variable that contains the following:
%           width       The width of the satellite
%           height      The height of the satellite
%           structures  a structure array that contains all the inidividual structures
%                       of the satellites and their information
%           components  The components structure array now with CG and
%                       inertia information
%           genParameters   a structure that contains various information
%                           about the satellite and its structure including what type of
%                           structure it is, the thickness of materials, and more
%
%   Cornell University
%   Author Name: Samuel Wu (7/8/16)
%   Author NetID: scw223

%   Sort the components by mass 
sortComponentIndices = ComponentSort(components); 

new.genParameters = initGenParameters(components:




end 