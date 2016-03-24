function sat_plotNOK(sat_ok)

len = length(sat_ok);
vec_cost = zeros(len);
vec_MRT = zeros(len);

for i = 1:len
    %vec_cost(i) = sat_ok(i).Cost;
    %vec_MRT(i)  = sat_ok(i).ResponseTimeMean;
    if ischar(sat_ok(i).Cost)
        disp(['Cost = [] for i = ', i]);
    end
    if ischar(sat_ok(i).ResponseTimeMean)
        disp(['RT = [] for i = ', i]);
    end
end

%plot (vec_MRT,vec_cost);