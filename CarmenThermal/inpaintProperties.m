function inpaint=inpaintProperties
%assume using Chemglaze Z306 black paint. Properties from Spacecraft
%Thermal Control Handbook pg.144 and http://www.spacematdb.com/spacemat/manudatasheets/Aeroglaze%20z306.pdf
inpaint.emittance=0.9;
inpaint.absorptance=0.95;
inpaint.thickness=0.0254*10^(-3); %[m] or 5 [mils]
inpaint.price=50; %[dollar/kg] lakcing real information this is a made up price
inpaint.density=1000; %[kg/m3], taken from regular paint density
end