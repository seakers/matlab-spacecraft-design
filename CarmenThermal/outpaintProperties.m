function outpaint=outpaintProperties
%assume using Z93 white paint. information from Spacecraft Thermal Control
%Handbook pg.144 and http://www.aztechnology.com/materials-coatings-az-93.html
outpaint.emittance=0.91;
outpaint.absorptance=0.15;
outpaint.thickness=0.0127*10^(-3); %[m] or 5 [mils]
outpaint.price=50; %[dollar/kg] lakcing real information this is a made up price
outpaint.density=1000; %[kg/m3], taken from regular paint density
end