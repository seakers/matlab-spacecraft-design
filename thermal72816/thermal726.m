function [thermal,complist]=thermal726(x,y,z,H,complist)
%for the purpose of merging code into the main code on 7/14/16 meeting
%for faster result
Thigh=35;
Tlow=5;

powertotal=sum(cat(1,complist.Power));

%load the Comps list here as needed
%load the radiator location as needed.
Rlocation.x=0.375;
Rlocation.y=0.375;
Rlocation.z=0;


%infofunc should include xyz of the spacecraft, altitude and total power
infofunc.H=H;
infofunc.Thigh=Thigh;
infofunc.Tlow=Tlow;
infofunc.x=x;
infofunc.y=y;
infofunc.z=z;
infofunc.A=2*(x*y+x*z+y*z);
infofunc.pmax=powertotal;
infofunc.pmin=powertotal;
[Radiator]=ThermalEstimate(infofunc);
%there's radiator type, radiator area, radiator dimension, radiator louver
%angle, and radiator mass

%inside component's heatpipe, cooler and heater
MLI=MLIproperties;
inpaint=inpaintProperties;
[complist,thermal]=InsideComponent(complist,Tlow,Thigh,MLI,inpaint);



Heatpipe=HeatPipeProperties;
CHP=HeatPipeonComponents(complist,Rlocation,Heatpipe);
%radiator=Rplacement(R_conf,infofunc);

[complist,MLImass,MLIcost]=preMLI(complist,MLI,Thigh,Tlow,infofunc);
outpaint=outcoating(complist,infofunc,Radiator);
inpaint=incoating(complist);


thermal.mass=0.0607*9.5; %drymass assume to be 9.5


thermal.mass_cjf=outpaint.mass+inpaint.mass+MLImass+CHP.mass;
thermal.mass_wradiator=thermal.mass_cjf+Radiator.mass;
thermal.outpaintmass=outpaint.mass;
thermal.inpaintmass=inpaint.mass;
thermal.mlimass=MLImass;
thermal.radiatormass=Radiator.mass;
thermal.chpmass=CHP.mass;
thermal.cost=394*thermal.mass^(.635)+50.6*thermal.mass^.707;
%thermal.cost_cjf=outpaint.cost+inpaint.cost+CHP.cost+RHP.cost+MLIcost;
end