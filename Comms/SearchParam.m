    function value = SearchParam(param,Names,Values)
ind = 0;
for i = 1: length(Names)
    if strcmp(Names(i).name,param)
        ind = i;
        break;
    end
end
if ind == 0
    value = -1;
    if ((~strcmp(param,'Gt')) && (~strcmp(param,'Gr')))
        disp(['Warning : Param not found ' param]);
    end
    return
end
value = Values(ind);
return