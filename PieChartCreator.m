function PieChartCreator(payload,comms,power,avionics,thermal,structures)


mass = [payload.Mass,comms.mass,power.mass,thermal.mass,avionics.Mass,structures.Mass];
pie(mass);
legend('Payload','Comms','EPS','Thermal','Avionics','Structures')