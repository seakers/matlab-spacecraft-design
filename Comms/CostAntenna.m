function c = CostAntenna(mass,AntennaType)
if strcmp(AntennaType,'Dipole')
    c=5000/1000;
elseif strcmp(AntennaType,'Patch')
    c=5000/1000;
else
    if (mass>=1*0.75) && (mass<=87*1.25)
        nrc = inflate(1015*mass^0.59,1992,2015); %NON-RECURRING cost
        rc=inflate(20+230*mass^0.59,1992,2015); %RECURRING cost
        c=(nrc+rc);
    else
        display('mass out of range in CER antenna');
    end
end
return