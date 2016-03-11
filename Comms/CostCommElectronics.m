function c = CostCommElectronics(mass,Nchannels)

% if mass>=14&&mass<=144
%     nrc = inflate(917*mass^0.7,1992,2015); %NON-RECURRING cost
%     rc=inflate(179*mass,1992,2015); %RECURRING cost
%     c=(nrc+rc);
% elseif mass>=160 && mass<=395
%     nrc = 339*mass+5127*Nchannels; %NON-RECURRING cost
%     rc=189*mass; %RECURRING cost
%     c=(nrc+rc);
% else
%     display('mass out of range in CER Communications Electronics');
% end


%this is to make sure we are inside the domain of the CER 
if mass<14*0.7
    mass=14*0.7;
elseif mass>144*1.25
    mass=144*1.25;
end

%Cost estimation

if mass>=14*0.7&&mass<=144*1.25
    c=917*mass^.7+179*mass;
end

return