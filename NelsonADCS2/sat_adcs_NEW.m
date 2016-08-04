function sat_out = sat_adcs_NEW(sat_in)

sat1 = sat_in;

conf = sat_in.ADCSConf;
if sat_in.ADCSChoice == 1 %When you want to choose ADCS from a catalogue
    
    if conf == 1 %RW + MGT
        %Iteration for the reaction wheel
        sat2 = sat_adcs_disturbances(sat1); %Calculate disturbance torques for each architecture
        sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
        sat4 = sat_adcs_actutators_magneticTorquers(sat2); %Calculate which magnetic torquer to use
        sat5 = sat_adcs_sensors_NEW(sat2); %Calculate which sensors to use
        %fprintf('The reaction wheel chosen is: %s\n',char(sat3.RWChoice));
        mass = sat3.RWMass + sat5.SensorMass + sat4.MGTMass;
        cost = sat3.RWCost + sat5.SensorCost + sat4.MGTCost;
        sat6.mass = mass;
        sat6.cost = cost;
        sat_out = sat6;
    elseif conf == 4
        %Iteration for 3-axis stabilization using magnetic torquers
        sat2 = sat_adcs_disturbances(sat1); %Calculate disturbance torques for each architecture
        sat3 = sat_adcs_actutators_magneticTorquers(sat2); %Calculate which magnetic torquer to use
        sat4 = sat_adcs_sensors_NEW(sat2);
        sat5 = sat_adcs_sensors_NEW(sat2); %Calculate which sensors to use
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
        sat5 = sat_adcs_sensors_NEW(sat2); %Calculate which sensor to use
        mass = sat3.RWMass + sat4.ADCSPropellantMass + sat5.SensorMass;
        cost = sat3.RWCost + sat4.ThrusterCost + sat5.SensorCost;
        sat6.mass = mass;
        sat6.cost = cost;
        sat_out = sat6;
        
    end
    
elseif sat_in.ADCSChoice ==2 %When you want to make the ADCS
    sat2 = sat_adcs_disturbances(sat1); % Calculates disturbance torques
    
    sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
    sat4 = sat_adcs_actutators_magneticTorquers(sat3); %Calculate which magnetic torquer to use
    sat5 = sat_adcs_sensors_NEW(sat2); %Calculate which sensors to use
    
    mass = sat3.RWMass*sat3.NRW + sat5.SensorMass + sat4.MGTMass*sat4.NMGT;% *sat3.NRW and *sat4.NMGT added by Pau (correct?)
    cost = sat3.RWCost*sat3.NRW + sat5.SensorCost + sat4.MGTCost*sat4.NMGT;% *sat3.NRW and *sat4.NMGT added by Pau (correct?)
    sat6.mass = mass;
    sat6.cost = cost;
end


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
    elseif strcmp(Sensors{i},'Magnet')
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
components(Ncomponents) = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[],'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[],'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',[]);

%Reaction Wheels
row=1;
iNRW=1;
while iNRW<=sat3.NRW
    components(row) = struct('Name','Reaction Wheel','Subsystem','ADCS','Shape','Cylinder','Mass',sat3.RWMass,'Dim',[sat3.RWRadius,sat3.RWThickness],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat3.heatpower);
    iNRW=iNRW+1;
    row=row+1;
end

%Magnetic Torquers
if sat4.MGTMass~=0
    iMGT=1;
    while iMGT<=sat4.NMGT
        if strcmp(sat4.MGTShape,'Cylinder')
            components(row) = struct('Name','Magnetic Torquer','Subsystem','ADCS','Shape','Cylinder','Mass',sat4.MGTMass,'Dim',[sat4.MGTRadius,sat4.MGTH],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat4.heatpower);
        elseif strcmp(sat4.MGTShape,'Rectangle')
            components(row) = struct('Name','Magnetic Torquer','Subsystem','ADCS','Shape','Rectangle','Mass',sat4.MGTMass,'Dim',[sat4.MGTL,sat4.MGTW,sat4.MGTH],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat4.heatpower);
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
            components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Sun.Mass,'Dim',[sat5.Components.Sun.R,sat5.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Sun.heatpower);
        else
            components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Sun.Mass,'Dim',[sat5.Components.Sun.L,sat5.Components.Sun.W,sat5.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Sun.heatpower);
        end
        iSun=iSun+1;
        row=row+1;
    end
end

if NEarth~=0
    iEarth=1;
    while iEarth<=NEarth
        if strcmp(sat5.Components.Earth.Shape,'Cylinder')
            components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Earth.Mass,'Dim',[sat5.Components.Earth.R,sat5.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Earth.heatpower);
        else
            components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Earth.Mass,'Dim',[sat5.Components.Earth.L,sat5.Components.Earth.W,sat5.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Earth.heatpower);

        end
        iEarth=iEarth+1;
        row=row+1;
    end
end

if NMM~=0
    iMM=1;
    while iMM<=NMM
        if strcmp(sat5.Components.Magnet.Shape,'Cylinder')
            components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Magnet.Mass,'Dim',[sat5.Components.Magnet.R,sat5.Components.Magnet.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Magnet.heatpower);
        else
            components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Magnet.Mass,'Dim',[sat5.Components.Magnet.L,sat5.Components.Magnet.W,sat5.Components.Magnet.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Magnet.heatpower);
        end
        iMM=iMM+1;
        row=row+1;
    end
end

if NStar~=0
    iStar=1;
    while iStar<=NStar
        if strcmp(sat5.Components.Star.Shape,'Cylinder')
            components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Star.Mass,'Dim',[sat5.Components.Star.R,sat5.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Star.heatpower);
        else
            components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Star.Mass,'Dim',[sat5.Components.Star.L,sat5.Components.Star.W,sat5.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',sat5.Components.Star.heatpower);
        end
        iStar=iStar+1;
        row=row+1;
    end
end

if NCombo~=0
    iCombo=1;
    while iCombo<=NCombo
        if strcmp(sat5.Components.Sun.Shape,'Cylinder')
            components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat5.Components.Combo.Mass,'Dim',[sat5.Components.Combo.R,sat5.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',[]);
        else
            components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat5.Components.Combo.Mass,'Dim',[sat5.Components.Combo.L,sat5.Components.Combo.W,sat5.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[],'HeatPower',[]);
        end
        iCombo=iCombo+1;
        row=row+1;
    end
end


sat6.comp = components;
sat_out = sat6;








end
