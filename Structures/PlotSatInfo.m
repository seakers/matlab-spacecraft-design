function PlotSatInfo(payload,comms,eps,avionics,thermal,structures)

mass = [payload.Mass,comms.mass,eps.mass,thermal.mass,avionics.Mass,structures.mass];
power = [payload.Power,comms.power,eps.power,thermal.power,avionics.Power];
% cost = [avionics.Cost/1000, comms.cost, power.cost, thermal.cost];

figure('units','normalized','position',[.1 .5 .7 .7])
subplot(2, 2, 2);
pie(mass);
legend('Payload','Comms','EPS','Thermal','Avionics','Structures')

subplot(2, 2, 4);
pie(power)
legend('Payload','Comms','EPS','Thermal','Avionics')

subplot(1, 2, 1);
PlotSatellite(structures.components,structures.structures)
