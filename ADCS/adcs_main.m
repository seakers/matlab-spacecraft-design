function [adcs]=adcs_main(h,pointingaccuracy,Iyy,Izz,SurfaceArea)
%sat inizialization for ADCS
format long;
initConstants;
wgs84data;

%ORBIT
sat.Altitude = h*10^3;%orbit
R = RE+sat.Altitude; %R = RE+h = a Semimajor axis [m]
sat.Velocity=OrbitVelocity(R,R);
sat.Density=Atmosphere(R);
sat.Period=2*pi*sqrt(R^3/3.98600e14); %period [s]

% ADCS INPUTS

sat.ADCSConf                = 1;            % 1: RW+MGT(Mom. dump.) 2:RW+THR(M.D.) 3:RW+THR(M.D. + slew S&D only) 4:3-axis Magnet
sat.ADCSChoice		        = 2;            % 1: ADCS from a catalogue 2: make ADCS subsystem
sat.MaxPointingADCS         = pointingaccuracy;           % Accuracy of ADCS wanted
sat.Reflectance             = 0.6;          % Reflectance of the sun radiation on the satellite
sat.MaxSolarAngle           = 0;            % Worst-case solar incidence angle [deg]
sat.OffsetCPsolar           = 0.3;          % Offset between the center of pressure and the center of gravity of the s/c for solar pressure [m]
sat.OffsetCPaero            = 0.2;          % Offset between the center of pressure and the center of gravity of the s/c for aerodynamics [m]
sat.ResidualDipole          = 1;            % Residual dipole of the s/c [A*m^2]
sat.DragCoefficient         = 2;            % Aerodynamic drag coefficient of the s/c
sat.RWMarginFactor          = 1.5;          % Margin for sizing of reaction wheels


sat.NumberofThrusters       = 0;
sat.NumberofRW              = 3;            % Number of reaction wheels (>=3) [#] 
sat.NumberofMagneticTorquers= 3;            % Number of Magnetic torquers(>=3) [#]
sat.NumberofSunSensors      = 3;            % Number of sun sensors(>=2) [#]
sat.NumberofStarTrackers    = 1;
sat.NumberofEarthSensors    = 1;
sat.NumberofMagnetometers   = 2;            % Number of magnetometers(>=2) [#]

sat.ADCSSpecificImpulse     = 70;            % specific impulse in s (70s for cold gas, 200s for hydrazine)
sat.rho_RW = 2700;                          %Density of reaction wheel assumed to be Al-6061 (kg/m^3)
sat.ratio_RW = .1;                          %Aspect ratio of thickness/Radius (assume)
sat.BurnTime = 1;                           %Burn time of 1 second
sat.InTheaterAccessDuration = 30;           % duration of slewing maneuver [s]
sat.MaxPointing= 30;                        % Maximum slewing angle [degrees]


%Structures (Anjit)
sat.Iyy=Iyy;
sat.Izz=Izz;
sat.SurfaceArea=SurfaceArea;
sat.ThrusterMomentArm       = 0;          % Moment Arm for calculation of thrusters' torque





adcs = sat_adcs(sat);
% components=adcs.comp;

end















% ADCS OUTPUTS

 %%% Disturbances
% sat.TorqueGravity   = [];           % Disturbance Torque due to gravity gradient in Nm
% sat.TorqueMagnetic  = [];           % Disturbance Torque due to gravity gradient in Nm
% sat.TorqueSolar     = [];           % Disturbance Torque due to solar pressure in Nm
% sat.TorqueAero      = [];           % Disturbance Torque due to aerodynamics in Nm
% sat.MaxTorque       = [];           % Worst case Disturbance in Nm
%  %%% Actuators: Reaction Wheels
% sat.RWTorque        = [];           % Torque required from reaction wheel in Nm
% sat.RWMomentum      = [];           % Momentum required from reaction wheel in Nms 
% sat.RWMaxOmega      = [];           % Maximum rotation speed of reaction wheel in rad/s
%  %%% Actuators: Magnetic Torquers
% sat.MGTorquersDipole    = [];           % Dipole of the magnetic torquers in Am^2.
%  %%% Actuators: Thrusters
% sat.ThrusterForce       = [];           % Force yielded by thrusters [N]
% sat.ThrusterNpulses     = [];           % Number of pulses done by thrusters during lifetime [#]
% sat.ADCSDelta_V         = [];           % DeltaV necessary for ADCS (thrusters option) [m/s]
% sat.ADCSDelta_VD        = [];           % Proportion from DeltaV due to disturbances [%]
% sat.ADCSDelta_VS        = [];           % Proportion from DeltaV due to slewing requirements [%]
% sat.ADCDVS_VT           = [];           % Ratio between DeltaV due to slewing requirements and total DeltaV [%]
% sat.ADCSPropellantMass  = [];           % Propellant mass necessary for ADCS [kg]
% sat.MassADCS            = [];           % ADCS mass [kg]
% sat.PeakPowerADCS       = [];           % ADCS peak power requirements [W]
% sat.AvgPowerADCS        = [];           % ADCS average power requirements [W]
% sat.OffPowerADCS        = [];           % ADCS min power requirements [W]



% function sat_in() inizializations if needed??
% 
% sat_in.MaxTorque = 10;
% sat_in.RWMomentum = 50;
% sat_in.ThrusterMomentArm = 7;
% sat_in.Ntargets = 3;
% sat_in.MaxSolarAngle = 30;
% sat_in.RWTorque = 7;
% sat_in.MGTorquersDipole = 2;
% sat_in.ADCSPropellantMass = 100;
% sat_in.choice = 1;
% sat_in.Power = .5;
