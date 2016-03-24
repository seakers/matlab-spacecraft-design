function V = OrbitVelocity(a,r)
% Calculates orbital velocity at distance r (m) from focus for an orbit:
% with semi-major axis a (m)
initConstants;
V=sqrt(muE*(2./r-1./a));