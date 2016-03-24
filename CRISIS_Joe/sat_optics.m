function sat_out = sat_optics(sat_in)

% sat_optics
%   sat_out = sat_optics(sat_in);
%
%   Function to model the CRISIS-sat optical system.  
%
%
%   Matthew Smith <m_smith@mit.edu>
%
%   9 Oct 2008



% conversion
rad = pi/180;
deg = 180/pi;

% ---------------------
% Unpackage sat struct
% ---------------------

% orbital
h           = sat_in.Altitude;              % orbital altitude [km]
h           = 1000*h;                       % orbital altitude [m]
eta         = sat_in.MaxPointing;           % off-nadir pointing angle [deg]
eta         = rad*eta;                      % off-nadir pointing angle [rad]

% optical
lambda      = sat_in.Wavelength;            % observing wavelength [m]
Xr_off      = sat_in.GResOff;               % ground resolution at max off-nadir angle  [m]
GSD         = sat_in.GSD;                   % ground sample distance [m]
pixel_num_c = sat_in.NPixCrosstrack;        % number of pixels in the crosstrack direction [#]
pixel_num_v = sat_in.NPixVelocity;          % number of pixels in the velocity vector [#]
pixel_size  = sat_in.PixelSize;             % size of the individual pixels [m]
nbits       = sat_in.Nbits;                 % quantization pixels in bits [#]
AD          = sat_in.ArealDensity;          % primary mirror areal density [kg/m^2]


% ----------------------
% Compute model outputs
% ----------------------
D           = 2.44*h*lambda/(Xr_off*cos(eta)^2);    % required aperture diameter [m]
f           = pixel_size*h/(GSD*cos(eta)^2);        % focal length [m]
Xr_nad      = 2.44*h*lambda/D;                      % ground resolution at nadir [m]
width_c     = pixel_num_c*pixel_size;               % linear size of array (cross-track) [m]
theta_fov_c = deg*atan(width_c/2/f);                % sensor half-angle view (cross-track) [deg]

% sensor view angles for STK
stk_sensor_alongtrack = theta_fov_c;                % along-track sensor half angle for STK [deg]
stk_sensor_crosstrack = deg*eta + theta_fov_c;      % cross-track 'sensor' half angle for STK [deg]

% number of bits per image
one_image = pixel_num_c^2*nbits;            % size of a single frame [bits]
data_size = one_image*4;                    % assume 4 bands of spectral data [bits]

% initial optical system mass model
mass      = pi*(D/2)^2*AD;

% initial power model
power_CCD     = 6.65e-5*(pixel_num_v*pixel_num_c) + 24.6;
power_mirror  = 127*0.25*pi*D^2;
power = power_CCD + power_mirror;

% --------------------------
% Package output sat struct
% --------------------------
sat_out                 = sat_in;           % copy existing fields into updated struct
sat_out.Aperture        = D;                % populate the rest of the computed fields...
sat_out.Flength         = f;
sat_out.GResNadir       = Xr_nad;
sat_out.FOVc            = theta_fov_c;
sat_out.AngleHorizSTK   = stk_sensor_alongtrack;
sat_out.AngleVertSTK    = stk_sensor_crosstrack;
sat_out.ImageSize       = data_size;
sat_out.PeakPowerOptics = power;
sat_out.AvgPowerOptics  = power;
sat_out.OffPowerOptics  = 0.2*power;
sat_out.MassOptics      = mass;


return;