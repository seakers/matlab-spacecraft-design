function rotateTester()
close all
h = 1;
w = 2;
l = 4;


xyzVertices = [-w/2 -l/2 -h/2; 
                -w/2 l/2 -h/2; 
                w/2 l/2 -h/2; 
                w/2 -l/2 -h/2; 
                -w/2 -l/2 h/2; 
                -w/2 l/2 h/2; 
                w/2 l/2 h/2; 
                w/2 -l/2 h/2];
figure()
myFaces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];
patch('Vertices', xyzVertices, 'Faces', myFaces,'FaceColor','g');
xlabel('x')
ylabel('y')
zlabel('z')
axis equal
[R,Rt]=euler2Rot(-pi/2,0,pi/2);

xyzVertices = (R*xyzVertices')';

    % A function that plots a rectangle of heigh (z axis) h, width (y axis) w,
    % and length (x axis) l
    % x, y, and z are the coordinates of the center of the rectangle.
figure()
patch('Vertices', xyzVertices, 'Faces', myFaces,'FaceColor','g');
xlabel('x')
ylabel('y')
zlabel('z')
axis equal