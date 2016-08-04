function sat_out = sat_adcs_reliability(sat_in)

reliability_sensors = sat_in.SensorReliability;
conf = sat_in.ADCSConf;
mass = sat_in.SensorMass;
cost = sat_in.SensorCost;

if conf == 1
    %Reliability of reaction wheel
    R_RW      = (1-((1-sat_in.reliabilityRW)^sat_in.NumberofRW)); 
    
    %Reliability of magnetometer
    R_magnetometer = (1-((1-sat_in.reliabilityMagnetometer)^sat_in.NumberofMagnetometers));
    
    %Reliability of magnetic torquers
    R_MTorquer = (1-((1-sat_in.reliabilityMTorquer)^sat_in.NumberofMagneticTorquers));
    
    R_combine = R_RW*R_magnetometer*R_MTorquer;
elseif conf == 2
    %Reliability of reaction wheel
    R_RW      = (1-((1-sat_in.reliabilityRW)^sat_in.NumberofRW)); 
    
    %Reliability of thruster
    R_Thruster = (1-((1-sat_in.reliabilityThruster)^sat_in.NumberofThrusters));
    
    R_combine = R_RW*R_Thruster;
elseif conf == 3
    %Reliability of reaction wheel
    R_RW      = (1-((1-sat_in.reliabilityRW)^sat_in.NumberofRW)); 
    
    %Reliability of thruster
    R_Thruster = (1-((1-sat_in.reliabilityThruster)^sat_in.NumberofThrusters));
    
    R_combine = R_RW*R_Thruster;
end

if length(reliability_sensors) == 4
    %Contains star, sun, earth, and magnetometer
    R_star    = 1-((1 - reliability(1))^sat_in.NumberofStarTrackers); %Need to add to sat_initialize
    R_sun     = 1-((1 - reliability(2))^sat_in.NumberofSunSensors);
    R_earth   = 1-((1 - reliability(3))^sat_in.NumberofEarthSensors); %Need to add to sat_initialize
    R_magnet  = 1-((1 - reliability(4))^sat_in.NumberofMagnetometers);%Need to add to sat_initialize
    R_sensors = R_star*R_sun*R_earth*R_magnet;
    
    R_total = R_sensors*R_combine;
    
    if R_total < sat_in.ADCSReliability
        sat_out.NumberofStarTrackers = sat_in.NumberofStarTrackers * 2;
        sat_out.NumberofSunSensors = sat_in.NumberofSunSensors * 2;
        sat_out.NumberofEarthSensors = sat_in.NumberofEarthSensors * 2;
        sat_out.NumberofMagnetometers = sat_in.NumberofMagnetometers * 2;
        sat_out.SensorMass = mass *2; 
        sat_out.SensorCost = cost * 2;
    end
    
elseif length(reliability_sensors) == 3
    %Contains sun, earth, and magnetometer
    R_sun     = 1-((1 - reliability(2))^sat_in.NumberofSunSensors);
    R_earth   = 1-((1 - reliability(3))^sat_in.NumberofEarthSensors); %Need to add to sat_initialize
    R_magnet  = 1-((1 - reliability(4))^sat_in.NumberofMagnetometers);%Need to add to sat_initialize
    R_sensors = R_sun*R_earth*R_magnet;
    
    R_total = R_sensors*R_combine;
    
    if R_total < sat_in.ADCSReliability
        sat_out.NumberofSunSensors = sat_in.NumberofSunSensors * 2;
        sat_out.NumberofEarthSensors = sat_in.NumberofEarthSensors * 2;
        sat_out.NumberofMagnetometers = sat_in.NumberofMagnetometers * 2;
        sat_out.SensorMass = mass *2; 
        sat_out.SensorCost = cost * 2;
    end
elseif length(reliability_sensors) == 2
    %Contains earth/combo and magnetometer
    R_earth   = 1-((1 - reliability(3))^sat_in.NumberofEarthSensors); %Need to add to sat_initialize
    R_magnet  = 1-((1 - reliability(4))^sat_in.NumberofMagnetometers);%Need to add to sat_initialize
    R_sensors = R_earth*R_magnet;
    
    R_total = R_sensors*R_combine;
    
    if R_total < sat_in.ADCSReliability
        sat_out.NumberofEarthSensors = sat_in.NumberofEarthSensors * 2;
        sat_out.NumberofMagnetometers = sat_in.NumberofMagnetometers * 2;
        sat_out.SensorMass = mass *2; 
        sat_out.SensorCost = cost * 2;
    end
else
    R_magnet  = 1-(1 - reliability(4))^sat_in.NumberofMagnetometers;%Need to add to sat_initialize
    R_sensors = R_magnet;
    
    
    R_total = R_sensors*R_combine;
    
    if R_total < sat_in.ADCSReliability
        sat_out.NumberofMagnetometers = sat_in.NumberofMagnetometers * 2;
        sat_out.SensorMass = mass *2; 
        sat_out.SensorCost = cost * 2;
    end
end




    
    
   
    
    
    