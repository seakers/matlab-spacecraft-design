function [radiator,R_conf,heater,power]=prethecal(infofunc,Thigh,Tlow)
%prethecal, as the preliminary thermal calculation function performs a
%thermal balance on the satellite with known dimension to find the worst
%case hot temperature and compare it with the operation hot limit to
%determine the radiator type as face mounted (radiator=0) or
%deployed(radiator=1). Then with operation high limit, the function returns
%the radiator area needed. Followed is a culcalation on the necessity of
%heaters on radiators with radiator area just found and operation low
%temeprature(heaters are not needed if heater=0). If heaters are needed,
%the assigned value on power equals the power the heaters will need on
%radiators to keep temperature above operation low limit.

radiator=0;
heater=0;
power=0;

%Below are the values needed for worst case hot temperature calculation
A=infofunc.A;   %A is the surface area of the satellite [m2], used for radiation area


Asun=infofunc.Asun;  %Asun is the max area of direct solar radiation


Air=infofunc.Air; %Air is the max area of earth thermal radiation


Aalb=infofunc.Aalb;%Aalb is the max area of earth reflected earth heat transfer


alpha=0.6; %infofunc.alpha; %alphasolar absorptivity of the sphere, first assume 0.6 as worn white paint


epsilon=0.8; %infofunc.epsilon; %IR emisivity of the sphere, first assume 0.8 as worn white paint


Gs=1367; %infofunc.Gs; %Gs is the solar constant, max value 1418 and min value 1326 for worst hot/cold calculation


qI=237; %infofunc.qI; %qI is the earth IR emission take 237+-21 from SMAD


H=infofunc.H;%H is the spacecraft orbit altitude;


Re=6371000; %infofunc.Re;%Re is the earth radius, 6371000 meters as the mean value


rho=arcsine(Re/(Re+H));


albedo=0.3; %infofunc.albedo; %in percentage how much heat is reflected off of earth surface, value from SMAD


Ka=0.664+0.521*rho-0.203*rho^2;


Qw=infofunc.Qw; %Qw is the electrical power dissipation from the spacecraft


theta=30; %infofunc.theta;%theta is the angle between the radiator normal and the solar vector, 30 degree is a pure assumption


sigma=5.67051*10^(-8); %sigma is the Stefan-Boltzmann's constant



%Thermal balance to get worst case hot temperature as T_wchot
T_wchot=((Gs*Asun*alpha+qI*Air*epsilon*sin(rho)^2+Gs*albedo*Aalb*alpha*Ka*sin(rho)^2+Qw)/(epsilon*sigma*A))^0.25;

%Compare worst case hot with high T limit to decide radiator type
if T_wchot>=Thigh
    radiator=1;
end

%Thermal balance to get the needed radiator area
R_area=(Gs*Asun*alpha+qI*Air*epsilon*sin(rho)^2+Gs*albedo*Aalb*alpha*Ka*sin(rho)^2+Qw)/(epsilon*sigma*Thigh^4);

%Thermal balance to get worst case cold temperature as T_wccold
T_wccold=((Gs*Asun*alpha*cos(theta)+Qw)/(epsilon*sigma*R_area))^0.25;

%Compare worst case cold with low T limit to decide if heater is needed on
if T_wccold<=Tlow
    heater=1;
    power=epsilon*sigma*R_area*lowT^4-Gs*Asun*alpha*cos(theta)-Qw;
end

%arbitrarylly set radiator configuration.
R_conf.width=infofunc.x;  %one of the side length of the correct side of the satellite
R_conf.length=ceil(R_area/R_confi.width);


end