function [Radiator]=ThermalEstimate(infofunc)
%this function assumes the worst conditions and perform rough estimation on
%satellite radiator dimension and the necessity of heater and louvers. 

%H is the altitude of the satellite [km]
H=infofunc.H;

%Re is the radius of earth [km]
Re=6378;

%rho is the angular radius of earth [rad]
rho=asin(Re/(Re+H));

%Ka is the albedo correction factor [ ]
Ka=0.664+0.521*rho-0.203*rho^2;

%maxqI is the max earth IR emission at surface [W/m2]
maxqI=258;

%minqI is the min earth IR emission at surface [W/m2]
minqI=216;

%Gs is the direct solar flux, took max value for worst hot [W/m2]
Gs=1418;

%a is the albedo factor of earth, took max value for worst hot
a=0.35;

%epsilon is the emissivity of the radiator surface, took white paint end
%of life
epsilon=0.8;

%alpha is the absorptivity of radiator surface, took white paint end of
%life
alpha=0.6;

%Thigh is the upper temperature limit [C]
Thigh=infofunc.Thigh+273;   %now in [K]

%Tlow is the lower temperature limit [C]
Tlow=infofunc.Tlow+273;     %now in [K]

%below are the satellite dimension in xyz [m]
x=infofunc.x;
y=infofunc.y;
z=infofunc.z;

%Amaxtake the biggest side area of the satellite to compute hot/cold case [m2]
Amax=max(max(x*y,x*z),y*z);

%A is the total surface area of the satellite [m2]
A=2*(x*y+x*z+y*z);

%pmax is the highest power consumption during coldest case [W]
pmax=infofunc.pmax;

%pmin is the lowest power consumption during coldest case [W]
pmin=infofunc.pmin;

%p is the constant power consumption for whenever cases [W]
%p=infofunc.p;

%sigma is the Stefan-Boltzmann's constant
sigma=5.67*10^(-8);

%Qsa is the direct solar radiation 
Qsa=Gs*Amax*alpha;

%Qir_h is the earth IR for worst case hot
Qir_h=maxqI*(sin(rho))^2*Amax*epsilon;

%Qir_c is the earth IR for worst case cold
Qir_c=minqI*(sin(rho))^2*Amax*epsilon;

%Qab is the albedo heat in
Qab=Gs*a*alpha*Amax*Ka*(sin(rho))^2;


%get worst case hot temperature as the satellite is a rectangle that's
%right in between sun and earth so solar vector and earth IR are all
%perpendicular to to opposite surface of the satellite
T_whot=((Qsa+Qir_h+Qab+pmin)/(epsilon*A*sigma))^0.25;


%if the entire surface area of the satellite is not enough to dissipate the
%worst case hot heat, will choose deployed radiator
if T_whot>=Thigh
    Radiator.type='deployed';   %deployed
else 
    Radiator.type='face-mount';   %face-mount
end

%get radiator area needed to maintain maintain equilibrium at temperature
%high limit
Radiator.area=(Qsa+Qir_h+Qab+pmin)/(epsilon*Thigh^4*sigma);

%when there's only earth IR and high power consumption, get worst case cold
%temperature
T_wcold=((Qir_c+pmax)/(epsilon*Radiator.area*sigma))^0.25;
ratio=((Qir_c+pmax)/(epsilon*sigma*Tlow^4))/Radiator.area;
Radiator.louverangle=acosd(1-ratio);


%find radiator worst hot/cold temperature assuming that satellite body is
%perfectly insulated and the only heat out source is the radiator
%Radiator.hot=((Qsa+Qir_h+Qab+pmin)/(epsilon*Radiator.area*sigma))^0.25-273;
%Radiator.cold=((Qir_c+pmax+Radiator.pheater)/(epsilon*Radiator.area*sigma))^0.25-273;

%set up radiator configuration
Radiator.width=max(max(x,y),z);
Radiator.length=0.5*Radiator.area/Radiator.width;
Radiator.T_wcold=T_wcold-273;
Radiator.T_whot=T_whot-273;

%assume radiator is sheet Alum with 2700 kg/m3 density and 1mm thickness
metalmass=Radiator.area*0.001*2700/2;

%assume louver is Vaspel with 1500 kg/m3 density and 1 mm thickness
louvermass=Radiator.area*0.001*1500;

Radiator.mass=metalmass+louvermass;




end
