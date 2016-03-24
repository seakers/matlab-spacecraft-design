%script_multiaxis.m
sat = sat_compare('Altitude',[467,567,667],'MaxPointing',[20,25,30],'NPixCrosstrack',[1000,2000,3000]);
sat = sat_system(sat);
out = sat_plot(sat,'TotalNImagesDay','RevisitTimeMean');
