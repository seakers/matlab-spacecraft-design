function material =  MaterialTable()

i = 1;
material(i).Name = 'Aluminum 2219-T851'; % Material name
material(i).Density = 2.85*10^3; % kg/m^3
material(i).F_ult = 420*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 320*10^6; % N/m^2, Compressive yield stress
material(i).E = 72*10^9; % N/m^2, Young's Modulus
i = i+1;

material(i).Name = 'Aluminum 6061-T6';
i = i+1;

material(i).Name = 'Aluminum 2219-T851';
i = i+1;

material(i).Name = 'Steel 17-4PH H1150z';
i = i+1;

material(i).Name = 'Carbon Fiber';
i = i+1;

material(i).Name = 'Magnesium AZ31B H24';
i = i+1;

material(i).Name = 'Heat-Resistant Alloy A-286';
i = i+1;

material(i).Name = 'Titanium';
i = i+1;

material(i).Name = 'Beryllium';
i = i+1;


