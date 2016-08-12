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
momentum = sat_in.RWMomentum;

%Open the excel file
filename = 'Components Database-Real.xlsx';
sheet = 2; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A2:N34'; %this represents the full ADCS systems for CubeSats
[sat_in.ADCS_cat,sat_in.ADCS_name]  = xlsread(filename,sheet,xlRange);
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


%% If statements
if sat_in.ADCSChoice == 1
else
    for s = 1:size(sat_in.ADCS_cat,1)
        if double(D) < sat_in.ADCS_cat(s,12)
            MGT_choice = sat_in.ADCS_name(s,2);
            MGT_cost   = sat_in.ADCS_cat(s,5);
            MGT_mass   = sat_in.ADCS_cat(s,1);
            %added by Pau
            dimensions=sat_in.ADCS_name(s,4);
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
        end
    end
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
end
%% assign model outputs

if sat_in.ADCSChoice == 1
    sat_out.MGTorquersDipole    = D;
    sat_out.MGTCost            = MGT_cost;
    sat_out.MGTMass            = (MGT_mass/1000); % Convert the mass from grams to kg
    sat_out.NMGT=sat_in.NumberofMagneticTorquers;

else
    sat_out.MGTorquersDipole = D;
    sat_out.MGTChoice = MGT_choice;
    sat_out.MGTCost  = MGT_cost;
    sat_out.MGTMass  = (MGT_mass/1000); % Convert the mass from grams to kg
    sat_out.NMGT=sat_in.NumberofMagneticTorquers;

end



return;