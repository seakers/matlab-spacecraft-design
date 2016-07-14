function [RHP,R_conf]=HeatpipeonRadiator(R_conf,HP,target_eta)
%start with fin thickness 0.1mm and heat pipe spacing 30cm and iterate
%until fin effectiveness is around 1. This function outputs the radiator
%size and heat pipe diameter and spacing to finish up the preliminary
%design of radiators. 

%T_B as the temperature at fin base is assumed to be -87 celcius, 186K and
%T_S is the radiative sink temperature will be assumed as 21 celcius,
%294K. Take worn out white paint on aluminum as the properties of the
%radiator: epsilon=0.8 emissivity, alpha=0.6 absortion, k=205 thermal conductivity

t=0.00015; %[m]
L=0.4; %[m]
k=205;
epsilon=0.77;
T_S=186;
T_B=294;
theta=T_S/T_B;
sigma=5.6701*10^(-8);


effectiveness=0;
while effectiveness<target_eta
xi=sigma*L^2*T_B^3*(2*epsilon)/(k*t);

if xi<=0.2&&xi>=0.01
effectiveness=(1-1.125*xi+1.6*xi^2)*(1-theta^4);

elseif xi>0.2
    effectiveness=(-0.405*log10(xi)+0.532)*(1-theta^4);
end

L=L*0.99;
t=t*1.05;
end

R_conf.length=R_conf.length/effectiveness;
RHP.spacing=L;
RHP.finthickness=t;
RHP.amout=floor(R_conf.length/L);
RHP.length=RHP.amout*R_conf.width*0.8;
RHP.mass=RHP.length*HP.density;
RHP.cost= RHP.length*HP.price;

end