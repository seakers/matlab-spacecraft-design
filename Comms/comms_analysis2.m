function [comms,components]=comms_analysis2(params,vars)

Gtx=vars(1);
P_tx=vars(2);
%params to include maybe(ngs)

comms.cost=3000e4;
Cost=comms.cost;
k = 1.38e-23;
optfound=false;
comms.mass=0;
comms.power=0;
comms.frequency=0;
comms.modulation=0;
comms.antennaType='';

%DATA INFORMATION
if strcmp(params.GS,'NEN')
    igs=1;
    ContactTimePerDayTotal=0;
    NEN_DL=cell(params.ngs,17);
    NEN_UL=cell(params.ngs,11);
    while igs<=params.ngs
        info1=false;
        info2=false;
        nr=0;
        while ~info1 && nr<length(params.rawTime)
            nr=nr+1;
            if params.rawTime{nr,1}==params.inc && params.rawTime{nr,2}==params.h && strcmp(params.rawTime{nr,3},params.GS_name(igs))
                Naccessesday_GS_SAT_MAX=params.rawTime{nr,6};
                meanAccessTime=params.rawTime{nr,7};
                info1=true;
            end
        end
        nr=0;
        while ~info2 && nr<length(params.rawDL)
            nr=nr+1;
            if strcmp(params.rawDL{nr,1},params.GS_name(igs))
                NEN_DL(igs,:)=params.rawDL(nr,:);
                NEN_UL(igs,:)=params.rawUL(nr,:);
                info2=true;
            end
        end
        ContactTimePerDay=meanAccessTime*0.95*Naccessesday_GS_SAT_MAX; %Mean Contact Time per day
        ContactTimePerDayTotal=ContactTimePerDayTotal+ContactTimePerDay;
        igs=igs+1;
    end
    Software=100*220;%100KLOC @ 220$/LOC
    Equipment=0.81*Software;
    Facilities=0.18*Software;
    Mainteinance=0.1*(Software+Equipment+Facilities);%cost mainetinance/year
    ContractLabors=10*160000;%10 workers at 160k$/year
    CostGroundStations=((Mainteinance+ContractLabors)*params.lifetime/1000)*params.ngs; %cost GS mainteinance for the whole mission
    Rb_DL=params.dataPerDay/ContactTimePerDayTotal; %data rate in the downlink Satellite-GroundStation [bps]
    Rb_UL=68e3; %64kbps(Telemetry) + 4kbps(Telecommand)
else
    params.dataPerDay=150e6*24*60*60;
    Rb_DL=params.dataPerDay/(24*60*60); %data rate in the downlink Satellite-GroundStation [bps]
    Rb_UL=68e3; %64kbps(Telemetry) + 4kbps(Telecommand)
end



for Band=1:4
    for MOD=1:4
        %MODULATION INFORMATION
        linkBudgetClosed=false;
        Nsymb=2^MOD;
        EspEff=log2(Nsymb)/(1+params.att);
        Rb_Max=EspEff*params.BW_NEN(Band);

        if Rb_DL<Rb_Max
            if strcmp(params.GS,'NEN')
                igs=1;
                if ~strcmp(NEN_DL{igs,Band+1},'NO')

                    f_DL=NEN_DL{igs,Band+1};
                    lambda = 3e8/f_DL;
                    G_GS=NEN_DL{igs,Band+5};%GroundStation Antenna Gain [dB]
                    Tgs=NEN_DL{igs,Band+13}; %Noise Temperature GS antenna [K]
                    EbN0_min=params.EbN0(MOD);
                    R = CalcRange(params.h,params.epsmin);
                    EbN0 = lin2dB(P_tx)+Gtx+G_GS+2*lin2dB(lambda/(4*pi*R))-lin2dB(k*Tgs*Rb_DL);
                    
                    if EbN0>EbN0_min
                        f_DL_GHz = f_DL/1E9;
                        Nchannels=params.BW_NEN(Band)/32e6;

                        if Gtx < 3 && Band==1
                            lambda=3e8/f_DL;
                            if Gtx<1.76
                                Ltx=0.1*lambda; %short dipole (gain 1.76dB)
                            elseif 1.76<Gtx && Gtx<2.15
                                Ltx=0.5*lambda; %dipole lambda/2 (gain 2.15dB)
                            elseif 2.15<Gtx && Gtx<5.2
                                Ltx=(5/4)*lambda;%dipole 5lambda/4 (gain of about 5.2dB)
                            end
                            AntennaType='Dipole';
                            massA_DL=0.05;
                            linkBudgetClosed=true;
                            
                        elseif (Gtx<9) && Band<3
                            er=6.8;
                            [W,L] = DimPatchAntenna(er,f_DL_GHz);
                            AntennaType='Patch';
                            massA_DL=patchMassFromDimensions(W,L);
                            linkBudgetClosed=true;
                            
%                          elseif (9<Gtx)&&(Gtx<15)
%                              lambda=3e8/f_DL;
%                              [N,D,S,pa,theta] = Gain2Helical(Gtx,f_DL_GHz);
%                              Nreal=ceil(N);
%                              massA_DL=helixMassFromDimensions(Nreal,D,S,pa,lambda);
%                              AntennaType='Helical';
%                              linkBudgetClosed=true;
                        else
                            Dtx=Gain2Diameter(Gtx,f_DL_GHz,0.6);
                            if (Dtx<4.5)&&(Dtx>0.3)
                                AntennaType='Parabolic';
                                linkBudgetClosed=true;
                            elseif Dtx<0.3
                                Dtx=0.3;
                                AntennaType='Parabolic';
                                linkBudgetClosed=true;
                            end
                            massA_DL=parabolicMassFromDiameter(Dtx);
                            F=0.5*Dtx;%F/D typically varies between 0.3 and 1
                            H=Dtx^2/(16*F);
                        end
                        if linkBudgetClosed
                            
                            %massA=(massA_DL)*params.Red + 0.01*structures.drymass;
                            massA=massA_DL;
                            massE=massCommElectronics(P_tx)*params.Red + 0.01*params.drymass;
                            
                            costAntenna=CostAntenna(massA,AntennaType);
                            costElectronics=CostCommElectronics(massE,Nchannels);
                            comms_cost_new=(costAntenna+costElectronics+CostGroundStations/1000);
                            
                            power_comms=comms_power(P_tx);
                            
                            if comms_cost_new<comms.cost
                                optfound=true;
                                comms.cost=comms_cost_new;
                                MassOpt=massA+massE;
                                MOD_opt=MOD;
                                f_OPT=Band;
                                AntennaTypeOPT=AntennaType;
                                power_comms_opt=power_comms;  
                                
                                %Outputs Anjit (Sizing Components)
                                %Filters/Diplexers --> SMAD
                                %Antenna (Dipole cubsatshop,Patch aspect ratio,parabolic aspect ratio)
                                %Electronics(mass function of Ptx and drymass, dimensions from excel
                                %database (still to be improved))

                                if Band==1
                                    massFiltersDiplexers=2;
                                    dimFiltersDiplexers=[0.300 0.150 0.060];
                                    massElectronics=massE;
                                    dimElectronics=[0.171,0.128,0.092];
                                    if strcmp(AntennaType,'Dipole')
                                        %Deployable Antenna System for CubeSats(CubesatShop)
                                        massAntenna=massA;
                                        dimAntenna=[0.098,0.098,0.007];
                                    elseif strcmp(AntennaType,'Patch')
                                        massAntenna=massA;
                                        dimAntenna=[L,W,0.1*max(W,L)];
                                    elseif strcmp(AntennaType,'Parabolic')
                                        massAntenna=massA;
                                        dimAntenna=[Dtx/2,H];
                                    end
                                elseif Band==2
                                    massFiltersDiplexers=2;
                                    dimFiltersDiplexers=[0.300 0.150 0.060];
                                    massElectronics=massE;
                                    dimElectronics=[0.140,0.330,0.070];
                                    if strcmp(AntennaType,'Dipole')
                                        massAntenna=massA;
                                        dimAntenna=[0.098,0.098,0.007];
                                    elseif strcmp(AntennaType,'Patch')
                                        massAntenna=massA;
                                        dimAntenna=[L,W,0.1*max(W,L)];
                                    elseif strcmp(AntennaType,'Parabolic')
                                        massAntenna=massA;
                                        dimAntenna=[Dtx/2,H];
                                    end
                                elseif Band==3
                                    massFiltersDiplexers=1.5;
                                    dimFiltersDiplexers=[0.220 0.100 0.040];
                                    massElectronics=massE;
                                    dimElectronics=[0.2,0.22,0.070];
                                    if strcmp(AntennaType,'Dipole')
                                        massAntenna=massA;
                                        dimAntenna=[0.098,0.098,0.007];
                                    elseif strcmp(AntennaType,'Patch')
                                        massAntenna=massA;
                                        dimAntenna=[L,W,0.1*max(W,L)];
                                    elseif strcmp(AntennaType,'Parabolic')
                                        massAntenna=massA;
                                        dimAntenna=[Dtx/2,H];
                                    end
                                else
                                    massFiltersDiplexers=1.2;
                                    dimFiltersDiplexers=[0.190 0.080 0.040];
                                    massElectronics=massE;
                                    dimElectronics=[0.17,0.340,0.090];
                                    if strcmp(AntennaType,'Dipole')
                                        massAntenna=massA;
                                        dimAntenna=[0.098,0.098,0.007];
                                    elseif strcmp(AntennaType,'Patch')
                                        massAntenna=massA;
                                        dimAntenna=[L,W,0.1*max(W,L)];
                                    elseif strcmp(AntennaType,'Parabolic')
                                        massAntenna=massA;
                                        dimAntenna=[Dtx/2,H];
                                    end
                                end
                            end
                        end
                        
                    end
                end

            elseif strcmp(params.GS,'TDRSS')

                f_DL=frequencies_TDRSS_return(Band);
                f_DL_GHz = f_DL/1E9;
                Nchannels=BW_TDRSS(Band)/32e6;

                if Gtx < 3
                    lambda=3e8/f_DL;
                    if Gtx<1.76
                        Ltx=0.1*lambda; %short dipole (gain 1.76dB)
                    elseif 1.76<Gtx && Gtx<2.15
                        Ltx=0.5*lambda; %dipole lambda/2 (gain 2.15dB)
                    elseif 2.15<Gtx && Gtx<5.2
                        Ltx=(5/4)*lambda;%dipole 5lambda/4 (gain of about 5.2dB)
                    end
                    AntennaType='Dipole';
                    massA_DL=dipoleMassFromDimensions();
                elseif (3<Gtx)&&(Gtx<9) 
                    er=6.8;
                    [W,L] = DimPatchAntenna(er,f_DL_GHz);
                    AntennaType='Patch';
                    massA_DL=patchMassFromDimensions(W,L);
                elseif (9<Gtx)&&(Gtx<15)
                    lambda=3e8/f_DL;
                    [N,D,S,pa,theta] = Gain2Helical(Gtx,f_DL_GHz);
                    Nreal=ceil(N);
                    massA_DL=helixMassFromDimensions(Nreal,D,S,pa,lambda);
                    AntennaType='Helical';
                else
                    Dtx=Gain2Diameter(Gtx,f_DL_GHz,0.6);
                    if (Dtx<5)&&(Dtx>0.3)
                        AntennaType='Parabolic';
                    elseif Dtx<0.3
                        Dtx=0.3;
                        AntennaType='Parabolic';
                    end
                    massA_DL=parabolicMassFromDiameter(Dtx);
                end
                massA=(massA_DL)*params.Red + 0.01*params.drymass;
                massE=massCommElectronics(P_tx)*params.Red + 0.01*params.drymass;
                costAntenna=CostAntenna(massA,AntennaType);
                costElectronics=CostCommElectronics(massE,Nchannels);

                comms_cost_new=costAntenna+costElectronics;
                
                if comms_cost_new<Cost
                    Cost=comms_cost_new;
                    MOD_opt=MOD;
                    f_OPT=Band;
                end
            end
            
        end      
    end 
end

if optfound
    %Outputs for Structures (Anjit)
    components(1) = struct('Name','Filters/Diplexers','Subsystem','Comms','Shape','Rectangle','Mass',massFiltersDiplexers,'Dim',dimFiltersDiplexers,'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    components(2) = struct('Name','Electronics/Wiring','Subsystem','Comms','Shape','Rectangle','Mass',massElectronics,'Dim',dimElectronics,'CG_XYZ',[],'Vertices',[],'LocationReq','Inside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    
    if strcmp(AntennaTypeOPT,'Parabolic')
        components(3) = struct('Name','Antenna','Subsystem','Comms','Shape','Cylinder','Mass',massAntenna,'Dim',dimAntenna,'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    else
        components(3) = struct('Name','Antenna','Subsystem','Comms','Shape','Rectangle','Mass',massAntenna,'Dim',dimAntenna,'CG_XYZ',[],'Vertices',[],'LocationReq','Outside','Orientation',[],'Thermal',[-40,100],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
    end
    
    comms.mass=MassOpt;
    comms.power=power_comms_opt;
    comms.frequency=f_OPT;
    comms.modulation=MOD_opt;
    comms.antennaType=AntennaTypeOPT;
end
end