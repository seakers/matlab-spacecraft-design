function [FaceColor,EdgeColor] = ColorSelection(Subsystem)
% Depending on which subsystem the part is located in, we choose different
% colors to plot them in.

if strcmp('Structures',Subsystem)
    % Grey faces with dark grey outlines
    FaceColor = [0.8,0.8,0.8];
    EdgeColor = [0.3,0.3,0.3];
    
elseif strcmp('Avionics',Subsystem)
    % Reddish colors
    FaceColor = [0.8,0.2,0.2];
    EdgeColor = [0.6,0,0.2];
    
elseif strcmp('ADCS',Subsystem)
    % Greenish colors
    FaceColor = [0.2,0.8,0.4];
    EdgeColor = [0.2,0.4,0.4];
    
elseif strcmp('Comms',Subsystem)
    % Purplish Colors
    FaceColor = [0.8,0.6,1];
    EdgeColor = [0.6,0.2,0.6];
    
elseif strcmp('Propulsion',Subsystem)
    % Orangeish Colors
    FaceColor = [0.8,0.6,0.4];
    EdgeColor = [0.8,0.2,0];
    
elseif strcmp('EPS',Subsystem)
    % Blueish colors
    FaceColor = [0.2,0.8,1];
    EdgeColor = [0,0.4,0.8]; 
    
elseif strcmp('Payload',Subsystem)
    % Turquoise colors
    FaceColor = [0,0.8,0.6];
    EdgeColor = [0,1,1];  
elseif strcmp('Thermal',Subsystem)
    % White face with black outline
    FaceColor = [1,1,1];
    EdgeColor = [0,0,0];      
end