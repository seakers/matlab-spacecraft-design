function [propulsion] = Propulsion(m,h,life)
% -------------------------------------------------------------------------
% Inputs:
%   h:    altitude [km]
%   m:    dry mass [kg]
%   life: lifetime [years]
% -------------------------------------------------------------------------

% Delta-V
dV = DeltaV(h,life);

% Consider Hydrazine and LH2 thrusters
[HydrazineParts,HydrazineCost,HydrazineMass] = evaluateProp(m,dV,200,32,...
    1,0.98,10,30);
[LH2Parts,LH2Cost,LH2Mass] = evaluateProp(m,dV,400,[2 32],[2 1],...
    [70.85 1141],[-259 -218],[-240 -183]);

% Choose less expensive alternative
if HydrazineCost < LH2Cost
    parts = HydrazineParts;
    cost = HydrazineCost;
    mass = HydrazineMass;
else
    parts = LH2Parts;
    cost = LH2Cost;
    mass = LH2Mass;
end

power = 0;

propulsion = struct('cost',cost,'power',power,'mass',mass,'comp',parts);

end