function sat_out = sat_adcs(sat_in)

% sat_adcs
%   sat = sat_adcs(sat);
%
%   Function to model the CRISIS-sat Attitude Determination and Control System.

% unpackage sat struct : N/A
% call internal functions
sat1 = sat_in;

%Open the excel file
filename = 'Components Database-Real.xlsx';
sheet = 2; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A2:L21'; %this represents the full ADCS systems for CubeSats
[sat_in.ADCS_cat,sat_in.ADCS_name]  = xlsread(filename,sheet,xlRange);

conf = sat_in.ADCSConf;
if sat_in.ADCSChoice == 1 %When you want to choose ADCS from a catalogue
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   %Initializations for the full ADCS system
%   power = sat_in.PowerADCS;
%   pointing_acc = sat_in.MaxPointingADCS;
      
   %%Iteration for the full ADCS
%    power_before = power; %retains the value of the user initialization of power wanted
%    pointing_acc_before = pointing_acc; %retains the value of the user initialization of accuracy wanted
%    power_choice = 0; %initializing power_choice to see if it goes into the if statement below
%    acc_choice = 0; %initializing acc_choice to see if it goes into the if statement
%    for i = 1:5
%        if power >= sat_in.ADCS_cat(i,3) && pointing_acc >= sat_in.ADCS_cat(i,4)
%            power_choice = sat_in.ADCS_cat(i,3);
%            power = power_choice;
%            acc_choice = sat_in.ADCS_cat(i,4);
%            pointing_acc = acc_choice;
%            ADCS_choice = sat_in.ADCS_name(i,2);
%        end
%    end
%    
%    if power_before == power_choice && pointing_acc_before == acc_choice
%        fprintf('The ADCS chosen is %s\n', char(ADCS_choice));
%        fprintf('The mass of the ADCS is %d(g)\n',sat_in.ADCS_cat(i,1));
%        fprintf('The dimensions of the ADCS is %s(mm)\n',char(sat_in.ADCS_name(i,4)));
%        fprintf('At an altitude of %d(km), there will be a gravitational torque of %d(N-m) ,a magnetic torque of %d(N-m), a solar torque of %d(N-m) and an aero torque of %d(N-m)\n',sat2.Altitude, sat2.TorqueGravity, sat2.TorqueMagnetic, sat2.TorqueSolar, sat2.TorqueAero);
%    elseif power_before == power && pointing_acc_before == pointing_acc
%        fprintf('No ADCS matches the specifications\n');
%    else
%        fprintf('The ADCS chosen is %s\n', char(ADCS_choice));
%        fprintf('The mass of the ADCS is %d(g)\n',sat_in.ADCS_cat(i,1));
%        fprintf('The dimensions of the ADCS is %s(mm)\n',char(sat_in.ADCS_name(i,4)));
%        fprintf('At an altitude of %d(km), there will be a gravitational torque of %d(N-m) ,a magnetic torque of %d(N-m), a solar torque of %d(N-m) and an aero torque of %d(N-m)\n',sat2.Altitude, sat2.TorqueGravity, sat2.TorqueMagnetic, sat2.TorqueSolar, sat2.TorqueAero);
%    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   

    if conf == 1 %RW + MGT
       %Iteration for the reaction wheel
       sat2 = sat_adcs_disturbances(sat1); %Calculate disturbance torques for each architecture
       sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
       sat4 = sat_adcs_actutators_magneticTorquers(sat2); %Calculate which magnetic torquer to use
       sat5 = sat_adcs_sensors(sat2); %Calculate which sensors to use
       fprintf('The reaction wheel chosen is: %s\n',char(sat3.RWChoice));
       mass = sat3.RWMass + sat5.SensorMass; %sat4.MGTMass 
       cost = sat3.RWCost + sat5.SensorCost; %+ sat4.MGTCost
       sat6.mass = mass;
       sat6.cost = cost;
       sat_out = sat6;
   elseif conf == 4
       %Iteration for 3-axis stabilization using magnetic torquers
       sat2 = sat_adcs_disturbances(sat1); %Calculate disturbance torques for each architecture
       sat3 = sat_adcs_actutators_magneticTorquers(sat2); %Calculate which magnetic torquer to use
       sat4 = sat_adcs_sensors(sat2);
       mass = sat3.MGTMass + sat4.SensorMass;
       cost = sat3.MGTCost + sat4.SensorCost;
       sat5.mass = mass;
       sat5.cost = cost;
       sat_out = sat5;
   else
       sat2 = sat_adcs_disturbances(sat1); %Calculate disturbance torques for each architecture
       sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
       sat4 = sat_adcs_actutators_thrusters(sat3); %Calculate thrusters
       fprintf('The reaction wheel chosen is: %s\n',char(sat3.RWChoice));
       sat5 = sat_adcs_sensors(sat2); %Calculate which sensor to use
       mass = sat3.RWMass + sat4.ADCSPropellantMass + sat5.SensorMass;
       cost = sat3.RWCost + sat4.ThrusterCost + sat5.SensorCost;
       sat6.mass = mass;
       sat6.cost = cost;
       sat_out = sat6;
       
   end

   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif sat_in.ADCSChoice ==2 %When you want to make the ADCS   
    sat2 = sat_adcs_disturbances(sat1); % Calculates disturbance torques
    
    sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
    sat4 = sat_adcs_actutators_magneticTorquers(sat3); %Calculate which magnetic torquer to use
    sat5 = sat_adcs_sensors(sat2); %Calculate which sensors to use
    
    mass = sat3.RWMass*sat3.NRW + sat5.SensorMass + sat4.MGTMass*sat4.NMGT;% *sat3.NRW and *sat4.NMGT added by Pau (correct?) 
    cost = sat3.RWCost*sat3.NRW + sat5.SensorCost + sat4.MGTCost*sat4.NMGT;% *sat3.NRW and *sat4.NMGT added by Pau (correct?)
    sat6.mass = mass;
    sat6.cost = cost;
    
    %sat4.SensorMass=sat5.SensorMass;
    %sat7=sat_adcs_MassPower(sat4);
    %sat6.AvgPowerADCS=sat7.AvgPowerADCS;
    
    %Outputs for Structures (Anjit)
    TypesSensors=length(strsplit(sat5.NTypes,' '));
    Sensors=strsplit(sat5.NTypes,' ');
    Nsensors=0;
    NSun=0;
    NEarth=0;
    NMM=0;
    NStar=0;
    NCombo=0;
    i=1;  
    while i<=TypesSensors
        if strcmp(Sensors{i},'Sun')
            Nsensors=Nsensors+sat1.NumberofSunSensors;
            NSun=sat1.NumberofSunSensors;
        elseif strcmp(Sensors{i},'Earth')
            Nsensors=Nsensors+sat1.NumberofEarthSensors;
            NEarth=sat1.NumberofEarthSensors;
        elseif strcmp(Sensors{i},'MM')
            Nsensors=Nsensors+sat1.NumberofMagnetometers;
            NMM=sat1.NumberofMagnetometers;
        elseif strcmp(Sensors{i},'Combo')
            Nsensors=Nsensors+1;
            NCombo=1;
        elseif strcmp(Sensors{i},'Star')
            Nsensors=Nsensors+sat1.NumberofStarTrackers;
            NStar=sat1.NumberofStarTrackers;
        end
        i=i+1;
    end

    %Filling of the cell containing all the components of the ADCS
    Ncomponents=Nsensors+sat3.NRW+sat4.NMGT;
    components(Ncomponents) = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[],'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[],'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);

    %Reaction Wheels
    row=1;
    iNRW=1;
    while iNRW<=sat3.NRW
        components(row) = struct('Name','Reaction Wheel','Subsystem','ADCS','Shape','Cylinder','Mass',sat3.RWMass,'Dim',[sat3.RWThickness,sat3.RWRadius],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
        iNRW=iNRW+1;
        row=row+1;
    end
    
    %Magnetic Torquers
    if sat4.MGTMass~=0
        iMGT=1;
        while iMGT<=sat4.NMGT
            if strcmp(sat4.MGTShape,'Cylinder')
                components(row) = struct('Name','Magnetic Torquer','Subsystem','ADCS','Shape','Cylinder','Mass',sat4.MGTMass,'Dim',[sat4.MGTRadius,sat4.MGTH],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            elseif strcmp(sat4.MGTShape,'Rectangle')
                components(row) = struct('Name','Magnetic Torquer','Subsystem','ADCS','Shape','Rectangle','Mass',sat4.MGTMass,'Dim',[sat4.MGTL,sat4.MGTW,sat4.MGTH],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iMGT=iMGT+1;
            row=row+1;
        end
    end
    
    %Sensors
    if NSun~=0
        iSun=1;
        while iSun<=NSun
            if strcmp(sat5.Components.Sun.Shape,'Cylinder')
                components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Sun.Mass,'Dim',[sat5.Components.Sun.R,sat5.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Sun.Mass,'Dim',[sat5.Components.Sun.L,sat5.Components.Sun.W,sat5.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iSun=iSun+1;
            row=row+1;
        end
    end
    
    if NEarth~=0
        iEarth=1;
        while iEarth<=NEarth
            if strcmp(sat5.Components.Earth.Shape,'Cylinder')
                components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Earth.Mass,'Dim',[sat5.Components.Earth.R,sat5.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Earth.Mass,'Dim',[sat5.Components.Earth.L,sat5.Components.Earth.W,sat5.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iEarth=iEarth+1;
            row=row+1;
        end
    end
    
    if NMM~=0
        iMM=1;
        while iMM<=NMM
            if strcmp(sat5.Components.MM.Shape,'Cylinder')
                components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.MM.Mass,'Dim',[sat5.Components.MM.R,sat5.Components.MM.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.MM.Mass,'Dim',[sat5.Components.MM.L,sat5.Components.MM.W,sat5.Components.MM.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iMM=iMM+1;
            row=row+1;
        end
    end
    
    if NStar~=0
        iStar=1;
        while iStar<=NStar
            if strcmp(sat5.Components.Star.Shape,'Cylinder')
                components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Star.Mass,'Dim',[sat5.Components.Star.R,sat5.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Star.Mass,'Dim',[sat5.Components.Star.L,sat5.Components.Star.W,sat5.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iStar=iStar+1;
            row=row+1;
        end
    end
    
    if NCombo~=0
        iCombo=1;
        while iCombo<=NCombo
            if strcmp(sat5.Components.Sun.Shape,'Cylinder')
                components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Combo.Mass,'Dim',[sat5.Components.Combo.R,sat5.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Combo.Mass,'Dim',[sat5.Components.Combo.L,sat5.Components.Combo.W,sat5.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iCombo=iCombo+1;
            row=row+1;
        end
    end

    sat6.comp = components;
    sat_out = sat6;

end

return;