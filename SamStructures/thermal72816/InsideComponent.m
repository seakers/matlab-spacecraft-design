function [complist,thermal]=InsideComponent(complist,Tlow,Thigh,MLI,inpaint)
len=length(complist);
epsilon=inpaint.emittance;
sigma=5.67*10^(-8);

for i=1:len
    
    
    %only consider the inside components of the satellite
    if strcmp('Inside',complist(i).LocationReq)
        
        %assume the power is the component's heat output
        Qw=complist(i).Power;
        %get the dimension and area of the component for further math
        dim=complist(i).Dim;
        if strcmp('Rectangle',complist(i).Shape)
            area=2*(dim(1)*dim(2)+dim(1)*dim(3)+dim(2)*dim(3));
        elseif strcmp('Cylinder',complist(i).Shape)
            area=0.5*pi*dim(1)^2+pi*dim(1)*dim(2);
        elseif strcmp('Sphere',complist(i).Shape)
            area=pi*dim(1)^2;
        end
        
        %for all the radiation output from the components, assume a 0.3
        %factor to account for the backload from radiation and conduction.
        
        %first determine if the components that operate in the T limits
        %need heat pipe
        if complist(i).Thermal(1)<Tlow&&complist(i).Thermal(2)>Thigh
            T=(Qw/(epsilon*sigma*area*0.3)+(Thigh+273)^4)^0.25-273;
            if T>complist(i).Thermal(2)
                Qout=0.3*sigma*epsilon*area*((complist(i).Thermal(2)+273)^4-(Thigh+273)^4);
                complist(i).HeatPipePower=abs(Qw-Qout);
            end             
        end
        
        
        
        %for the inside components that need cool down, find the power of
        %the cooling system by summing the heat transferred in the
        %conponent from the warmer satellite environment and the power of
        %the component itself.
        if complist(i).Thermal(2)<Thigh
            %Qcond=MLI.conductivity*area*(x-complist(i).Thermal(2)-273);
            %Qrad=0.3*sigma*epsilon*area*((Thigh+273)^4-x^4);
            hotfun=@(x,a,b,c,d,e,f)a*b*(x-c-273)-0.3*d*e*b*((f+273)^4-x^4);
            a=MLI.conductivity;
            b=area;
            c=complist(i).Thermal(2);
            d=sigma;
            e=epsilon;
            f=Thigh;
            fun=@(x)hotfun(x,a,b,c,d,e,f);
            T=fzero(fun,1000);
            complist(i).CoolerPower=Qw+sigma*epsilon*area*((Thigh+273)^4-T^4);
        end
        
        
        %for the inside components that need warm up, determine if MLI will
        %be enough or if extra heater is necessary
        if complist(i).Thermal(1)>Tlow
        %    Qcond=MLI.conductivity*area*((complist(i).Thermal(1)+273)-x);
        %    Qrad=0.3*sigma*epsilon*area*(x^4-(Tlow+273)^4);
            coldfun=@(x,a,b,c,d,e,f)a*b*(c+273-x)-0.3*d*e*b*(x^4-(f+273)^4);
            a=MLI.conductivity;
            b=area;
            c=complist(i).Thermal(1);
            d=sigma;
            e=epsilon;
            f=Tlow;
            fun=@(x)coldfun(x,a,b,c,d,e,f);
            T=fzero(fun,1000);
            Qout=sigma*epsilon*area*(T^4-(Tlow+273)^4);
            if Qw>Qout
                complist(i).HeatPipePower=abs(Qw-Qout);
            elseif Qw<Qout
                complist(i).HeaterPower=abs(Qw-Qout);
            end
        end
        
        
        
        
    end 
end

thermal.power=0;
%sum up the power from active heater and cooler
if isfield(complist,'CoolerPower')
    thermal.CoolerPower=sum(cat(1,complist.CoolerPower));
    thermal.power=thermal.CoolerPower+thermal.power;
end

if isfield(complist,'HeaterPower')
    thermal.HeaterPower=sum(cat(1,complist.HeaterPower));
    thermal.power=thermal.power+thermal.HeaterPower;
end





end