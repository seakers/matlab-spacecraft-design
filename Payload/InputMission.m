function mission = InputMission()
%Uploads GUI that will prompt user to input mission parameters. 

%Cornell University
%Samuel Wu scw223

prompt = {'Configuration','Mission orbit:','Altitude (km):','Inclination (degrees):'...
    ,'Expected lifetime (yrs):','Slewing Angle (degrees):','Slewing Duration (sec):'};
dlg_title = 'Mission Parameters';
num_lines = 1;
defaultans = {'Cubesat','LEO','400','51.6','1','30','60'};
input = inputdlg(prompt,dlg_title,num_lines,defaultans,'on');

% Takes input and stores variables 
mission.config = (input(1));
mission.orbit = char(input(2));
mission.alt = str2double(input(3));
mission.inc = str2double(input(4));
mission.life = str2double(input(5));
mission.slewangle = str2double(input(6));
mission.slewdur = str2double(input(7));

end