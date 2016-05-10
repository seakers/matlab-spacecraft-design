function [parts,cost,mass] = evaluateProp(mdry,dV,Isp,M,C,rho,Tmin,Tmax)
%--------------------------------------------------------------------------
% This function estimates the specifications for a satellite's fuel tanks
% May use one or more propellants
% INPUTS:
%   mdry = total dry mass of spacecraft [kg]
%   M = array of molecular weights of propellants
%   C = array of stoichiometric coefficients of propellants
%   D = array of densities of propellants
%   Tmin, Tmax = arrays of minimum/maximum propellant storage temperatures
% OUTPUTS:
%   parts = array of structs describing propulsion components
%   cost  = cost of propulsion subsystem [$K]
%   mass  = total (wet) mass of propulsion subsystem [kg]
%--------------------------------------------------------------------------

% Find total propellant mass [kg]
Mprop = mdry*(exp(dV/(9.81*Isp))-1);

% Find fuel tanks needed

N = M.*C;
sumN = sum(N);
parts = [];
vtot = 0;
mass = 0;

for i = 1:length(N)
    
    % Mass of propellant i [kg]
    mprop = Mprop*(N(i)/sumN);
    
    % Volume of propellant i [m^3]
    V = mprop/rho(i);
    
    % Tank dry mass with PMD (from SME Fig. 18-9)
    mtank = (2.7086E-8)*V^3 - (6.2703E-5)*V^2 + (6.6920E-2)*V + 1.3192;
    
    % Total tank mass
    m = mprop + mtank;
    
    % Tank radius [m]
    r = ((3*V)/(4*pi))^(1/3);
    
    % Increment total volume and mass
    vtot = vtot + V;
    mass = mass + m;
    
    % Create tank struct
    tank = struct('Name','Tank',...
        'Subsystem','Propulsion',...
        'Shape','Sphere',...
        'Mass',m,...
        'Dim',r,...
        'CG_XYZ',[],...
        'Vertices',[],...
        'LocationReq','Inside',...
        'Orientation',[],...
        'Thermal',[Tmin(i) Tmax(i)],...
        'InertiaMatrix',[],...
        'RotateToSatBodyFrame',[]);
    
    % Add to output array
    parts = [parts tank];
    
end

% Estimate thruster dimensions and mass
r = max(parts.Dim);
l = 2*r;
m = max(parts.Mass);
mass = mass + m;

% Create thruster struct
thruster = struct('Name','Thruster',...
    'Subsystem','Propulsion',...
    'Shape','Cylinder',...
    'Mass',m,...
    'Dim',[l, r],...
    'CG_XYZ',[],...
    'Vertices',[],...
    'LocationReq','Outside',...
    'Orientation',[],...
    'Thermal',[],...
    'InertiaMatrix',[],...
    'RotateToSatBodyFrame',[]);

% Add thruster to parts array
parts = [thruster, parts];

% Cost (from SME Table 11-8)
cost = 20.0 * (vtot * 1E6)^0.485;


end