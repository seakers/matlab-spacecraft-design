function outpaint=outcoating(Comps,infofunc,Radiator)
%assume using Z93 white paint. information from Spacecraft Thermal Control
%Handbook pg.144 and http://www.aztechnology.com/materials-coatings-az-93.html
%outpaint.emittance=0.91;
%outpaint.absorptance=0.15;
%outpaint.thickness=0.0127*10^(-3); %[m] or 5 [mils]
%outpaint.price=50; %[dollar/kg] lakcing real information this is a made up price
%outpaint.density=1000; %[kg/m3], taken from regular paint density

totalarea=0;
len=length(Comps);
for i=1:len
    if strcmp('Outside',Comps(i).LocationReq)
        dim=Comps(i).Dim;
        if strcmp('Rectangle',Comps(i).Shape)
            area=2*(dim(1)*dim(2)+dim(1)*dim(3)+dim(2)*dim(3));
            
        elseif strcmp('Cylinder',Comps(i).Shape)
            area=0.25*pi*dim(1)^2+pi*dim(1)*dim(2);
            
        elseif strcmp('Sphere',Comps(i).Shape)
            area=pi*dim(1)^2;
        end
        totalarea=totalarea+area;
    end
end

area_radiator=Radiator.width*Radiator.length*2*1.2; %paint both sides and include a factor 1.2 for the fin area
area_out=infofunc.A;
totalarea=totalarea+area_radiator+area_out;
outpaint.area=totalarea;
outpaint.mass=totalarea*outpaint.thickness*outpaint.density;
outpaint.cost=outpaint.mass*outpaint.price;

end