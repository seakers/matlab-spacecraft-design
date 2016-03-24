% Plots the dependence of the MF disturbance torque with the orbit altitude
initConstants;

%Input parameters
D = [0,0.5,1,1.5,2];


%X Variable: altitude
h = 1000*[100:10:1000];
R = RE+h;

Tm1 = MFDisturbanceTorque (D(1),R)
Tm2 = MFDisturbanceTorque (D(2),R)
Tm3 = MFDisturbanceTorque (D(3),R)
Tm4 = MFDisturbanceTorque (D(4),R)
Tm5 = MFDisturbanceTorque (D(5),R)
plot(h./1000,Tm1,h./1000,Tm2,h./1000,Tm3,h./1000,Tm4,h./1000,Tm5);
title(['Magnetic Field DT vs orbit altitude for D= ',num2str(D)]);
xlabel(' Orbit altitude (km)');
ylabel(' MF Disturbance Torque (N*m)');
legend('D=0.0 Am2','D=0.5 Am2','D=1.0 Am2','D=1.5 Am2','D=2.0 Am2');
