function sat_out = sat_adcs_actutators_thrusters(sat_in)
%% sat_adcs_actutators_thrusters.m
% sat = sat_adcs_actutators_thrusters(sat)
%
%   Function to size the CRISIS-sat Thrusters. Thrusters are calculated
%   taking into account disturbance, slewing and/or momentum dumping
%   requirements, using the expressions given in SMAD.

%%
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global gravity;

%% ---------------------
% Unpackage sat struct
% ---------------------
conf        = sat_in.ADCSConf;
L           = sat_in.ThrusterMomentArm;
dtheta      = 2*sat_in.MaxPointing;
dt          = 0.5*sat_in.InTheaterAccessDuration;
Ntargets    = sat_in.Ntargets;
Nwheels     = sat_in.NumberofRW;
life        = sat_in.Lifetime;
h           = sat_in.RWMomentum;
I           = sat_in.Izz;
Isp         = sat_in.ADCSSpecificImpulse;
mass        = sat_in.Mass;
P           = sat_in.Period;
num_thruster = sat_in.NumberofThrusters;
%num_tank    = sat_in.NumberofTanks;
%% ---------------------
% internal calculations
% ---------------------

% %%%%%%%%%%%%%%%%%%%%%%
% Force (for slewing in Real Time mode and/or momentum dumping)
% %%%%%%%%%%%%%%%%%%%%%%

%   %Disturbance
%FDisturb            = DT./L;

%   %Slewing in the Real Time Mode for conf = 3.
if conf ~= 1
    
    Tslewing            = dt;        
    t1                  = 0.05*Tslewing;    % SMAD page 373
    t2                  = 0.95*Tslewing;    % SMAD page 373
    max_rate            = dtheta.*Rad./(t2-t1+t1/2+(Tslewing-t2)/2); % const acc in 0-t1; a=0 in t1-t2; const a<0 in t2-dt
    alfa                = max_rate/t1;
    FSlew               = I.*alfa./L;

    %   % Momentum dumping for conf = 2,3
    Tdumping            = 1;    % SMAD page 373
    FDump               = h./(L*Tdumping);

    %   %Worst case
    if conf == 2
        vectorF             = [FDump];
    elseif conf == 3
        vectorF             = [FSlew,FDump];
    end

    F                   = max(vectorF);

    % %%%%%%%%%%%%%%%%%%%%%%
    % Pulse budget
    % %%%%%%%%%%%%%%%%%%%%%%

    fdumping    = 1;       % SMAD page 373: One dumping per wheel per day
    fslewing   = 86400/P;  % Real Time : One RT target per orbit [#/day]

    Ndumping    = fdumping*Nwheels*365*life;
    Nslewing    = 2*fslewing*2*365*life;        %because one pulse to start and one to stop in 2 axis
    if conf == 2
        Npulses     = Ndumping;
    elseif conf == 3
        Npulses     = Ndumping + Nslewing;
    end



    % %%%%%%%%%%%%%%%%%%%%%%
    % ADCS Delta_V budget
    % %%%%%%%%%%%%%%%%%%%%%%

    I_dump      = Ndumping*FDump*Tdumping;
    I_slew      = Nslewing*FSlew*t1;
    if conf == 2
        I_total     = I_dump;
    elseif conf == 3
        I_total     = I_dump + I_slew;
    end

    if conf == 2
        DeltaV_dump = I_dump/mass;
        DeltaV_slew = 0;
        DeltaV      = I_total/mass;
    elseif conf == 3
        DeltaV_dump = I_dump/mass;
        DeltaV_slew = I_slew/mass;
        DeltaV      = I_total/mass;
    end


    % %%%%%%%%%%%%%%%%%%%%%%
    % Propellant mass
    % %%%%%%%%%%%%%%%%%%%%%%
    MP          = I_total./(gravity*Isp);
    
    %%%%%%%%%%%%%%
    % Sizing
    %%%%%%%%%%%%%%
    %For the thrusters
    rho_thruster = 4000;
    AR1 = .25;
    AR2 = .125;
    AR3 = .5;
    AR4 = .1;
    volume_coeff = ((1/3)*AR1^2) + ((1/3)*AR2^2*AR3);
    volume_coeff = volume_coeff - ((1/3)*AR1^2*AR4^3);
    thruster_height = MP/(volume_coeff*rho_thruster*num_thruster);
    
    %For the tank
    
    
end
%% ---------------------
% assign model outputs
% ---------------------
sat_out                     = sat_in;
if conf ~= 1
    sat_out.ThrusterForce       = F;
    sat_out.ThrusterNpulses     = Npulses;
    sat_out.TotalImpulse        = I_total;
    sat_out.ADCSDelta_V         = DeltaV;
    sat_out.ADCSDelta_VD        = DeltaV_dump;
    sat_out.ADCSDelta_VS        = DeltaV_slew;
    sat_out.ADCDVS_VT           = DeltaV_slew/DeltaV;
    sat_out.ADCSPropellantMass  = MP;
    sat_out.ThrusterHeight      = thruster_height;
    sat_out.heatpower           = 0;
else
    sat_out.ThrusterForce       = 0;
    sat_out.ThrusterNpulses     = 0;
    sat_out.TotalImpulse        = 0;
    sat_out.ADCSDelta_V         = 0;
    sat_out.ADCSDelta_VD        = 0;
    sat_out.ADCSDelta_VS        = 0;
    sat_out.ADCDVS_VT           = 0;
    sat_out.ADCSPropellantMass  = 0;
    sat_out.ThrusterHeight      = 0;
    sat_out.heatpower           = 0;
end
    

return;