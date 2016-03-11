function x2 = inflate(x1,y1,y2)
persistent inflat_factors
% initialize
if isempty(inflat_factors)
    factors = [0.097	0.088	0.08	0.075	0.078	0.08	0.081	0.084	0.082	0.081	0.081	0.085	0.095	0.1	0.102	0.105	0.113	0.13	0.14	0.138	0.14	0.151	0.154	0.155	0.156	0.156	0.158	0.163	0.168	0.169	0.172	0.174	0.175	0.178	0.18	0.183	0.188	0.194	0.202	0.213	0.225	0.235	0.243	0.258 0.286	0.312	0.33	0.352	0.379	0.422	0.479	0.528	0.56	0.578	0.603	0.625	0.636	0.66	0.687	0.72	0.759	0.791	0.815	0.839	0.861	0.885	0.911	0.932	0.947	0.967	1	1.028	1.045	1.069	1.097	1.134	1.171	1.171	1.216	1.208	1.226	1.244	1.264	1.285	1.307	1.328	1.35	1.372	1.395	1.418];
    years = 1930:2019;
    inflat_factors = java.util.HashMap;
    for i = 1:length(years)
        inflat_factors.put(years(i),factors(i));
    end
end

% comes from Jess?

% check bounds
f1 = inflat_factors.get(y1);
f2 = inflat_factors.get(y2);
if isempty(f1) 
    error(['Year ' num2str(y1) ' is out of range']);
end
if isempty(f2) 
    error(['Year ' num2str(y2) ' is out of range']);
end

% inflate
tmp = x1/f1;%transform y1 -> 2000
x2 = tmp*f2;%transform 2000 -> y2

end
 