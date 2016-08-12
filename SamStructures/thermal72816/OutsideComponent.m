function complist=OutsideComponent(complist,MLI,outpaint)
len=length(complist);
epsilon=outpaint.emittance;
sigma=5.67e-8;

for i=1:len
    
    if strcmp('Outside',complist(i).LocationReq)
        
        Qw=complist(i).HeatPower;
        
        dim=complist(i).Dim;
        
        if strcmp('Rectangle',complist(i).Shape)
            area=2*(dim(1)*dim(2)+dim(1)*dim(3)+dim(2)*dim(3));
        elseif strcmp('Cylinder',complist(i).Shape)
            area=0.5*pi*dim(1)^2+pi*dim(1)*dim(2);
        elseif strcmp('Sphere',complist(i).Shape)
            area=pi*dim(1)^2;
        end
        
        %Qcondheater=MLI.conductivity*area*(complist(i).Thermal(1)+273-x);
        %Qcondcooler=MLI*conductivity*area*(complist(i).Thermal(2)+273-x);
        %Qrad=0.3*sigma*epsilon*area*x^4;
       
        %find the x as the outpaint temperature, and thus find the heat out
        %from the conduction and insulation balance: if the heat out is
        %greater than heatpower of the component, that means the component
        %needs heater and the heater power needed is the difference between
        %conduction heat output of (T operation low- x) and heatpower of
        %the component. If conduction heat out is smaller than heatpower
        
       %same method if the conduction heat out is smaller than the
       %heatpower of the component, that means heat pipe is needed to take
       %the heat that the component cannot dissipate out to the radiator of
       %the satellite and the power needed of the heat pipe is the
       %difference between heatpower and conduction heat
        
        hotfun=@(x,a,b,c,d,e,f)a*b*(c-x)/d-0.3*e*f*b*x^4;
        a=MLI.conductivity;
        b=area;
        c=complist(i).Thermal(1)+273;
        d=MLI.thickness;
        e=sigma;
        f=epsilon;
        fun=@(x)hotfun(x,a,b,c,d,e,f);
        T=fzero(fun,1000);
        Qout=0.3*epsilon*sigma*area*T^4;
        if Qout>Qw
        complist(i).HeaterPower=Qout-Qw;
        end
        
        coldfun=@(x,a,b,c,d,e,f)a*b*(c-x)/d-0.3*e*f*b*x^4;
        a=MLI.conductivity;
        b=area;
        c=complist(i).Thermal(2)+273;
        d=MLI.thickness;
        e=sigma;
        f=epsilon;
        fun=@(x)coldfun(x,a,b,c,d,e,f);
        T=fzero(fun,1000);
        Qout=0.3*epsilon*sigma*area*T^4;
        if Qout<Qw
            complist(i).HeatPipePower=Qw-Qout;
        end
        
        %used a factor of 0.3 to account for the backload as well as the
        %solar input in the space environment
        %confirm with P.Selva if a cooler environment is needed.
        
        
        
        
    end
end