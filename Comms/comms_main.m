%% Inputs
function [comms]=comms_main(drymass,dataperday,h,inc,lifetime)
%GS: Ground station type ('NEN', 'TDRSS', 'MOBILE')
paramscomms.GS='NEN';

%GS_name: Ground station names ('Wallops', 'WhiteSands', 'McMurdo','Solna')
paramscomms.ngs=1;
paramscomms.GS_name={'Wallops','WhiteSands','Solna'};
[num,txt,rawTime]=xlsread('NEN_contacts_duration.xlsx',2,'B6:H85');
[num1,txt1,rawDL]=xlsread('NEN_contacts_duration.xlsx',2,'J6:Z9');
[num2,txt2,rawUL]=xlsread('NEN_contacts_duration.xlsx',2,'J14:T17');
paramscomms.rawTime=rawTime;
paramscomms.rawDL=rawDL;
paramscomms.rawUL=rawUL;

%ORBIT
paramscomms.h=h; %altitude [km] (400,500,600,800)
paramscomms.inc=inc; %inclination [degrees] (30,51.6,75,100[which means SSO])
paramscomms.lifetime=lifetime;
paramscomms.epsmin              =  10; % GroundAntennaMinElevationAngle in deg

%Payload
% X=15;
% Accesses=7;
% photodata=3e9; %necessary memory[bits]to store a 4-band image of 15x15km and 1m resolution and 12 bits per pixel assuming a Compressionfactor of 8
% nphotosperday=X*Accesses; %number of photos that we want to download per day (X photos per access * NaccessesDay)
% paramscomms.dataPerDay=photodata*nphotosperday;
paramscomms.dataPerDay=dataperday;%maxim 20e12 pero llavors necessitem Rb=8Gbits/s i el comms subsystem nomes suporta fins a 4.8Gbits/s
paramscomms.drymass=drymass;


%Redundancy level
paramscomms.Red=2;

%LINK MODULATION INFORMATION
paramscomms.EbN0=[10.6 10.6 14 18.3]; %Eb/N0 necessary to achieve a good communication for BER=10e-6 and M=2,4,8,16 (M-PSK)
paramscomms.Margin=3;

paramscomms.att=0.25; %filter attenuation

%Initializations
paramscomms.bands_NEN={'UHF','Sband','Xband','Kaband'};
paramscomms.BW_NEN=[137.825e6-137.175e6 2.29e9-2.2e9 8.175e9-8.025e9 27e9-25.5e9];

paramscomms.bands_TDRSS={'Sband','Kuband','Kaband'};
paramscomms.BW_TDRSS=[2.29e9-2.2e9 15.1365e9-14.8e9 27e9-25.5e9];
paramscomms.frequencies_TDRSS_return=[2.2875e9 15.0034e9 26e9];
paramscomms.GainToNoise_TDRSS_return=[9.5 18.4 19.1];
paramscomms.Rb_TDRSS_return=[6e6 0.8*300e6 0.8*300e6];

paramscomms.frequencies_TDRSS_forward=[2.0718e9 13.775e9 23e9];
paramscomms.EIRP_TDRSS_forward=[43.6 46.5 56.2];

%%

%Optimization [CostSystem]=system_analysis(paramscomms,paramspower,Gt,Pt,Asa,ic,ib,nbat)

%myfunc=@(vars)cost_optim(params,vars);
%x = fmincon(myfunc,[10,10],[],[],[],[],[],[],@(vars)mycon(params,vars));

%myfunc=@(vars)cost_optim_new(params,vars);
%x = fmincon(myfunc,[10,10],[],[],[],[],[0 20],[0.1 50],[]);

options = gaoptimset('display','off');
[x,~]=ga(@(x)comms_analysis(paramscomms,x),2,[],[],[],[],[0 0.1],[20 30],[],options);
[comms,components]=comms_analysis2(paramscomms,x);
comms.comp = components;

end