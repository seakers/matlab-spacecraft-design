function list=selection(list)
location=input('Where do you intend to use this coating on? (Outside please input 1 and Inside please input 2): ');
f1=input('On a scale of 1(do not care) to 5(really important), how does COST affect your decision: ');
f2=input('On a scale of 1(do not care) to 5(really important), how does DURABILITY affect your decision: ');
f3=input('On a scale of 1(do not care) to 5(really important), how does MASS affect your decision: ');
f4=input('On a scale of 1(do not care) to 5(really important), how does PERFECT THERMAL PROPERY affect your decision: ');
f5=input('On a scale of 1(do not care) to 5(really important), how does TEMPRETURE RESISTANCE affect your decision: ');


total=f1+f2+f3+f4+f5;
cost=f1/total;
dura=f2/total;
mass=f3/total;
prop=f4/total;
temp=f5/total;

ref_cost=min([list.Cost]);
ref_dura=max([list.Durability]);
ref_mass=min([list.Density]);
ref_abso_max=max([list.Absorptance]);
ref_abso_min=min([list.Absorptance]);
ref_emit_max=max([list.Emittance]);
%ref_emit_min=min(list.Emittance);
ref_temp=max([list.Toughness]);

len=size(list);
len=len(2);
for i=1:len
    perf_cost=(ref_cost/list(i).Cost)*cost;
    
    perf_dura=(list(i).Durability/ref_dura)*dura;
    
    perf_mass=(ref_mass/list(i).Density)*mass;
    
    if location==1
        alpha=(ref_abso_min/list(i).Absorptance);
        epsilon=(list(i).Emittance/ref_emit_max);
    else
        alpha=(list(i).Absorptance/ref_abso_max);
        epsilon=(list(i).Emittance/ref_emit_max);   
    end
    
    perf_prop=(alpha+epsilon)*prop/2;
    
    perf_temp=(list(i).Toughness/ref_temp)*temp;
    
    list(i).Performance=perf_cost+perf_dura+perf_mass+perf_prop+perf_temp;
    
end

[~,ind]=max([list.Performance]);
disp('Here is the best material option:');
disp(list(ind).Name);
    
