h = 1000*[100:10:1000];
rho = Atmosphere(h)
plot(h./1000,rho);