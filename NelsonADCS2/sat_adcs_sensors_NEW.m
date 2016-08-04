function sat_out = sat_adcs_sensors_NEW (sat_in)

%Initialize number of star trackers, sun sensors, earth sensors, and
%magnetometers

N_Star = sat_in.NumberofStarTrackers;
N_Sun  = sat_in.NumberofSunSensors;
N_Earth= sat_in.NumberofEarthSensors;
N_Magnet   = sat_in.NumberofMagnetometers;

NTypes=[];%different kinds of sensors (Added by Pau)

cost = inf;
pointing_acc = sat_in.MaxPointingADCS;

% Initialize variables
name_choice = [];
reliability = [];
mass_allSensors = [];
cost_allSensors = [];

%if sat_in.ADCSChoice == 1 %When you want to choose ADCS from a catalogue
%Open the excel files
filename = 'SensorDatabase.xlsx';


magnet_name_choice = '';
magnet_reliability = [];
mass_magnet = 0;
cost_magnet = 0;
if N_Magnet > 0
    magnetSheet = 5; %ADCS catalogue is located in the 2nd sheet ???
    xlRange5 = 'A2:I7';
    [magnet_num, magnet_word]  = xlsread(filename,magnetSheet,xlRange5);
    pointing_acc = sat_in.MaxPointingADCS;
    cost = inf;
    best_i=1;
    for i = 1:size(magnet_word,1)
        if pointing_acc >= magnet_num(i,4) && cost >= magnet_num(i,5)
            pointing_acc = magnet_num(i,4);
            cost = magnet_num(i,5);
            best_i = i;
        end
    end
    
    NTypes=[NTypes 'Magnet'];
    sat_out.Components.Magnet.Mass=magnet_num(best_i,1)/1000;
    sat_out.Components.Magnet.N=N_Magnet;
    sat_out.Components.Magnet.heatpower = magnet_num(best_i,3);
    
    if cost~=inf
        magnet_name_choice = magnet_word(best_i,2);
    else
        magnet_name_choice = 'No magnetometer with high enough pointing accuracy';
    end
    category_choice = 'Magnet';
    cost_magnet = magnet_num(best_i,5);
    mass_magnet = magnet_num(best_i,1)/1000;
    magnet_reliability = magnet_num(best_i,6);
    
    dimensions=magnet_word(best_i,4);
    dimensions=strsplit(dimensions{1},'x');
    if length(dimensions)==3
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.Components.Magnet.L=L;
        sat_out.Components.Magnet.W=W;
        sat_out.Components.Magnet.H=H;
        sat_out.Components.Magnet.Shape='Rectangle';
    else
        diam=str2double(dimensions{1})/1000;
        H=str2double(dimensions{2})/1000;
        sat_out.Components.Magnet.R=diam/2;
        sat_out.Components.Magnet.H=H;
        sat_out.Components.Magnet.Shape='Cylinder';
    end
end


sun_name_choice = '';
sun_reliability = [];
mass_sun = 0;
cost_sun = 0;
if N_Sun > 0
    sunSheet = 1; %ADCS catalogue is located in the 2nd sheet
    xlRange1 = 'A2:I8';
    [sun_num, sun_word]  = xlsread(filename,sunSheet,xlRange1);
    for i = 1:size(sun_word,1)
        if pointing_acc >= sun_num(i,4) && cost >= sun_num(i,5)
            pointing_acc = sun_num(i,4);
            cost = sun_num(i,5);
            best_i = i;
        end
    end
    
    NTypes=[NTypes ' Sun'];
    sat_out.Components.Sun.Mass=sun_num(best_i,1)/1000;
    sat_out.Components.Sun.N=N_Sun;
    sat_out.Components.Sun.heatpower = sun_num(best_i,3);
    
    if cost~=inf
        sun_name_choice = sun_word(best_i,2);
    else
        sun_name_choice = 'No sun sensor with high enough pointing accuracy';
    end
    category_choice = 'Sun';
    cost_sun = sun_num(best_i,5);
    mass_sun = sun_num(best_i,1)/1000;
    sun_reliability = sun_num(best_i,6);
    
    dimensions=sun_word(best_i,4);
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
        sat_out.Components.Sun.Shape='Cylinder';
    end
end

star_name_choice = '';
star_reliability = [];
mass_star = 0;
cost_star = 0;
if N_Star > 0
    starSheet = 3; %ADCS catalogue is located in the 2nd sheet
    xlRange3 = 'A2:I7';
    [star_num, star_word]  = xlsread(filename, starSheet,xlRange3);
    pointing_acc = sat_in.MaxPointingADCS;
    best_i=1;
    cost = inf;
    for i = 1:size(star_word,1)
        if pointing_acc >= star_num(i,4) && cost >= star_num(i,5)
            pointing_acc = star_num(i,4);
            cost = star_num(i,5);
            best_i = i;
        end
    end
    
    NTypes=[NTypes ' Star'];
    sat_out.Components.Star.Mass=star_num(best_i,1)/1000;
    sat_out.Components.Star.N=N_Star;
    sat_out.Components.Star.heatpower = star_num(best_i,3);
    
    if cost~=inf
        star_name_choice = star_word(best_i,2);
    else
        star_name_choice = 'No star sensor with high enough pointing accuracy';
    end
    category_choice = 'Star';
    cost_star = star_num(best_i,5);
    mass_star = star_num(best_i,1)/1000;
    star_reliability = star_num(best_i,6);
    
    dimensions=star_word(best_i,4);
    dimensions=strsplit(dimensions{1},'x');
    if length(dimensions)==3
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.Components.Star.L=L;
        sat_out.Components.Star.W=W;
        sat_out.Components.Star.H=H;
        sat_out.Components.Star.Shape='Rectangle';
    else
        diam=str2double(dimensions{1})/1000;
        H=str2double(dimensions{2})/1000;
        sat_out.Components.Star.R=diam/2;
        sat_out.Components.Star.H=H;
        sat_out.Components.Star.Shape='Cylinder';
    end
end

earth_name_choice = '';
earth_reliability = [];
mass_earth = 0;
cost_earth = 0;
if N_Earth > 0
    earthSheet = 4; %ADCS catalogue is located in the 2nd sheet
    xlRange4 = 'A2:I4';
    [earth_num, earth_word]  = xlsread(filename,earthSheet,xlRange4);
    pointing_acc = sat_in.MaxPointingADCS;
    cost = inf;
    best_i=1;
    for i = 1:size(earth_word,1)
        if pointing_acc >= earth_num(i,4) && cost >= earth_num(i,5)
            pointing_acc = earth_num(i,4);
            cost = earth_num(i,5);
            best_i = i;
        end
    end
    
    NTypes=[NTypes ' Earth'];
    sat_out.Components.Earth.Mass=earth_num(best_i,1)/1000;
    sat_out.Components.Earth.N=N_Earth;
    sat_out.Components.Earth.heatpower = earth_num(best_i,3);
    
    if cost~=inf
        earth_name_choice = earth_word(best_i,2);
    else
        earth_name_choice = 'No earth sensor with high enough pointing accuracy';
    end
    category_choice = 'Earth';
    cost_earth = earth_num(best_i,5);
    mass_earth = earth_num(best_i,1)/1000;
    earth_reliability = earth_num(best_i,6);
    
    dimensions=earth_word(best_i,4);
    dimensions=strsplit(dimensions{1},'x');
    if length(dimensions)==3
        L=str2double(dimensions{1})/1000;
        W=str2double(dimensions{2})/1000;
        H=str2double(dimensions{3})/1000;
        sat_out.Components.Earth.L=L;
        sat_out.Components.Earth.W=W;
        sat_out.Components.Earth.H=H;
        sat_out.Components.Earth.Shape='Rectangle';
    else
        diam=str2double(dimensions{1})/1000;
        H=str2double(dimensions{2})/1000;
        sat_out.Components.Earth.R=diam/2;
        sat_out.Components.Earth.H=H;
        sat_out.Components.Earth.Shape='Cylinder';
    end
end


IMUSheet = 2;
xlRange2 = 'A2:I3';
[imu_word, imu_num]  = xlsread(filename,IMUSheet,xlRange2);


name_choice = strcat(star_name_choice,{', '}, sun_name_choice, {', '}, earth_name_choice, {', '}, magnet_name_choice);
reliability = [star_reliability, sun_reliability, earth_reliability, magnet_reliability];
mass_allSensors = mass_star*N_Star + mass_earth*N_Earth + mass_sun*N_Sun + mass_magnet*N_Magnet;
cost_allSensors = cost_star*N_Star + cost_earth*N_Earth + cost_sun*N_Sun + cost_magnet*N_Magnet;

sat_out.NTypes=NTypes;
sat_out.SensorChoice = name_choice;
sat_out.SensorReliability = reliability;
sat_out.SensorMass = mass_allSensors;
sat_out.SensorCost = cost_allSensors;

fprintf('The sensor(s) chosen: %s\n',char(name_choice));

%end