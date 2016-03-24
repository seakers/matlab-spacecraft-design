% Plots the dependence of the GG disturbance torque with the orbit altitude
initConstants;

%Input parameters
%As=3;
q1 = 0.2;
q2 = 0.4;
q3 = 0.6;
q4 = 0.8;
q5 = 1.0;
i = [0:1:360]; % minimum angle, max perturbation
cps_cg = 0.3;

%X Variable:
a = [0.5:0.1:2.0];
b = [0.5:0.1:2.0];
%As = a.*b;
As = 2.0;
Tsp1 = SPDisturbanceTorque (As, q1, i, cps_cg);
Tsp2 = SPDisturbanceTorque (As, q2, i, cps_cg);
Tsp3 = SPDisturbanceTorque (As, q3, i, cps_cg);
Tsp4 = SPDisturbanceTorque (As, q4, i, cps_cg);
Tsp5 = SPDisturbanceTorque (As, q5, i, cps_cg);

plot(i,Tsp1,i,Tsp2,i,Tsp3,i,Tsp4,i,Tsp5);
title(['Solar Pressure DT vs Sun Incidence Angle, q = 0.2, 0.4, 0.6, 0.8, 1.0', ', As = ',num2str(As),', cps-cg = ',num2str(cps_cg)]);
%xlabel(' Surface area (m^2)');
xlabel(' sun Incidence angle (deg)');
ylabel(' SP Disturbance Torque (N*m)');
legend('q = 0.2','q = 0.4','q = 0.6','q = 0.8','q = 1.0');

