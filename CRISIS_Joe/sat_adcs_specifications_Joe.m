%%User defined specifications

function sat_out = sat_adcs_specifications_Joe()

altitude_prompt = 'What altitude do you want the spacecraft to reside in (m)? ';
altitude = input(altitude_prompt);

impulses_prompt = 'Will a large impulse be needed for orbit insertion (Y/N)? ';
impulses = input(impulses_prompt,'s');
if impulses == 'Y'
    %Solid motor or large bipropellant stage
    %Large thrusters or a gimbaled engine or spin stabilization for
    %attitude control during burns
    thrusters = 1;
else
    thrusters = 0;
end

planechange_prompt = 'Will an on-orbit plane change be needed (Y/N)? ';
planechange = input(planechange_prompt,'s');
if planechange == 'Y'
        %Need more thrusters
        thrusters = 2;
else
    thrusters = 0;
end

orb_maintenance_prompt = 'Will orbit maintenance be needed (Y/N)? ';
orb_maintenance = input(orb_maintenance_prompt,'s');
if orb_maintenance == 'Y';
    %1 set of thrusters
    thrusters = 3;
else
    thrusters = 0;
end

control_accuracy_prompt = 'What is the required accuracy (deg)? ';
control_accuracy = input(control_accuracy_prompt);
if control_accuracy > 5
    sat_out.control_accuracy = 1;
elseif control_accuracy < 5 && control_accuracy > 1 
    sat_out.control_accuracy = 2;
elseif control_accuracy >.1 && control_accuracy <= 1
    sat_out.control_accuracy = 3;
else
    sat_out.control_accuracy = 4;
end

payload_pointing_prompt = 'What payload pointing direction will be used (Earth-pointing or Inertial-pointing?) ';
payload_pointing = input(payload_pointing_prompt,'s');
if strcmp(payload_pointing,'Earth-pointing')
    %Gravity-gradient line and 3-axis stabilization
else
    %Spin and 3-axis
end



        


sat_out.NumberofThrusters = thrusters;
%%Control accuracy is more important than payload pointing when it comes to
%determining things like 3-axis stabilization. So, have control accuracy be
%the condition by which the effect on ADCS due to payload pointing is based
%on







