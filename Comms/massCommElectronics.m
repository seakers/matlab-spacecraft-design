function m = massCommElectronics(Ptx)
%model extracted from  Johannes Gross and Stephan Rudolph Modelling
%Satellite Design Languages

%mass=power*massFactor+baseMass
%power=powerAmplifier/efficency

%Transmitter:
%massFactor=0.008kg/W
%baseMass=0.5kg
% efficency=0.1
% 
% Amplifier(TWTA):
% massFactor=0.005kg/W
% baseMass=2kg
% efficency=0.7

powerTx=Ptx/0.1;
powerAmp=Ptx/0.7;

massTransmitter=powerTx*0.008+0.5;
massAmplifier=powerAmp*0.005+2;

m=massTransmitter+massAmplifier;
return