function sat_out = sat_adcs_actutators_magneticTorquers(sat_in)
%% sat_adcs_actutators_magneticTorquers.m
%   sat = sat_adcs_actutators_magneticTorquers(sat);
%
%   Function to size the CRISIS-sat Magnetic Torquers. MGT are used
%   exclusively for momentum dumping. They are designed to be able to dump
%   the accumulated momentum in burns of 60s.

global RE
%% unpackage sat struct

%DT      = sat_in.MaxTorque;
h       = sat_in.Altitude;
momentum = .0001;

%Open the excel file
filename = 'ActuatorDatabase.xlsx';
sheet = 2; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A2:I7'; %this represents the full ADCS systems for CubeSats
[mag_num, mag_text]  = xlsread(filename,sheet,xlRange);
sat_out = sat_in; % Initialize sat_out
%% Magnetic Torquers used for momentum dumping exclusively
dtime = 60; % 1 min
DT = momentum / dtime;

%% internal calculations

R = (RE*1000+h);
MmE = 7.96e15;
B = 2*MmE*(R.^(-3)); % Need to find a better way to calculate this
D = DT./B;
if D > 4000
    D = 2000; % hardcode this for now
end
MGT_choice = 0;
MGT_cost=0;
MGT_mass=0;


%% If statements
if sat_in.ADCSChoice == 1
    new_D = inf;
    best_i = 0;
    for i = 1:size(mag_text,1)
        if D <= mag_num(i,7) && mag_num(i,7)<new_D
            new_D = mag_num(i,7);
            best_i = i;
        end
    end
    MGT_choice = mag_text(best_i,2);
    MGT_cost   = mag_num(best_i,4);
    MGT_mass   = mag_num(best_i,1)/1000;
    sat_out.heatpower = mag_num(best_i,3);
    %added by Pau
    dimensions=mag_text(best_i,4);
    dimensions=strsplit(dimensions{1},'x');
    if length(dimensions)==3
        L=str2double(dimensions{1})/1000; % Convert from mm to meters.
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.MGTL=L;
        sat_out.MGTW=W;
        sat_out.MGTH=H;
        sat_out.MGTShape='Rectangle';
    else
        diam=str2double(dimensions{1})/1000; % Convert from mm to meters.
        H=str2double(dimensions{2})/1000;
        sat_out.MGTRadius=diam/2;
        sat_out.MGTH=H;
        sat_out.MGTShape='Cylinder';
    end
    
else
    %CALCULATE AND SIZE MAGNETORQUERS
end

if isempty(MGT_choice)
    fprintf('No MGT in our catalogue satisfies the requirements\n');
    MGT_cost = 0;
    MGT_mass = 0;
    sat_out.MGTL=0;
    sat_out.MGTW=0;
    sat_out.MGTH=0;
    sat_out.MGTShape='';
    sat_out.MGTRadius=0;
    sat_out.NMGT=0;
    sat_out.heatpower = 0;
end
%% assign model outputs

if sat_in.ADCSChoice == 1
    sat_out.MGTorquersDipole    = D;
    sat_out.MGTCost            = MGT_cost;
    sat_out.MGTMass            = MGT_mass; % Convert the mass from grams to kg
    sat_out.NMGT=sat_in.NumberofMagneticTorquers;
    
else
    sat_out.MGTorquersDipole = D;
    sat_out.MGTChoice = MGT_choice;
    sat_out.MGTCost  = MGT_cost;
    sat_out.MGTMass  = MGT_mass/1000; % Convert the mass from grams to kg
    sat_out.NMGT=sat_in.NumberofMagneticTorquers;
    
end



return;