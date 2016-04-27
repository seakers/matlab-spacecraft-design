function [totalI,totalCM] = InertiaCalculator(components,structures)
% Might have to rotate bodies to make them in the same frame

totalCM = [0,0,0];
totalMass = 0;
totalI = zeros(3,3);
n1 = length(components);
n2 = length(structures);

for i = 1:n1
    % Compute the inertia matrix for the components
    if ~isempty(components(i).CG_XYZ )
        I = ComputingShapeInertia(components(i));
        components(i).InertiaMatrix = components(i).RotateToSatBodyFrame*I*components(i).RotateToSatBodyFrame';
        [totalI,totalCM,totalMass] = ParallelAxis(totalMass,components(i).Mass,totalCM,components(i).CG_XYZ,totalI,components(i).InertiaMatrix);  
    else
        fprintf([components(i).Name,' not added to satellite because it doesn''t fit\n'])
    end
end

for i = 1:n2
    % Compute the inertia matrix for the structures
    structures(i).InertiaMatrix = ComputingShapeInertia(structures(i));
    [totalI,totalCM,totalMass] = ParallelAxis(totalMass,structures(i).Mass,totalCM,structures(i).CG_XYZ,totalI,structures(i).InertiaMatrix);  
end


function I = ComputingShapeInertia(object)
% Computing the Inertia Tensor of a matrix based on the shape of the
% object.
if strcmp(object.Shape,'Rectangle')
   m = object.Mass;
   h = object.Dim(1);
   w = object.Dim(2);
   l = object.Dim(3);
   I = RectangleInertia(m,h,w,l);
elseif strcmp(object.Shape,'Sphere')
   m = object.Mass;
   R = object.Dim(1);   
   I = SphereInertia(m,R);
elseif strcmp(object.Shape,'Cylinder')
   m = object.Mass;
   h = object.Dim(1);
   R = object.Dim(2);
   I = CylinderInertia(m,R,h);
elseif strcmp(object.Shape,'Cylinder Hollow')
   m = object.Mass;
   h = object.Dim(1);
   R = object.Dim(2);
   t = object.Dim(3);
   I = CylinderHollowInertia(m,R,t,h);
end

function I = SphereInertia(m,R)
% Calculating the inertia tensor of a sphere

I1 = 2*m*R^2/5;
I = [I1,0,0;
    0,I1,0;
    0,0,I1];

function I = RectangleInertia(m,h,w,l)
% Check this to make sure that the width is actually correct
a = w;
b = h;
c = l;


I1 = m*(b^2 + a^2)/12;
I2 = m*(b^2 + c^2)/12;
I3 = m*(c^2 + a^2)/12;

I = [I1,0,0;
    0,I2,0;
    0,0,I3];

function I = CylinderInertia(m,R,h)
% Function that calculates the inertia tensor for a cylinder that is not
% hollow

I1 = m*(3*R^2 + h^2)/12;
I2 = m*R^2/2;

I = [I1,0,0;
    0,I1,0;
    0,0,I2];

function I = CylinderHollowInertia(m,R,t,h)
% Function that calculates the inertia tensor for a cylinder that is hollow

D1 = R*2;
D2 = (R-t)*2;


I1 = (1/4)*m*((D1^2+D2^2)/4 + h^2/3);
I2 = (1/8)*m*(D1^2 + D2^2);

I = [I1,0,0;
    0,I1,0;
    0,0,I2];