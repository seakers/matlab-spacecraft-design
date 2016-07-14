function thermal=thermall71316%(Comps,x,y,z,H,power)
%for the purpose of merging code into the main code on 7/14/16 meeting

Thigh=35;
Tlow=5;
target_eta=0.8;

%load the Comps list here as needed


%infofunc should include xyz of the spacecraft, altitude and total power
%infofunc.A=2*(x*y+x*z+y*z);
%infofunc.Asun=max(x*y,x*z,y*z);
%infofunc.Air=infofunc.Asun;
%infofunc.Aalb=infofunc.Asun;
%H=infofunc.H;
[radiator,R_conf,heater,power]=prethecal(infofunc,Thigh,Tlow);
Heatpipe=HeatPipeProperties;
[Rheatpipe,R_conf]=HeatpipeonRadiator(R_conf,Heatpipe,target_eta);
CHP=HeatPipeonComponents(Comps,Rlocation,Heatpipe);
radiator=Rplacement(R_conf,infofuc);
MLI=MLIproperties;
[Comps,MLImass,MLIcost]=preMLI(Comps,MLI,Thigh,Tlow);
outpaint=outcoating(Comps,infofunc,R_conf);
inpaint=incoating(Comps);
thermal.mass=0.0607*drymass;
thermal.mass_cjf=outpaint.mass+inpaint.mass+MLImass+RHP.mass+CHP.mass;
thermal.cost=394*thermal.mass^(.635)+50.6*thermal.mass^.707;
end
