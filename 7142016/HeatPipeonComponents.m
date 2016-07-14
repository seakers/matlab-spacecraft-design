function CHP=HeatPipeonComponents(comps,Rlocation,HP)

%heatpipe evaporator and condenser ratio are arbitary
%after testing on www.thermacore.com with various dimension both evaporator
%and condenser with 40% total length seem fair under the diameter dimension
%restrictions
ratio_cds=0.4;
ratio_evprt=0.4;


pipelength=0;
len=length(comps);
%volume is for the purpose of modeling it as a thin plate for displaying in
%structure GUI -07/13/16
volume=0;
for i=1:len
    x=comps(i).CG_XYZ(1)-Rlocation.x;
    y=comps(i).CG_XYZ(2)-Rlocation.y;
    z=comps(i).CG_XYZ(3)-Rlocation.z;
    dis=min(sqrt((x+z)^2+y^2),sqrt((z+y)^2+x^2));
    %dis=min(sqrt((x+y)^2+z^2),sqrt((x+z)^2+y^2),sqrt((z+y)^2+x^2));
    pipelength=pipelength+dis;
    comps(i).HPlength=dis;
    
    if comps(i).Power<1
        comps(i).HPdiameter=0.003;
    elseif comps(i).Power>=1&&comps(i).Power<=10
        comps(i).HPdiameter=0.005;
    else
        comps(i).HPdiameter=0.01;
    end
    volume=volume+0.25*pi*comps(i).HPdiameter^2*dis;
end

CHP.length=pipelength;
CHP.mass=CHP.length*HP.density;
CHP.cost=CHP.length*HP.price;

CHP.cdslength=pipelength*ratio_cds;
CHP.evprtlength=pipelength*ratio_evprt;

CHP.plate_thickness=0.005;
CHP.plate_length=sqrt(volume/0.005);


end