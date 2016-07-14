function [complist,MLImass,MLIcost]=preMLI(complist,MLI,Thigh,Tlow)%infofunc)
%preMLI is built for the preliminary estimation of the mass, cost and
%dimension update after all the components outside the spacecraft as well
%as the outersurface of the spacecraft is completely covered with MLI

MLImass=0;
MLIcost=0;
len=length(complist);
for i=1:len
    if strcmp('Outside',complist(i).LocationReq)||((strcmp('Inside',complist(i).LocationReq))&&(complist(i).Thermal(1)>=Tlow||complist(i).Thermal(2)<=Thigh))
        dim=complist(i).Dim;
        if strcmp('Rectangle',complist(i).Shape)
            area=2*(dim(1)*dim(2)+dim(1)*dim(3)+dim(2)*dim(3));
            
        elseif strcmp('Cylinder',complist(i).Shape)
            area=0.5*pi*dim(1)^2+pi*dim(1)*dim(2);
            
        elseif strcmp('Sphere',complist(i).Shape)
            area=pi*dim(1)^2;
        end
        MLImass=MLImass+area*MLI.rho;
        MLIcost=MLIcost+area*MLI.cost;
        complist(i).Dim=complist(i).Dim+MLI.thickness;
    end
    
    
end
%%include satellite surface area
MLImass=MLImass+infofunc.A*MLI.rho;
%MLIcost=MLIcost+infofunc.A*MLI.cost;
end

            
        

