function sat_out = sat_adcs_actutators_reactionWheels(sat_in)
%% sat_adcs_actuators_reactionWheels.m
%  sat = sat_adcs_actuators_reactionWheels(sat);
%
%   Function to size the CRISIS-sat Reaction Wheels. Reaction wheels are
%   sized to meet both disturbance and slewing requirements.
%
%   To make a reaction wheel, need the angular momentum and angular
%   velocity to be able to calculate
%%
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ...
    EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

%% unpackage sat struct

DT      = sat_in.MaxTorque;
P       = sat_in.Period;
dtheta  = 2*sat_in.MaxPointing*Rad;
%dt      = sat_in.MaxSlewTime;
dt      = 0.5*sat_in.InTheaterAccessDuration;
MF      = sat_in.RWMarginFactor;
I       = sat_in.Izz;
%%Joe added
rho_RW = sat_in.rho_RW;
ratio_RW = sat_in.ratio_RW;
N_RW = sat_in.NumberofRW;

%Open the excel file
filename = 'ActuatorDatabase.xlsx';
sheet = 1; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A2:L38'; %this represents the full ADCS systems for CubeSats
[RW_num, RW_text]  = xlsread(filename,sheet,xlRange);

%% internal calculations
ST      = 4.*dtheta.*I./dt^2; %slewing torque
DST     = DT*MF; %disturbance torque
T       = max(DST,ST);
h       = (1/sqrt(2)).*T.*P/4; % momentum storage
omega   = 680; %Look for actual equation
Power   = DST*omega;

%%What Joe added
if sat_in.ADCSChoice == 2
    R = (h/(omega*(.25*rho_RW*pi*ratio_RW) + omega*((1/12)*rho_RW*pi*ratio_RW^3)))^(1/5); %%Calculating radius using Ix and Iy
    %%R = 2*h/(rho_RW*pi*ratio_RW); Calculating radius using Iz
    thickness = R*ratio_RW;
    volume = pi*R^2*thickness;
    mass = volume*rho_RW;
    cost_RW = (.0221*mass) +1.8431; %linear relationship found, but not enough data point
    torque_RW=norm(T);%added by pau
elseif sat_in.ADCSChoice == 1
    %using the max torque and momentum storage calculated, we find a
    %sufficient reaction wheel from the catalogue
    RW_choice = '0'; %just an initialization
    mass = 0; %initialization
    cost_RW = 0; %initialization
    new_T = inf;
    new_h = inf;
    best_i = 0;
    for i=1:size(RW_text,1)
        if new_T >= RW_num(i,7) && new_h >= RW_num(i,9) && RW_num(i,7)>=T && RW_num(i,9)>=h
            new_T = RW_num(i,7);
            new_h = RW_num(i,9);
            best_i = i;
        end
    end
    RW_choice = RW_text(best_i,2);
    torque_RW = RW_num(best_i,7);
    omega     = RW_num(best_i,8);
    mass      = RW_num(best_i,1)/1000;
    cost_RW   = RW_num(best_i,4);
    heatpower = RW_num(best_i,3);
    if strcmp(RW_choice,'0') == 1
        RW_choice = 'There was no RW that satisfied the criteria';
        torque_RW = 0;
        h = 0;
        omega = 0;
    end
    dimensions=RW_text(best_i,4);
    dimensions=strsplit(dimensions{1},'x');
    if length(dimensions)==3
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        x = max(L,W);
        R = max(x,H);
    else
        diam=str2double(dimensions{1})/1000;
        H=str2double(dimensions{2})/1000;
        R=diam/2;
    end
end
%% assign model outputs
sat_out             = sat_in;

if isnan(cost_RW)
    cost_RW = 10;
end

if sat_in.ADCSChoice == 2
    sat_out.RWMomentum  = h;
    sat_out.RWMaxOmega  = omega;
    sat_out.RWPower = Power;
    sat_out.RWRadius    = R;
    sat_out.RWMass      = mass;
    sat_out.NRW      = N_RW;
    sat_out.RWThickness = thickness;
    sat_out.RWVolume = pi*R^2*thickness;
    sat_out.RWCost      = cost_RW;
    sat_out.RWTorque    = torque_RW;
    sat_out.heatpower   = heatpower;
elseif sat_in.ADCSChoice == 1
    sat_out.RWPower     = Power;
    sat_out.RWMass      = mass;
    sat_out.RWRadius = R;
    sat_out.NRW      = N_RW;
    sat_out.RWThickness = H;
    sat_out.RWVolume =  pi*R^2*H;
    sat_out.RWCost      = cost_RW;
    sat_out.RWChoice    = RW_choice;
    sat_out.RWMomentum  = h;
    sat_out.RWMaxOmega  = omega;
    sat_out.RWTorque    = torque_RW;
    sat_out.heatpower = heatpower;
end

return