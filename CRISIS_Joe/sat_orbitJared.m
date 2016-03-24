function sat_out = sat_orbit(sat_in)

% sat_orbit
%   sat = sat_orbit(sat);
%
%   Function to model the CRISIS-sat orbit and constellation.
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global SolarFlux LightSpeed EarthMagneticMoment gravity


% unpackage sat struct (in km and radians)
h = sat_in.Altitude/1000;
i = sat_in.Inclination*Rad;
e = sat_in.Eccentricity;
Omega = sat_in.RAAN*Rad;
argp = sat_in.ArgPerigee*Rad;
N = sat_in.Nplanes;
M = sat_in.Nsats;
Theta = sat_in.AnglePlanes*Rad;

% compute model outputs
sat_out.Semimajor   = h+RE;           % semimajor axis    [m]
a = sat_out.Semimajor
sat_out.Velocity    = sqrt(MU/a);           % orbital velocity for circular orbit [km/s]
sat_out.VelocityPer = sqrt(2*MU/(a*(1-e))-MU/a);           % velocity at perigee [m/s]
sat_out.VelocityApo = sqrt(2*MU/(a*(1+e))-MU/a);           % velocity at apogee [m/s]
sat_out.Period      = 2*pi*sqrt(a^3/MU);           % orbital period [s]
sat_out.RevisitTime = [];           % time between passes over a given location [s]
sat_out.Density     = atmos76(a);   % atmospheric density at altitude [kg/km^3]
sat_out.MeanAngMotion = sqrt(MU/a^3);         % mean angular motion, n [rad/s]


return;