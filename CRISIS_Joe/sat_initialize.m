function [sat] = sat_initialize()

% sat_initialize
%   sat = sat_initialize;
%
%   Function to create a sat structure and initialize to default valus.

% --------------------------
% Constants
% --------------------------
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global SolarFlux LightSpeed EarthMagneticMoment gravity k_Boltzmann


wgs84data;
SolarFlux           = 1367;             % Solar flux [W/m^2]
LightSpeed          = 3.0E8;            % Light speed in m/s
EarthMagneticMoment = 7.96e15;          % Magnetic moment of the Earth in Tesla*m^3
gravity             = 1000*MU/(RE^2);   % gravity on the Earth in m/s^2
k_Boltzmann         = 1.37E-23;         % Boltzmann Constant


% --------------------------
% User-defined inputs
% --------------------------

% system
sat.Lifetime        = 1;            % satellite lifetime in years
sat.Ntargets        = 5;            % Number of targets for the entire constellation
sat.Mass            = 150;          % spacecraft mass [kg]

% structure
sat.Ixx             = 90;           % Moment of inertia around x axis [kg*m^2]
sat.Iyy             = 60;           % Moment of inertia around y axis [kg*m^2]
sat.Izz             = 90;           % Moment of inertia around z axis [kg*m^2]
sat.SurfaceArea     = 3;            % Surface area [m^2]

% orbital
sat.Altitude        = 800;          % orbit altitude    [km]
sat.Eccentricity    = 0;            % orbit eccentricity [#]
sat.Nsats           = 4;            % total number of satellites [#]
sat.Nplanes         = 2;            % number of planes
sat.MaxPointing     = 20;           % maximum pointing angle from nadir [deg]

% optical
sat.GResOff         = 1;            % ground resolution at max off-nadir angle  [m]
sat.GSD             = 0.5;          % Ground Sampling Distance = half of resolution [m] 
sat.Wavelength      = 500e-9;       % observation wavelength [m]
sat.NPixCrosstrack  = 6000;         % number of CCD pixels along the crosstrack direction [#]
sat.NPixVelocity    = 64;           % number of CCD pixels along the velocity direction [#]
sat.PixelSize       = 10e-6;        % size of pixels in the CCD [m]
sat.Nbits           = 12;           % detector quantization [#]
sat.ArealDensity    = 30;           % Primary mirror areal density [kg/m^2]

% ADCS
sat.ADCSConf                = 1;            % 1: RW+MGT(Mom. dump.) 2:RW+THR(M.D.) 3:RW+THR(M.D. + slew S&D only) 4.3-axis Magnet
sat.Reflectance             = 0.6;          % Reflectance of the sun radiation on the satellite
sat.MaxSolarAngle           = 0;            % Worst-case solar incidence angle [deg]
sat.OffsetCPsolar           = 0.3;          % Offset between the center of pressure and the center of gravity of the s/c for solar pressure [m]
sat.OffsetCPaero            = 0.2;          % Offset between the center of pressure and the center of gravity of the s/c for aerodynamics [m]
sat.ResidualDipole          = 1;            % Residual dipole of the s/c [A*m^2]
sat.DragCoefficient         = 2;            % Aerodynamic drag coefficient of the s/c
sat.RWMarginFactor          = 1.5;          % Margin for sizing of reaction wheels
sat.ThrusterMomentArm       = 0.5;          % Moment Arm for calculation of thrusters' torque.
sat.NumberofThrusters       = 3;
sat.NumberofRW              = 4;            % Number of reaction wheels (>=3) [#] 
sat.NumberofSunSensors      = 3;            % Number of sun sensors(>=2) [#]
sat.NumberofStarTrackers    = 1;
sat.NumberofEarthSensors    = 1;
sat.NumberofMagnetometers   = 2;            % Number of magnetometers(>=2) [#]
sat.NumberofMagneticTorquers= 3;            % Number of Magnetic torquers(>=3) [#]
sat.ADCSSpecificImpulse     = 70;            % specific impulse in s (70s for cold gas, 200s for hydrazine)
sat.ADCSChoice = 1;                         %Choose ADCS from a catalogue is 1 and not is 2
sat.PowerADCS = .5;                         %Power of ADCS
sat.MaxPointingADCS = .1;                   %Accuracy of ADCS wanted
sat.rho_RW = 2700;                          %Density of reaction wheel assumed to be Al-6061 (kg/m^3)
sat.ratio_RW = .1;                          %Aspect ratio of thickness/Radius (assume)
sat.BurnTime = 1;                           %Burn time of 1 second

% Comm
%   Uplink
sat.ULRequiredEbN0              = 12.0;         % Uplink Required Energy per Bit to Noise Spectral Density in dB
sat.ULEbN0Margin                = 3.0;          % Uplink Margin : Eb/No - Eb/N0 required
sat.ImplementationLoss          = 2.0;          % Implementation Loss in dB
sat.ULTXPower                   = 1.0;          % Uplink Transmitter Power in W
sat.ULTXAntennaDiameter         = 2.0;          % Uplink Transmitter Antenna Diameter in m
sat.ULTXLineLoss                = -1.0;         % Uplink Transmitter Power in dB
sat.GroundAntennaMinElevation   = 10;           % Ground Antenna minimum elevation in deg
sat.ULFrequency                 = 2.0E9;        % Uplink Frequency in Hz
sat.ULDataRate                  = 9600;         % Uplink Data rate in bps
sat.ULTXAntennaPointingOffset   = 0.2;          % Uplink Transmitter Antenna Pointing Offset in deg
sat.ULRXAntennaEfficiency       = 0.55;         % Uplink Receiver Antenna Efficiency
sat.TTCRedundancy               = 2;            % Number of elements of each (antenna and transponder)
%   Downlink
sat.DLRequiredEbN0              = 10.0;         % Downlink Required Energy per Bit to Noise Spectral Density in dB
sat.DLEbN0Margin                = 3.0;          % Downlink Margin : Eb/No - Eb/N0 required
sat.DLFrequency                 = 2.2e9;        % Downlink Frequency in Hz
sat.DLRXAntennaPointingOffset   = 0.2;          % Downlink Receiver Antenna Pointing Offset in deg
sat.DLRXAntennaDiameter         = 2.0;          % Downlink Receiver Antenna Diameter in m
sat.DLTXLineLoss                = -1.0;         % Downlink Transmitter Power in dB


% OBDH
sat.CompressionFactor           = 10;                   % Compression Factor

% ground station
sat.NGroundStations             = 2;                    % number of ground stations
sat.LatGroundStations           = [78.2303 -77.8392];   % Latitude vector of ground stations 
sat.LonGroundStations           = [15.3928 -193.3331];  % Longitude vector of ground stations


% Propulsion
sat.SpecificImpulse             = 300;                  % specific impulse in [s] (300s for solid propulsion)

%ADDED BY JOE FOR EASE OF CALCULATION. ADDED INTHEATHERACCESSDURATION FROM
%STK
sat.InTheaterAccessDuration = 120; %in seconds


% -------------------------------------------------------------------------
% Computed outputs
% -------------------------------------------------------------------------

% orbits
sat.Inclination     = 97.78;        % orbit inclination [deg]
sat.Semimajor       = [];           % semimajor axis    [m]
sat.Velocity        = [];           % orbital velocity  [m/s]
sat.VelocityPer     = [];           % velocity at perigee [m/s]
sat.VelocityApo     = [];           % velocity at apogee [m/s]
sat.Period          = [];           % orbital period [s]
sat.Density         = [];           % atmospheric density at altitude [kg/km^3]
sat.MeanAngMotion   = [];           % mean angDLar motion, n [rad/s]
sat.Rho             = [];           % angular radius [deg]
sat.Epsilon         = [];           % elevation angle of ground target [deg]
sat.Lambda          = [];           % earth central angle [deg]
sat.Range           = [];           % range to target [km]
sat.CoverageWidth   = [];           % coverage width [km]

% ADCS
 %%% Disturbances
sat.TorqueGravity   = [];           % Disturbance Torque due to gravity gradient in Nm
sat.TorqueMagnetic  = [];           % Disturbance Torque due to gravity gradient in Nm
sat.TorqueSolar     = [];           % Disturbance Torque due to solar pressure in Nm
sat.TorqueAero      = [];           % Disturbance Torque due to aerodynamics in Nm
sat.MaxTorque       = [];           % Worst case Disturbance in Nm
 %%% Actuators: Reaction Wheels
sat.RWTorque        = [];           % Torque required from reaction wheel in Nm
sat.RWMomentum      = [];           % Momentum required from reaction wheel in Nms 
sat.RWMaxOmega      = [];           % Maximum rotation speed of reaction wheel in rad/s
 %%% Actuators: Magnetic Torquers
sat.MGTorquersDipole    = [];           % Dipole of the magnetic torquers in Am^2.
 %%% Actuators: Thrusters
sat.ThrusterForce       = [];           % Force yielded by thrusters [N]
sat.ThrusterNpulses     = [];           % Number of pulses done by thrusters during lifetime [#]
sat.ADCSDelta_V         = [];           % DeltaV necessary for ADCS (thrusters option) [m/s]
sat.ADCSDelta_VD        = [];           % Proportion from DeltaV due to disturbances [%]
sat.ADCSDelta_VS        = [];           % Proportion from DeltaV due to slewing requirements [%]
sat.ADCDVS_VT           = [];           % Ratio between DeltaV due to slewing requirements and total DeltaV [%]
sat.ADCSPropellantMass  = [];           % Propellant mass necessary for ADCS [kg]
sat.MassADCS            = [];           % ADCS mass [kg]
sat.PeakPowerADCS       = [];           % ADCS peak power requirements [W]
sat.AvgPowerADCS        = [];           % ADCS average power requirements [W]
sat.OffPowerADCS        = [];           % ADCS min power requirements [W]

% optical
sat.Aperture        = [];       % primary mirror aperture diameter          [m]
sat.Flength         = [];       % focal length                              [m]
sat.FOVc            = [];       % instrument cross track field of view      [deg]
sat.GResNadir       = [];       % ground resolution at nadir                [m]
sat.AngleHorizSTK   = [];       % horizontal half angle for STK Sensor      [deg]
sat.AngleVertSTK    = [];       % vertical half angle for STK Sensor        [deg]
sat.ImageSize       = [];       % number of bits per image                  [bit]
sat.MassOptics      = [];       % mass of the optical subsystem             [kg]
sat.PeakPowerOptics = [];       % peak power of the optical subsystem       [W]
sat.AvgPowerOptics  = [];       % avg power of the optical subsystem        [W]
sat.OffPowerOptics  = [];       % off power of the optical subsystem        [W]
% comm

sat.ULRXAntennaDiameter     = [];	% Uplink Receiver Antenna Diameter in m
sat.ULRXAntennaGain         = [];	% Uplink Receiver Antenna Gain
sat.ULRXAntennaBeamwidth    = [];	% Uplink Receiver Antenna Beamwidth in deg
sat.DLDataRate              = [];   % Downlink Data Rate
sat.DLTXPower               = [];	% Downlink Transmitter Power in W
sat.DLTXAntennaBeamwidth    = [];	% Downlink Transmitter Antenna Beamwidth in deg
sat.DLTXAntennaGain         = [];	% Downlink Transmitter Antenna Gain
sat.DLTXAntennaDiameter     = [];	% Downlink Transmitter Antenna Diameter in m

sat.MassComm                = [];   % Mass of the communications subsystem  [kg]
sat.PeakPowerComm           = [];   % Peak Power of the communications subsystem [W]
sat.AvgPowerComm            = [];   % Average Power of the communications subsystem [W]
sat.OffPowerComm            = [];   % Off Power of the communications subsystem [W]

% power
sat.MassPower       = [];       % Mass of the power subsuystem  [kg]
sat.SolarArrayPower = [];       % Power generated by the solar arrays [W]
sat.SolarArrayArea  = [];       % Area of the solar arrays      [m^2]

% thermal
sat.MassThermal     = [];                   % Thermal subsystem mass [kg]
sat.PeakPowerThermal= [];                   % Thermal subsystem peak power requirements [W]
sat.AvgPowerThermal = [];                   % Thermal subsystem average power requirements [W]
sat.OffPowerThermal = [];                   % Thermal subsystem min power requirements [W]

% propulsion
sat.MassProp         = [];                  % Propulsion subsystem mass [kg]
sat.PeakPowerProp    = [];                  % Propulsion subsystem peak power requirements [W]    
sat.AvgPowerProp     = [];                  % Propulsion subsystem average power requirements [W]
sat.OffPowerProp     = [];                  % Propulsion subsystem min power requirements [W]
    
% OBDH
sat.MassOBDH         = [];                  % OBDH subsystem mass [kg]
sat.PeakPowerOBDH    = [];                  % OBDH subsystem peak power requirements [W]
sat.AvgPowerOBDH     = [];                  % OBDH subsystem average power requirements [W]
sat.OffPowerOBDH     = [];                  % OBDH subsystem min power requirements [W]

% structure
sat.Volume          = [];                   % Estimated Spacecraft volume [kg/m^3]
sat.Inertia         = [];                   % Estimated moment of inertia [kg*m^2]
sat.MassStruct      = [];                   % Estimated structural mass [kg]

% system
sat.Cost            = [];                   % spacecraft system cost estimate [FY00$k]
sat.Power           = [];                   % spacecraft power use [W]

% STK
%sat.InTheaterAccessDuration = [];          % Representative Access Duration for the In Theater scenario (calc w/ STK)
sat.CoverageTime            = [];          % time to achieve 100% coverage [min]
sat.FinalCoverage           = [];          % coverage at end of simulation period
sat.RevisitTimeMax          = [];          % maximum revisit time [min]
sat.RevisitTimeMean         = [];          % mean revisit time [min]
sat.ResponseTimeMax         = [];          % maximum revisit time [min]
sat.ResponseTimeMean        = [];          % mean revisit time [min]
sat.CommDurationMax         = [];          % Max Duration of the communication link between GS and satellites
sat.CommDurationMean        = [];          % Mean Duration of the communication link between GS and satellites
sat.CommDurationMin         = [];          % Min Duration of the communication link between GS and satellites
sat.CommDurationMin         = [];          % Total Duration of the communication link between GS and satellites
sat.CommRespTimeMax         = [];          % Max Response time for the satellites with the ground stations
sat.CommRespTimeMean        = [];          % Mean Response time for the satellites with the ground stations
sat.NImagesPerDay           = [];          % Number of images collected per day per target

% Plot

sat.Fields                  = [];          % Parameters to plot by sat_plot.
return;
% end sat_initialize.m