function [SA] = SurfaceAreaCalculator(height,length,width)
% Calculates the surface area of the satellite based on Height, Length, and
% Width.

SA = height*length*2 + width*length*2 + height*width*2;
