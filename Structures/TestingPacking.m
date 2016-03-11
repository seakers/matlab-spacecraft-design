function TestingPacking()


rectangleDim = rand(10,2);
rectangleMass = randsample(10,10,true,rectangleDim(:,1))*20;
rectangleDim = rectangleDim*.5;
rectangleMass = rand(10,1)*200;

% save('rectangleMass')
% save('rectangleDim')

% load('rectangleMass')
% load('rectangleDim')

% rectangleDim = [.3,.2;.1,.1;.1,.05;.1,.05;.05,.02;.06,.02];
% recta ngleDim = [.3,.2;.1,.1;.1,.05;.1,.05;];
% rectangleMass = [200;20;10;.5;1;1];
% rectangleMass = [200;20;10;.5];

tolerance = 0.025;

panelWidth = 0.5;

[rectangleXY,rectangleDim] = PackingAlgorithm(rectangleDim,rectangleMass,tolerance,panelWidth);
close all
hold on
for i = 1:size(rectangleXY,1)
    
    rectangle('position',[rectangleXY(i,1), rectangleXY(i,2), rectangleDim(i,1),rectangleDim(i,2)],'facecolor','g');
    text(rectangleXY(i,1),rectangleXY(i,2),num2str(i))
end
hold off

axis equal
