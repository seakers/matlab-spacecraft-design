function [totalI,rCM,totalMass] = ParallelAxis(m1,m2,r1,r2,I1,I2)
% A function that uses the parallel axis theorum to compute the total
% moment of inertia for two bodies with known center of gravity, Principal
% Moments of Inertia, and mass.
[rCM,totalMass] = CenterOfMass(m1,m2,r1,r2);
totalI = I1 + I2 - m1*CrossMatrix(r1-rCM)*CrossMatrix(r1-rCM) - m2*CrossMatrix(r2-rCM)*CrossMatrix(r2-rCM);


function [rCM,totalMass] = CenterOfMass(m1,m2,r1,r2)
% Given the mass and position relative to a body frame, this calculates the
% total mass of the system and the new center of gravity.
totalMass = m1 + m2;
rCM = (m1.*r1+m2.*r2)./totalMass;


function rCrossMat = CrossMatrix(r)
% A function that calculates the matrix that results in cross product
% multiplication.

rCrossMat = [0, -r(3), r(2);
        r(3), 0, -r(1);
        -r(2), r(1), 0];