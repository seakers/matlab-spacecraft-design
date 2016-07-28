function material =  MaterialTable()
% Prices were taken from Alibaba as an average of the cost.
% SHOULD BE REVISED

i = 1;
material(i).Name = 'Aluminum 2219-T851'; % Material name
material(i).Density = 2.85*10^3; % kg/m^3
material(i).F_ult = 420*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 320*10^6; % N/m^2, Compressive yield stress
material(i).E = 72*10^9; % N/m^2, Young's Modulus
material(i).Cost = 2.75; % $/kg
i = i+1;


material(i).Name = 'Aluminum 6061-T6';
material(i).Density = 2.71*10^3; % kg/m^3
material(i).F_ult = 290*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 240*10^6; % N/m^2, Compressive yield stress
material(i).E = 68*10^9; % N/m^2, Young's Modulus
material(i).Cost = 1.4; % $/kg
i = i+1;

material(i).Name = 'Aluminum 7075-T73';
material(i).Density = 2.80*10^3; % kg/m^3
material(i).F_ult = 460*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 380*10^6; % N/m^2, Compressive yield stress
material(i).E = 71*10^9; % N/m^2, Young's Modulus
material(i).Cost = 2.98; % $/kg
i = i+1;

material(i).Name = 'Steel 17-4PH H1150z';
material(i).Density = 7.86*10^3; % kg/m^3
material(i).F_ult = 860*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 620*10^6; % N/m^2, Compressive yield stress
material(i).E = 196*10^9; % N/m^2, Young's Modulus
material(i).Cost = 1.4; % $/kg
i = i+1;

material(i).Name = 'Carbon Fiber';
material(i).Density = 1.60*10^3; % kg/m^3
material(i).F_ult = 600*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 570*10^6; % N/m^2, Compressive yield stress
material(i).E = 70*10^9; % N/m^2, Young's Modulus
material(i).Cost = 7.25; % $/kg
i = i+1;


material(i).Name = 'Magnesium AZ31B H24';
material(i).Density = 1.77*10^3; % kg/m^3
material(i).F_ult = 270*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 165*10^6; % N/m^2, Compressive yield stress
material(i).E = 45*10^9; % N/m^2, Young's Modulus
material(i).Cost = 20; % $/kg
i = i+1;

material(i).Name = 'Heat-Resistant Alloy A-286';
material(i).Density = 7.94*10^3; % kg/m^3
material(i).F_ult = 970*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 660*10^6; % N/m^2, Compressive yield stress
material(i).E = 201*10^9; % N/m^2, Young's Modulus
material(i).Cost = 40; % $/kg
i = i+1;

material(i).Name = 'Titanium Ti-6Al-4V';
material(i).Density = 4.43*10^3; % kg/m^3
material(i).F_ult = 900*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 855*10^6; % N/m^2, Compressive yield stress
material(i).E = 110*10^9; % N/m^2, Young's Modulus
material(i).Cost = 25; % $/kg
i = i+1;

material(i).Name = 'Beryllium AMS 7906';
% This material is supposed to be toxic I believe
material(i).Density = 1.85*10^3; % kg/m^3
material(i).F_ult = 320*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 0; % N/m^2, Compressive yield stress
material(i).E = 290*10^9; % N/m^2, Young's Modulus
material(i).Cost = 50; % $/kg <- not sure about this price
i = i+1;

material(i).Name = 'Honeycomb';
% For now make an assumption about honeycomb panels. Find out how to make
% the structure analysis work afterwards
% 5 - 5.6 kg/m^2
material(i).Density = 80; % kg/m^3 %Density of honeycomb is a composite.
material(i).F_ult = 320*10^6; % N/m^2, Tensile Ultimate Stress
material(i).F_yield = 0; % N/m^2, Compressive yield stress
material(i).E = 290*10^9; % N/m^2, Young's Modulus
material(i).Cost = 40; % $/kg <- not sure about this price
% Thickness of aluminum is around 1mm,
% Thickness of core is around 50 mm. 
i = i+1;

