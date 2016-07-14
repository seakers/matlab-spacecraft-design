function inpaint=incoating(Comps)
%assume using Chemglaze Z306 black paint. Properties from Spacecraft
%Thermal Control Handbook pg.144 and http://www.spacematdb.com/spacemat/manudatasheets/Aeroglaze%20z306.pdf
inpaint.emittance=0.9;
inpaint.absorptance=0.95;
inpaint.thickness=0.0254*10^(-3); %[m] or 5 [mils]
inpaint.price=50; %[dollar/kg] lakcing real information this is a made up price
inpaint.density=950; %[kg/m3], taken from regular paint density

totalarea=0;
len=length(Comps);
for i=1:len
    if strcmp('Outside',complist(i).LocationReq)
        dim=Comps(i).Dim;
        if strcmp('Rectangle',complist(i).Shape)
            area=2*(dim(1)*dim(2)+dim(1)*dim(3)+dim(2)*dim(3));
            
        elseif strcmp('Cylinder',complist(i).Shape)
            area=0.5*pi*dim(1)^2+pi*dim(1)*dim(2);
            
        elseif strcmp('Sphere',complist(i).Shape)
            area=pi*dim(1)^2;
        end
        totalarea=totalarea+area;
    end
end

inpaint.area=totalarea;
inpaint.mass=totalarea*inpaint.thickness*inpaint.density;
inpaint.cost=inpaint.mass*inpaint.price;

end