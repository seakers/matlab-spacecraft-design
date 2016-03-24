function [power,components]=power_analysis2(params,vars)
    %params:h,lifetime 
    Asa=vars(1);
    icell=vars(2);
    ibat=vars(3);
    Nbat=vars(4);
    wgs84data;
    global Rad RE
    
    % -------------------------------------------------------------------------
    % Battery and Cell Type decision
    % -------------------------------------------------------------------------
    
    %cell type ('Si','GaAs','Multi')
    CellTypes={'GaAs','Si','Multi'};
    %battery type ('NiH2','NiCd')
    BatteryTypes={'NiH2','NiCd'};
    
    CellType=CellTypes(icell);
    BatteryType=BatteryTypes(ibat);
    
    % -------------------------------------------------------------------------
    % Model Inputs
    % -------------------------------------------------------------------------

    % orbits inputs
    Life             = params.lifetime;         % in years
    h                = params.h;                % in km

    % -------------------------------------------------------------------------
    % Subsystem power requirements
    % -------------------------------------------------------------------------

    P=params.payloadpower+params.commspower+params.obcpower+params.adcspower;%falta afegir thermal

    % -------------------------------------------------------------------------
    % Calculate Eclipse Time
    % -------------------------------------------------------------------------

    % Calculate time in daylight and eclipse

    period = 1.658669e-4*(RE+h)^1.5; % in minutes
    rho = asin(RE/(RE+h));%angular radius of earth
    Bs  = 25*Rad; %angle of the sun above the orbit plane
    phi = 2*acos(cos(rho)/cos(Bs));
    Te  = period*(phi/(2*pi));
    Td  = period - Te;

    % -------------------------------------------------------------------------
    % Total Power Requirements
    % -------------------------------------------------------------------------

    % Calculate power requirements during daylight and eclipse

    Pd = P;
    pp = 0.2; % Power consumed by the EPS = 20% of total power: SMAD page 334
    Pp = Pd*pp;
    Pe = Pd + Pp;

    % -------------------------------------------------------------------------
    % Size solar arrays
    % -------------------------------------------------------------------------
    % Determine path efficiencies
    Xd  = .8;
    Xe  = .6;

    % First estimate how much power solar arrays must produce
    Psamin = (Pe*Te/Xe + Pd*Td/Xd)/Td;

    % Select type of solar cell and estimate size (for normal sun
    % angle)

    if strcmp(CellType,'Multi')
        theta=23.5; %worst case sun angle
        Pbol = 301*.77*cos(theta*Rad);
        Ld   = (1-.005)^Life;
        Peol = Pbol*Ld;
        Psa = Peol*Asa;
    elseif strcmp(CellType,'Si')
        theta=23.5; %worst case sun angle
        Pbol = 202*.77*cos(theta*Rad);
        Ld   = (1-.0375)^Life;
        Peol = Pbol*Ld;
        Psa = Peol*Asa;
    elseif strcmp(CellType,'GaAs')
        theta=23.5; %worst case sun angle
        Pbol = 253*.77*cos(theta*Rad);
        Ld   = (1-.0275)^Life;
        Peol = Pbol*Ld;
        Psa = Peol*Asa;
    end


    % -------------------------------------------------------------------------
    % Size batteries
    % -------------------------------------------------------------------------

    if strcmp(BatteryType,'NiH2')
        DoD = .5; %NiH2 DoD between 40% and 60
        n = .9;
        Cr = Pe*(Te/60)/(DoD*Nbat*n);
        Mbatt = Cr/45;
        density=2956;%this is NiCd density (need to find one for NiH2)
        volume=Mbatt/density;
        dimbat=nthroot(volume,3);
    elseif strcmp(BatteryType,'NiCd')
        DoD = .15; %NiCd DoD between 10% and 20%
        n = .9;
        Cr = Pe*(Te/60)/(DoD*Nbat*n);
        Mbatt = Cr/35;
        density=2956;%kg/m^3
        volume=Mbatt/density;
        dimbat=nthroot(volume,3);
    end

    % -------------------------------------------------------------------------
    % Mass Estimates
    % -------------------------------------------------------------------------
    Msa = .04*Psa;  % for planar array(0.04*Psa*4 for omnidirectional body mounted and 0.04*Psa*pi for cylindrical body-mounted)
    Asai=Asa/2; %we'll have two solar panels
    L=sqrt(3*Asai);
    W=L/3; %we suppose a square solar array
    aspectfactor=20; %aspect factor= W/h
    H=W/aspectfactor;
    Mpcu = .02*Psa;%power control unit
    Mregconv=0.025*Psa;%regulator/converter
    Mwiring=(0.01+0.04)/2*params.drymass;
    
    %Outputs for Structures (Anjit)
    
    components(1) = struct('Name','Solar Panel','Subsystem','EPS','Shape','Rectangle','Mass',Msa/2,'Dim',[L,W,H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    components(2) = struct('Name','Solar Panel','Subsystem','EPS','Shape','Rectangle','Mass',Msa/2,'Dim',[L,W,H],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    components(3) = struct('Name','Battery','Subsystem','EPS','Shape','Rectangle','Mass',Mbatt,'Dim',[dimbat,dimbat,dimbat],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    components(4) = struct('Name','Wiring','Subsystem','EPS','Shape','Rectangle','Mass',Mpcu+Mregconv+Mwiring,'Dim',[dimbat,dimbat,dimbat],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);

    power.mass = Msa + Mbatt + Mpcu + Mregconv + Mwiring;  % in kg
    power.solararraymass=Msa;
    power.solararraypower = Psa;
    
    %penalty if solar array does not meet the power requirements
    %(unfeasible solution--> Super high Cost)
    
    if Psa<Psamin
        power.cost=1e10;
    else
        power.cost= (62.7*power.mass+112*power.mass^.763);
    end
end