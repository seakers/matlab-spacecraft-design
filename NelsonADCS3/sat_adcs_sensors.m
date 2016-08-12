function sat_out = sat_adcs_sensors (sat_in)

%Open the excel file
filename = 'Components Database-Real.xlsx';
sheet = 2; %ADCS catalogue is located in the 2nd sheet
xlRange = 'A17:M34'; %this represents the sensors for CubeSats
[Sensor_cat,Sensor_name]  = xlsread(filename,sheet,xlRange);

%Initialize number of star trackers, sun sensors, earth sensors, and
%magnetometers
N_Star = sat_in.NumberofStarTrackers;
N_Sun  = sat_in.NumberofSunSensors;
N_Earth= sat_in.NumberofEarthSensors;
N_MM   = sat_in.NumberofMagnetometers;


NTypes=[];%different kinds of sensors (Added by Pau)


pointing_acc = sat_in.MaxPointingADCS;

%Iteration for the sensors
acc_choice = 0;
cost = inf;

% Initialize variables
name_choice = []; 
reliability = [];
mass_allSensors = [];
cost_allSensors = [];

for s = 1:13
    if pointing_acc >= Sensor_cat(s,4) && cost >= Sensor_cat(s,5)
        acc_choice = Sensor_cat(s,4);
        pointing_acc = acc_choice;
        cost = Sensor_cat(s,5);
        cost_sensor = Sensor_cat(s,5);
        name_choice = Sensor_name(s,2);
        category_choice = Sensor_name(s,13);
        sensor_reliability = Sensor_cat(s,6);
        mass_sensor = Sensor_cat(s,1)/1000;
        
        %added By Pau
        dimensions=Sensor_name(s,4);
        dimensions=strsplit(dimensions{1},'x');
        if length(dimensions)==3
            L=str2double(dimensions{1})/1000;
            W=str2double(dimensions{2})/1000;
            H=str2double(dimensions{3})/1000;
        else
            diam=str2double(dimensions{1})/1000;
            H=str2double(dimensions{2})/1000;
        end
    end 
end


if acc_choice == 0
    fprintf('No sensor matches the specifications\n');
else
    %Initializations
    cost_sun = 10000;
    cost_magnet = 10000;
    magnet = 'No magnetometer';
    earth_sensor = 'No earth sensor';
    sun_sensor = 'No sun sensor';
    magnet_reliability = 0;
    sun_reliability = 0;
    earth_reliability = 0;
    mass_magnet = 0;
    mass_sun = 0;
    mass_earth = 0;
    
    
    %Adding other sensors if the chosen one is a star tracker
    if strcmp(category_choice,'Star') == 1
        %added By Pau
        NTypes=[NTypes,'Star'];
        sat_out.Components.Star.Mass=mass_sensor;
        sat_out.Components.Star.N=N_Star;
        if length(dimensions)==3
            sat_out.Components.Star.L=L;
            sat_out.Components.Star.W=W;
            sat_out.Components.Star.H=H;
            sat_out.Components.Star.Shape='Rectangle';
        else
            sat_out.Components.Star.R=diam/2;
            sat_out.Components.Star.H=H;
            sat_out.Components.Star.Shape='Cilinder';
        end
%         star_ssz = (mass_sensor/(N_Star*7870*3.14*.25^2))^(1/3);
%         star_radius = star_ssz * .25;
%         sat_out.size_star = star_radius;
        
        %sun sensors
        bol=false;
        for a = 1:7
            if cost_sun >= Sensor_cat(a,5) && (order(Sensor_cat(a,5),10) < order(cost_sensor,10))
                bol=true;
                sun_sensor = Sensor_name(a,2);
                cost_sun = Sensor_cat(a,5);
                sun_reliability = Sensor_cat(a,6);
                mass_sun = Sensor_cat(a,1)/1000;

                %added by Pau
                sat_out.Components.Sun.Mass=mass_sun;
                sat_out.Components.Sun.N=N_Sun;
                dimensions=Sensor_name(a,4);
                dimensions=strsplit(dimensions{1},'x');
                if length(dimensions)==3
                    L=str2double(dimensions{1})/1000;
                    W=str2double(dimensions{2})/1000;
                    H=str2double(dimensions{3})/1000;
                    sat_out.Components.Sun.L=L;
                    sat_out.Components.Sun.W=W;
                    sat_out.Components.Sun.H=H;
                    sat_out.Components.Sun.Shape='Rectangle';
                else
                    diam=str2double(dimensions{1})/1000;
                    H=str2double(dimensions{2})/1000;
                    sat_out.Components.Sun.R=diam/2;
                    sat_out.Components.Sun.H=H;
                    sat_out.Components.Sun.Shape='Cilinder';
                end
                
            end
        end
        
        if bol
            NTypes=[NTypes,' ','Sun'];
        end
        
        %earth sensors
        earth_sensor = Sensor_name(9,2);
        NTypes=[NTypes,' ','Earth'];
        earth_reliability = Sensor_cat(9,6);
        mass_earth = Sensor_cat(9,1)/1000;
        cost_earth = Sensor_cat(9,5);
        sat_out.Components.Earth.Mass=mass_earth;
        sat_out.Components.Earth.N=N_Earth;
        dimensions=Sensor_name(9,4);
        dimensions=strsplit(dimensions{1},'x');
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.Components.Earth.L=L;
        sat_out.Components.Earth.W=W;
        sat_out.Components.Earth.H=H;
        sat_out.Components.Earth.Shape='Rectangle';
        
        %magnometers(MM) 
        bol=false;
        for b = 12:13
            if cost_magnet >= Sensor_cat(b,5) && (order(Sensor_cat(b,5),10) < order(cost_sensor,10))
                bol=true;
                magnet = Sensor_name(b,2);
                cost_magnet = Sensor_cat(b,5);
                magnet_reliability = Sensor_cat(b,6);
                mass_magnet = Sensor_cat(b,1)/1000;
                %added by Pau
                sat_out.Components.MM.Mass=mass_magnet;
                sat_out.Components.MM.N=N_MM;
                dimensions=Sensor_name(b,4);
                dimensions=strsplit(dimensions{1},'x');
                if length(dimensions)==3
                    L=str2double(dimensions{1})/1000;
                    W=str2double(dimensions{2})/1000;
                    H=str2double(dimensions{3})/1000;
                    sat_out.Components.MM.L=L;
                    sat_out.Components.MM.W=W;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Rectangle';
                else
                    diam=str2double(dimensions{1})/1000;
                    H=str2double(dimensions{2})/1000;
                    sat_out.Components.MM.R=diam/2;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Cilinder';
                end
            end
        end  
        
        if bol
            NTypes=[NTypes,' ','MM'];
        end
%         magnet_msz = (mass_magnet/(.3*7380*1*1))^(1/3);
%         magnet_msx = magnet_msz*1;
%         magnet_msy = magnet_msz*1;
%         magnet_size = [magnet_msx, magnet_msy, magnet_msz];
%         sat_out.magnet_size = magnet_size;
        
        %TOTAL
        name_choice = strcat(name_choice,{', '}, sun_sensor, {', '}, earth_sensor, {', '}, magnet)
        reliability = [sensor_reliability, sun_reliability, earth_reliability, magnet_reliability];
        mass_allSensors = mass_sensor*N_Star + mass_earth*N_Earth + mass_sun*N_Sun + mass_magnet*N_MM;
        cost_allSensors = cost_sensor*N_Star + cost_earth*N_Earth + cost_sun*N_Sun + cost_magnet*N_MM;
    end
    
    if strcmp(category_choice, 'Sun') == 1
        %added By Pau
        NTypes=[NTypes,'Sun'];
        sat_out.Components.Sun.Mass=mass_sensor;
        sat_out.Components.Sun.N=N_Sun;
        if length(dimensions)==3
            sat_out.Components.Sun.L=L;
            sat_out.Components.Sun.W=W;
            sat_out.Components.Sun.H=H;
            sat_out.Components.Sun.Shape='Rectangle';
        else
            sat_out.Components.Sun.R=diam/2;
            sat_out.Components.Sun.H=H;
            sat_out.Components.Sun.Shape='Cilinder';
        end

        %earth sensor
        earth_sensor = Sensor_name(9,2);
        NTypes=[NTypes,' ','Earth'];
        earth_reliability = Sensor_cat(9,6);
        mass_earth = Sensor_cat(9,1)/1000;
        cost_earth = Sensor_cat(9,5);
        sat_out.Components.Earth.Mass=mass_earth;
        sat_out.Components.Earth.N=N_Earth;
        dimensions=Sensor_name(9,4);
        dimensions=strsplit(dimensions{1},'x');
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.Components.Earth.L=L;
        sat_out.Components.Earth.W=W;
        sat_out.Components.Earth.H=H;
        sat_out.Components.Earth.Shape='Rectangle';
        
        %Magnetometer (MM)
        bol=false;
        for b = 12:13
            if cost_magnet >= Sensor_cat(b,5) && (order(Sensor_cat(b,5),10) < order(cost_sensor,10))
                bol=true;
                magnet = Sensor_name(b,2);
                cost_magnet = Sensor_cat(b,5);
                magnet_reliability = Sensor_cat(b,6);
                mass_magnet = Sensor_cat(b,1)/1000;
                %added by Pau
                sat_out.Components.MM.Mass=mass_magnet;
                sat_out.Components.MM.N=N_MM;
                dimensions=Sensor_name(b,4);
                dimensions=strsplit(dimensions{1},'x');
                if length(dimensions)==3
                    L=str2double(dimensions{1})/1000;
                    W=str2double(dimensions{2})/1000;
                    H=str2double(dimensions{3})/1000;
                    sat_out.Components.MM.L=L;
                    sat_out.Components.MM.W=W;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Rectangle';
                else
                    diam=str2double(dimensions{1})/1000;
                    H=str2double(dimensions{2})/1000;
                    sat_out.Components.MM.R=diam/2;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Cilinder';
                end
            end
        end
        
        if bol
            NTypes=[NTypes,' ','MM'];
        end
        
%         magnet_msz = (mass_magnet/(.3*7380*1*1))^(1/3);
%         magnet_msx = magnet_msz*1;
%         magnet_msy = magnet_msz*1;
%         magnet_size = [magnet_msx, magnet_msy, magnet_msz];
%         sat_out.magnet_size = magnet_size;
        
        name_choice = strcat(name_choice,{', '}, earth_sensor, {', '}, magnet);
        reliability = [sensor_reliability, earth_reliability, magnet_reliability];
        mass_allSensors = mass_sensor*N_Sun + mass_earth*N_Earth + mass_magnet*N_MM;
        cost_allSensors = cost_sensor*N_Sun + cost_earth*N_Earth + cost_magnet*N_MM;
    end
    
    if strcmp(category_choice, 'Earth') == 1
        %added By Pau
        NTypes=[NTypes,'Earth'];
        sat_out.Components.Earth.Mass=mass_sensor;
        sat_out.Components.Earth.N=N_Earth;
        if length(dimensions)==3
            sat_out.Components.Earth.L=L;
            sat_out.Components.Earth.W=W;
            sat_out.Components.Earth.H=H;
            sat_out.Components.Earth.Shape='Rectangle';
        else
            sat_out.Components.Earth.R=diam/2;
            sat_out.Components.Earth.H=H;
            sat_out.Components.Earth.Shape='Cilinder';
        end
        %Magnotometer (MM)
        bol=false;
        for b = 12:13
            if cost_magnet >= Sensor_cat(b,5) && (order(Sensor_cat(b,5),10) < order(cost_sensor,10))
                bol=true;
                magnet = Sensor_name(b,2);
                cost_magnet = Sensor_cat(b,5);
                magnet_reliability = Sensor_cat(b,6);
                mass_magnet = Sensor_cat(b,1)/1000;
                %added by Pau
                sat_out.Components.MM.Mass=mass_magnet;
                sat_out.Components.MM.N=N_MM;
                dimensions=Sensor_name(b,4);
                dimensions=strsplit(dimensions{1},'x');
                if length(dimensions)==3
                    L=str2double(dimensions{1})/1000;
                    W=str2double(dimensions{2})/1000;
                    H=str2double(dimensions{3})/1000;
                    sat_out.Components.MM.L=L;
                    sat_out.Components.MM.W=W;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Rectangle';
                else
                    diam=str2double(dimensions{1})/1000;
                    H=str2double(dimensions{2})/1000;
                    sat_out.Components.MM.R=diam/2;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Cilinder';
                end
            end
        end
        
        if bol
            NTypes=[NTypes,' ','MM'];
        end
        
        name_choice = strcat(name_choice,{', '}, magnet);
        reliability = [sensor_reliability, magnet_reliability];
        mass_allSensors = mass_sensor*N_Earth + mass_magnet*N_MM;
        cost_allSensors = cost_sensor*N_Earth + cost_magnet*N_MM;
    end
    
    if strcmp(category_choice, 'Combo') == 1
        %added By Pau
        NTypes=[NTypes,'Combo'];
        sat_out.Components.Combo.Mass=mass_sensor;
        sat_out.Components.Combo.N=1;
        if length(dimensions)==3
            sat_out.Components.Combo.L=L;
            sat_out.Components.Combo.W=W;
            sat_out.Components.Combo.H=H;
            sat_out.Components.Combo.Shape='Rectangle';
        else
            sat_out.Components.Combo.R=diam/2;
            sat_out.Components.Combo.H=H;
            sat_out.Components.Combo.Shape='Cilinder';
        end
        %Magnotometer (MM)
        bol=false;
        for b = 12:13
            if cost_magnet >= Sensor_cat(b,5) && (order(Sensor_cat(b,5),10) < order(cost_sensor,10))
                bol=true;
                magnet = Sensor_name(b,2);
                cost_magnet = Sensor_cat(b,5);
                magnet_reliability = Sensor_cat(b,6);
                mass_combo = Sensor_cat(b,1)/1000;
                %added by Pau
                sat_out.Components.MM.Mass=mass_magnet;
                sat_out.Components.MM.N=N_MM;
                dimensions=Sensor_name(b,4);
                dimensions=strsplit(dimensions{1},'x');
                if length(dimensions)==3
                    L=str2double(dimensions{1})/1000;
                    W=str2double(dimensions{2})/1000;
                    H=str2double(dimensions{3})/1000;
                    sat_out.Components.MM.L=L;
                    sat_out.Components.MM.W=W;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Rectangle';
                else
                    diam=str2double(dimensions{1})/1000;
                    H=str2double(dimensions{2})/1000;
                    sat_out.Components.MM.R=diam/2;
                    sat_out.Components.MM.H=H;
                    sat_out.Components.MM.Shape='Cilinder';
                end
            end
        end
        
        if bol
            NTypes=[NTypes,' ','MM'];
        end
%         magnet_msz = (mass_magnet/(.3*7380*1*1))^(1/3);
%         magnet_msx = magnet_msz*1;
%         magnet_msy = magnet_msz*1;
%         magnet_size = [magnet_msx, magnet_msy, magnet_msz];
%         sat_out.magnet_size = magnet_size;
        
        name_choice = strcat(name_choice,{', '}, magnet);
        reliability = [sensor_reliability, magnet_reliability];
        mass_allSensors = mass_combo*N_Earth + mass_magnet*N_MM;
        cost_allSensors = cost_sensor*N_Earth + cost_magnet*N_MM;
    end
    
    if strcmp(category_choice, 'Magnet') == 1
        %added By Pau
        NTypes=[NTypes,'MM'];
        sat_out.Components.MM.Mass=mass_sensor;
        sat_out.Components.MM.N=N_MM;
        if length(dimensions)==3
            sat_out.Components.MM.L=L;
            sat_out.Components.MM.W=W;
            sat_out.Components.MM.H=H;
            sat_out.Components.MM.Shape='Rectangle';
        else
            sat_out.Components.MM.R=diam/2;
            sat_out.Components.MM.H=H;
            sat_out.Components.MM.Shape='Cilinder';
        end
        
        name_choice = strcat(name_choice);
        reliability = [sensor_reliability];
        mass_allSensors = mass_sensor * N_MM;
        cost_allSensors = cost_sensor*N_MM;
%         magnet_msz = (mass_sensor/(.3*7380*1*1))^(1/3);
%         magnet_msx = magnet_msz*1;
%         magnet_msy = magnet_msz*1;
%         magnet_size = [magnet_msx, magnet_msy, magnet_msz];
%         sat_out.magnet_size = magnet_size;
    end
    
    fprintf('The sensor(s) chosen: %s\n',char(name_choice));
end


sat_out.NTypes=NTypes;
sat_out.SensorChoice = name_choice;
sat_out.SensorReliability = reliability;
sat_out.SensorMass = mass_allSensors;
sat_out.SensorCost = cost_allSensors;



%if sat_in.control_accuracy == 1 %>5 degrees
   %w/out attitude determination
   %Need boom motor, GG damper, and a bias momentum wheel
   
   %Find database with these and compare
   
   
   %w/attitude determination
   %sun sensors & magnetometer adequate for attitude determination at greater
   %than or equal to 2 deg
   %higher accuracies may require star trackers or horizon sensors
   %sunsensor = xlsread('CubeSat_SunSensor.xlsx', 
   %Find database with these and compare
   
%elseif sat_in.control_accuracy == 2 %1 deg to 5 deg
   %sun sensors and horizon sensor may be adequate for sensors, especially
   %a spinner
   %accuracy for 3-axis stab can be met w/RCS deadband control, but
   %reaction wheels will save propellant for long missions
   %thrusters and damper adequate for spinner actuators
   %magnetic torquers (and magnetometer) useful
    

