function [sat] = costexample_sat_init()

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
sat.Lifetime        = 2;            % satellite lifetime in years
sat.Ntargets        = 5;            % Number of targets for the entire constellation
sat.Mass            = 150;          % spacecraft mass [kg]

% structure
sat.Ixx             = 90;
sat.Iyy             = 60;
sat.Izz             = 90;
sat.SurfaceArea     = 3;            % Surface area [m^2]

% orbital
sat.Altitude        = 567;          % orbit altitude    [km]
sat.Eccentricity    = 0;            % orbit eccentricity [#]
sat.Nsats           = 4;            % total number of satellites [#]
sat.Nplanes         = 2;            % number of planes
sat.MaxPointing     = 20;           % maximum pointing angle from nadir [deg]

% optical
sat.GResOff         = 1;            % ground resolution at max off-nadir angle  [m]
sat.GSD             = 0.5;          % Ground Sampling Distance = half of resolution [m] 
sat.Wavelength      = 500e-9;       % observation wavelength [m]
sat.NPixCrosstrack  = 6000;         % number of CCD pixels along the crosstrack direction [#]
sat.NPixVelocity    = 64;            % number of CCD pixels along the velocity direction [#]
sat.PixelSize       = 10e-6;        % size of pixels in the CCD [m]
sat.Nbits           = 12;           % detector quantization [#]
sat.ArealDensity    = 30;           % Primary mirror areal density [kg/m^2]

% ADCS
sat.ADCSConf                = 1;            % 1: RW+MGT(Mom. dump.) 2:RW+THR(M.D.) 3:RW+THR(M.D. + slew S&D only)
sat.Reflectance             = 0.6;
sat.MaxSolarAngle           = 0;            % Worst-case solar incidence angle [deg]
sat.OffsetCPsolar           = 0.3;
sat.OffsetCPaero            = 0.2;
sat.ResidualDipole          = 1;
sat.DragCoefficient         = 2;
sat.RWMarginFactor          = 1.5;
sat.ThrusterMomentArm       = 0.5;
sat.NumberofRW              = 4;
sat.NumberofSunSensors      = 3;
sat.NumberofMagnetometers   = 2;
sat.NumberofMagneticTorquers= 3;
sat.ADCSSpecificImpulse     = 70;            % specific impulse in s (70s for cold gas, 200s for hydrazine)

% Comm
%   Uplink
sat.ULRequiredEbN0              = 12.0;           % Uplink Required Energy per Bit to Noise Spectral Density in dB
sat.ULEbN0Margin                = 3.0;            % Uplink Margin : Eb/No - Eb/N0 required
sat.ImplementationLoss          = 2.0;            % Implementation Loss in dB
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
sat.CompressionFactor           = 10;           % Compression Factor

% ground station
sat.NGroundStations             = 2;            % number of ground stations
%sat.LatGroundStations           = [37.9455 21.3161]; 
%sat.LonGroundStations           = [-75.4611 -157.8864];
sat.LatGroundStations           = [78.2303 -77.8392]; 
sat.LonGroundStations           = [15.3928 -193.3331];


% Propulsion
sat.SpecificImpulse     = 300;      % specific impulse in [s] (300s for solid propulsion)

% -------------------------------------------------------------------------
% Computed outputs
% -------------------------------------------------------------------------

% orbits
sat.Inclination     = [];           % orbit inclination [deg]
sat.Semimajor       = [];           % semimajor axis    [m]
sat.Velocity        = [];           % orbital velocity  [m/s]
sat.VelocityPer     = [];           % velocity at perigee [m/s]
sat.VelocityApo     = [];           % velocity at apogee [m/s]
sat.Period          = [];           % orbital period [s]
sat.Density         = [];           % atmospheric density at altitude [kg/km^3]
sat.MeanAngMotion   = [];           % mean angDLar motion, n [rad/s]
sat.Rho             = [];           % angular radius [deg]
sat.Epsilon         = [];           % elevation angle of ground target [deg]
sat.Lambda           = [];          % earth central angle [deg]
sat.Range           = [];           % range to target [km]
sat.CoverageWidth   = [];           % coverage width [km]

% ADCS
 %%% Disturbances
sat.TorqueGravity   = [];       % Disturbance Torque due to gravity gradient in Nm
sat.TorqueMagnetic  = [];       % Disturbance Torque due to gravity gradient in Nm
sat.TorqueSolar     = [];
sat.TorqueAero      = [];
sat.MaxTorque       = [];
 %%% Actuators: Reaction Wheels
sat.RWTorque        = [];
sat.RWMomentum      = [];
sat.RWMaxOmega      = [];
 %%% Actuators: Magnetic Torquers
sat.MGTorquersDipole= [];
 %%% Actuators: Thrusters
sat.ThrusterForce   = [];
sat.ThrusterNpulses = [];
sat.ADCSDelta_V     = [];
sat.ADCSDelta_VD    = [];
sat.ADCSDelta_VS    = [];
sat.ADCDVS_VT       = [];
sat.ADCSPropellantMass = [];
sat.MassADCS        = 18.3;
sat.PeakPowerADCS       = [];
sat.AvgPowerADCS       = [];
sat.OffPowerADCS       = [];

% optical
sat.Aperture        = .263;       % primary mirror aperture diameter          [m]
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

sat.MassComm                = 6.8;   % Mass of the communications subsystem  [kg]
sat.PeakPowerComm           = [];   % Peak Power of the communications subsystem [W]
sat.AvgPowerComm            = [];   % Average Power of the communications subsystem [W]
sat.OffPowerComm            = [];   % Off Power of the communications subsystem [W]

% power
sat.MassPower       =45.7;       % Mass of the power subsuystem  [kg]
sat.SolarArrayPower = [];       % Power generated by the solar arrays [W]
sat.SolarArrayArea  = [];       % Area of the solar arrays      [m^2]

% thermal
sat.MassThermal     = 6.8;
sat.PeakPowerThermal= [];
sat.AvgPowerThermal = [];
sat.OffPowerThermal = [];

% propulsion
sat.MassProp         = 0;
sat.PeakPowerProp    = [];
sat.AvgPowerProp     = [];
sat.OffPowerProp     = [];

% OBDH
sat.MassOBDH         = 0;
sat.PeakPowerOBDH    = [];
sat.AvgPowerOBDH     = [];
sat.OffPowerOBDH     = [];

% structure
sat.Volume          = [];
sat.Inertia         = [];
sat.MassStruct      = 32;

% system
sat.Cost            = [];           % spacecraft system cost estimate [$]
sat.Power           = [];           % spacecraft power use [W]

% STK
sat.InTheaterAccessDuration = [];          % Representative Access Duration for the In Theater scenario (calc w/ STK)
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

sat.Fields                  = [];
return;
% end sat_initialize.m