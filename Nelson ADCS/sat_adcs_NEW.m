function sat_out = sat_adcs(sat_in)


sat1 = sat_in;
sat2 = sat_adcs_disturbances (sat1);
sat6 = sat_adcs_sensors_NEW(sat2); %Calculate which sensors to use

mass = sat6.SensorMass;
cost = sat6.SensorCost;
power = sat6.SensorPower;

if sat1.NumberofRW > 0
    sat3 = sat_adcs_actutators_reactionWheels(sat2); %Calculate which RW to be chosen
    mass = mass + sat3.RWMass*sat1.NumberofRW;
    cost = cost + sat3.RWCost*sat1.NumberofRW;
    power = power + sat3.RWPower*sat1.NumberofRW;
end
if sat1.NumberofMagneticTorquers > 0
    sat4 = sat_adcs_actutators_magneticTorquers(sat2); %Calculate which magnetic torquer to use
    mass = mass + sat4.MGTMass*sat1.NumberofMagneticTorquers;
    cost = cost + sat4.MGTCost*sat1.NumberofMagneticTorquers;
    power = power + sat4.MGTPower*sat1.NumberofMagneticTorquers;
end
if sat1.NumberofThrusters > 0
    sat5 = sat_adcs_actutators_thrusters(sat3); %Calculate thrusters
    mass = mass + sat5.ADCSPropellantMass*sat1.NumberofThrusters;
    cost = cost + sat5.ThrusterCost*sat1.NumberofThrusters;
end

%Open the excel file
filename = 'CompleteADCSDatabase.xlsx';
sheet = 1; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A2:L6'; %this represents the full ADCS systems for CubeSats
[comp_num, comp_text]  = xlsread(filename,sheet,xlRange);
integrated = 0;
best_i = 0;

for i=1:size(comp_text,1)
    if comp_num(i,4)<=sat1.MaxPointingADCS && comp_num(i,5)<=cost
        integrated = 1;
        cost = comp_num (i,5);
        best_i = i;
    end
end

integrated=0;

if integrated == 0
    %Outputs for Structures (Anjit)
    TypesSensors=length(strsplit(sat6.NTypes,' '));
    Sensors=strsplit(sat6.NTypes,' ');
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
    Ncomponents=Nsensors+sat1.NumberofRW + sat1.NumberofMagneticTorquers + sat1.NumberofThrusters;
    components(Ncomponents) = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[],'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[],'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
    
    %Reaction Wheels
    row=1;
    iNRW=1;
    if sat1.NumberofRW>0
        while iNRW<=sat3.NRW
            components(row) = struct('Name','Reaction Wheel','Subsystem','ADCS','Shape','Cylinder','Mass',sat3.RWMass,'Dim',[sat3.RWRadius,sat3.RWThickness],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            iNRW=iNRW+1;
            row=row+1;
        end
    end
    
    %Magnetic Torquers
    if sat1.NumberofMagneticTorquers>0
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
    if sat1.NumberofSunSensors>0
        iSun=1;
        while iSun<=NSun
            if strcmp(sat6.Components.Sun.Shape,'Cylinder')
                components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat6.Components.Sun.Mass,'Dim',[sat6.Components.Sun.R,sat6.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Sun Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat6.Components.Sun.Mass,'Dim',[sat6.Components.Sun.L,sat6.Components.Sun.W,sat6.Components.Sun.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iSun=iSun+1;
            row=row+1;
        end
    end
    
    if sat1.NumberofEarthSensors>0
        iEarth=1;
        while iEarth<=NEarth
            if strcmp(sat6.Components.Earth.Shape,'Cylinder')
                components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat6.Components.Earth.Mass,'Dim',[sat6.Components.Earth.R,sat6.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Earth Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat6.Components.Earth.Mass,'Dim',[sat6.Components.Earth.L,sat6.Components.Earth.W,sat6.Components.Earth.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
                
            end
            iEarth=iEarth+1;
            row=row+1;
        end
    end
    
    if sat1.NumberofMagnetometers>0
        iMM=1;
        while iMM<=NMM
            if strcmp(sat6.Components.Magnet.Shape,'Cylinder')
                components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Cylinder','Mass',sat6.Components.Magnet.Mass,'Dim',[sat6.Components.Magnet.R,sat6.Components.Magnet.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Magnetometer','Subsystem','ADCS','Shape','Rectangle','Mass',sat6.Components.Magnet.Mass,'Dim',[sat6.Components.Magnet.L,sat6.Components.Magnet.W,sat6.Components.Magnet.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iMM=iMM+1;
            row=row+1;
        end
    end
    
    if sat1.NumberofStarTrackers>0
        iStar=1;
        while iStar<=NStar
            if strcmp(sat6.Components.Star.Shape,'Cylinder')
                components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat6.Components.Star.Mass,'Dim',[sat6.Components.Star.R,sat6.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Star Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat6.Components.Star.Mass,'Dim',[sat6.Components.Star.L,sat6.Components.Star.W,sat6.Components.Star.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iStar=iStar+1;
            row=row+1;
        end
    end
    
    if NCombo~=0
        iCombo=1;
        while iCombo<=NCombo
            if strcmp(sat6.Components.Sun.Shape,'Cylinder')
                components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Cylinder','Mass',sat6.Components.Combo.Mass,'Dim',[sat6.Components.Combo.R,sat6.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            else
                components(row) = struct('Name','Combo Sensor','Subsystem','ADCS','Shape','Rectangle','Mass',sat6.Components.Combo.Mass,'Dim',[sat6.Components.Combo.L,sat6.Components.Combo.W,sat6.Components.Combo.H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
            end
            iCombo=iCombo+1;
            row=row+1;
        end
    end
else
    mass = comp_num (best_i,1);
    Ncomponents=1;
    components(Ncomponents) = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[],'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[],'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
    components(1) = struct('Name',comp_text(best_i,2),'Subsystem','ADCS','Shape','Rectangle','Mass',mass,'Dim',comp_text(best_i,4),'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);

end

sat7.power = power;
sat7.mass = mass;
sat7.cost = cost;
sat7.comp = components;
sat_out = sat7;








end
