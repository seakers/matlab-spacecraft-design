function MLI=MLIproperties
%all the properties are taken and calculated from Multilayer Insulation
%Material Guidelines published by NASA in 1998. Those properties can be
%modified as seen fit

MLI.rho=0.12;          % [kg/m2]
MLI.cost=50;           % [dollar/m2]
MLI.thickness=0.005;   % [m] 
MLI.conductivity=5e-5; % [W/mK]
end