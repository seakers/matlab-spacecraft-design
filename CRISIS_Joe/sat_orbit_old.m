function sat_out = sat_orbit(sat_in)

% sat_orbit
%   sat = sat_orbit(sat);
%
%   Function to model the CRISIS-sat orbit and constellation.


global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global SolarFlux LightSpeed EarthMagneticMoment gravity k_Boltzmann


% unpackage sat struct (in km and radians)
h = sat_in.Altitude;
i = sat_in.Inclination*Rad;
e = sat_in.Eccentricity;
N = sat_in.Nplanes;
M = sat_in.Nsats;
eta = sat_in.MaxPointing*Rad;

% intermediate calculations
a  = h+RE;                      % Semimajor axis [m]
P  = 2*pi*sqrt(a^3/MU);         % Period [s]
dL = 2*pi/86400 * P * RE;       % Longitude shift (at equator) [km]

% compute model outputs
sat_out             = sat_in;       % copy existing fields into updated struct
sat_out.Semimajor   = a;            % Semimajor axis [m]
sat_out.Velocity    = sqrt(MU/a);           % orbital velocity for circular orbit [km/s]
sat_out.VelocityPer = sqrt(2*MU/(a*(1-e))-MU/a);           % velocity at perigee [m/s]
sat_out.VelocityApo = sqrt(2*MU/(a*(1+e))-MU/a);           % velocity at apogee [m/s]
sat_out.Period      = P;           % orbital period [s]
sat_out.Density     = Atmosphere(h);   % atmospheric density at altitude [kg/km^3]
sat_out.MeanAngMotion = sqrt(MU/a^3);         % mean angular motion, n [rad/s]
sat_out.Rho         = asin(RE/(RE+h))*Deg;  %angular radius
sat_out.Epsilon     = acos(sin(eta)/sin(sat_out.Rho*Rad))*Deg;  %elevation angle of ground target
sat_out.Lambda      = 90 - eta*Deg - sat_out.Epsilon;       %earth central angle
if eta == 0
    sat_out.Range   = h;            % range to target
else
    sat_out.Range   = RE*(sin(sat_out.Lambda*Rad)/sin(eta));   %range to target
end
sat_out.CoverageWidth  = 2*h*tan(eta);

return;