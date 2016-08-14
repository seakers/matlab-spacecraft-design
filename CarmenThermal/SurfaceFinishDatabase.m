function list=SurfaceFinishDatabase
i=1;
list(i).Name='8-mil quartz mirrors';
list(i).Absorptance=0.065;
list(i).Emittance=0.8;
list(i).Cost=6.5; %[dollar/m2] from http://www.quartzmirrorblanks.com/quartzblanks_11.html
list(i).Density=0.45; %[kg/m2] from website above
list(i).Durability=10;
list(i).Toughness=10;


i=i+1;
%there's no data found online about it's mass/density/cost so I assued it's
%the same as the first material 
list(i).Name='quartz mirrors(diffuse)';
list(i).Absorptance=0.11;
list(i).Emittance=0.8;
list(i).Cost=6.5; %[dollar/m2] 
list(i).Density=0.45; %[kg/m2] 
list(i).Durability=10;
list(i).Toughness=10;

i=i+1;
list(i).Name='2-mil silvered Teflon';
list(i).Absorptance=0.07;
list(i).Emittance=0.66;
list(i).Cost=5.5; %[dollar/m2] 
list(i).Density=0.4; %[kg/m2] 
list(i).Durability=8;
list(i).Toughness=5;

i=i+1;
list(i).Name='Chemglaze Z306';
list(i).Absorptance=0.95;
list(i).Emittance=0.89;
list(i).Cost=1.5; %[dollar/m2] 
list(i).Density=0.05; %[kg/m2] 
list(i).Durability=5;
list(i).Toughness=8;

i=i+1;
list(i).Name='Z93';
list(i).Absorptance=0.185;
list(i).Emittance=0.92;
list(i).Cost=1; %[dollar/m2] 
list(i).Density=0.01; %[kg/m2] 
list(i).Durability=4;
list(i).Toughness=9;

end