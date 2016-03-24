nsats = [0:1:30];
TFU_cost = 10000;
RDT = 100000;
N = nsats;
S = [0.85 0.90 0.95 1.00];
B1 = 1-log(1/S(1))/log(2);
L1 = N.^B1;
Nunits_cost = TFU_cost.*L1;
Unit_cost1 = TFU_cost.*L1./N;
Cost = RDT + Nunits_cost;

B2 = 1-log(1/S(2))/log(2);
L2 = N.^B2;
Unit_cost2 = TFU_cost.*L2./N;

B3 = 1-log(1/S(3))/log(2);
L3 = N.^B3;
Unit_cost3 = TFU_cost.*L3./N;

B4 = 1-log(1/S(4))/log(2);
L4 = N.^B4;
Unit_cost4 = TFU_cost.*L4./N;

plot(nsats,Unit_cost1,nsats,Unit_cost2,nsats,Unit_cost3,nsats,Unit_cost4);
title('Learning curve');
xlabel('# of satellites');
ylabel('Cost for 1 sat (k$)');
axis([0 30 0 1.1E04]);
legend('S = 0.85','S = 0.90','S = 0.95','S = 1.00');