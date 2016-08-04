function sat_out = sat_adcs_cost_Joe(sat_in)

%Calculate cost of Full ADCS
mass_FullADCS = sat_in.MassADCS;
cost_FullADCS = .0516*mass_FullADCS + 6.7163; %not accurate at all

%Calculate cost of reaction wheel
mass_RW = sat_in.RWMass;
cost_RW = .0221*mass_RW + 1.8431;

%Calculate cost of sun sensor
mass_sun = sat_in.mass_sensor;
cost_sun = .2025*mass_sun + 2.002;

sat_out.cost_FullADCS = cost_FullADCS;
sat_out.cost_RW = cost_RW;
sat_out.cost_SunSensor = cost_sun;