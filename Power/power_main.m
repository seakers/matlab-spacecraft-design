%% Inputs
function [power]=power_main(h,lifetime,payloadpower,commspower,adcspower,obcpower,drymass)
    %Mission (payload, orbit)
    paramspower.h=h; %altitude [km] (400,500,600,800)
    paramspower.lifetime=lifetime;         % in years
    paramspower.payloadpower=payloadpower; %fins a 3000W

    %From Pau
    paramspower.commspower=commspower;
    paramspower.adcspower=adcspower;
    %From Zvonimir
    paramspower.obcpower=obcpower;
    %From Anjit
    paramspower.drymass=drymass;
    %%

    %Optimization [CostSystem]=system_analysis(paramscomms,paramspower,Gt,Pt,Asa,ic,ib,nbat)

    %myfunc=@(vars)cost_optim(params,vars);
    %x = fmincon(myfunc,[10,10],[],[],[],[],[],[],@(vars)mycon(params,vars));

    %myfunc=@(vars)cost_optim_new(params,vars);
    %x = fmincon(myfunc,[10,10],[],[],[],[],[0 20],[0.1 50],[]);

    %options = gaoptimset('display','off');
    [x,Cost]=ga(@(x)power_analysis(paramspower,x),4,[],[],[],[],[0.1 1 1 1],[100 3 2 5],[],[2,3,4]);
    [power,components]=power_analysis2(paramspower,x);
    power.comp = components;
end
