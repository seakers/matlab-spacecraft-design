function [power,eff]=comms_power(Ptx)

eff=0.45-0.015*(Ptx-5);
if eff<0.45
    eff=0.45;
end

transceiver_power=Ptx*(1+1/eff);
antenna_power=0;
others_power=0; %filters, diplexers, etc


PeakPowerComm       = antenna_power+transceiver_power+others_power; % Peak when transmitting
AvgPowerComm        = 0+1+others_power; % Avg when not transmitting but ON
OffPowerComm        = others_power; % OFF when not transmitting and passive.

T_peak_comm = 0.15;
T_avg_comm  = 0.60;
T_off_comm  = 0.25;

power = T_peak_comm * PeakPowerComm + T_avg_comm * AvgPowerComm + T_off_comm * OffPowerComm;

end