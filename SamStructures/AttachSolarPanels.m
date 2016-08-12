function [stowed,deploy] = AttachSolarPanels(panel,structure,dim,s)
% Processes the attachment of the solar panels onto the +X and -X sides of
% the structure. If the solar panels are larger than the structure panels,
% then initiate deployable solar panels. If not, then cover both sides with
% solar panels. 

% In stowed config, the solar panels stack on top of each other. In
% deployed config, the solar panels will be displayed as folding
% components. 

theta = pi/3;   %define angle between deployed solar panels

L = dim(1);
W = dim(2);
H = dim(3);

% stowed = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
%     ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);
% deploy = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
%     ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
%     ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame',[]);

% NEED TO FIND MASS TO VOLUME CONVERSION?

panel_A = panel.Dim(1)*panel.Dim(2);
panel_t = panel.Dim(3);
avail_A = structure.Surface(1).availableA;
count = ceil(panel_A/avail_A);
if s == 1
    T = 0;
    for i = 1:count
        stowed(i) = panel;
        stowed(i).Mass = panel.Mass/count;
        stowed(i).Dim(1) = structure.Dim(1);
        stowed(i).Dim(2) = structure.Dim(3);

        bottomVert = [L/2+T,W/2,0; L/2+T+panel_t,W/2,0; 
            L/2+panel_t+T,-W/2,0; L/2+T,-W/2,0]; 
        topVert = [L/2+T,W/2,H; L/2+T+panel_t,W/2,H; 
            L/2+panel_t+T,-W/2,H; L/2+T,-W/2,H]; 

        stowed(i).Vertices = [bottomVert; topVert];
        stowed(i).CG_XYZ = [(L+panel_t+2*T)/2,0,H/2];
        T = T + panel_t;
    end
    deploy(1) = stowed(1);
    
    if count >= 2
        P = 0;
        for l = 2:count
            deploy(l) = panel;
            deploy(l).Mass = panel.Mass/count;
            deploy(l).Dim(1) = structure.Dim(1);
            deploy(l).Dim(2) = structure.Dim(3);
            
            L1 = L/2+panel_t;              H1 = 0;
            L2 = L1-panel_t*cos(theta);      H2 = -panel_t*sin(theta);
            L3 = L2+H*sin(theta);            H3 = H2-H*cos(theta);
            L4 = L3+panel_t*cos(theta);      H4 = H3+panel_t*sin(theta);
            %These make up the positions of the 8 vertices that will make
            %up the first deployed solar panel where its angle to the
            %body mounted panel is defined as rad. 
            
            topVert = [L1,W/2+P,H1; L2,W/2+P,H2; 
                L2,-W/2+P,H2; L1,-W/2+P,H1]; 
            bottomVert = [L3,W/2+P,H3; L4,W/2+P,H4; 
                L4,-W/2+P,H4; L3,-W/2+P,H3]; 
            deploy(l).Vertices = [bottomVert; topVert];
            deploy(l).CG_XYZ = [(L1+L3)/2,P,(H1+H3)/2];
            phi = pi/2 - theta;
            deploy(l).RotateToSatBodyFrame = [cos(phi),0,sin(phi);0,1,0;-sin(phi),0,cos(phi)];
            P = P+W;
        end
    end
elseif s == 2
    T = 0;
    for k = 1:count
        stowed(k) = panel;
        stowed(k).Mass = panel.Mass/count;
        stowed(k).Dim(1) = structure.Dim(1);
        stowed(k).Dim(2) = structure.Dim(3);

        bottomVert = [-L/2-T,W/2,0; -(L/2+panel_t+T),W/2,0; 
            -(L/2+panel_t+T),-W/2,0; -L/2-T,-W/2,0]; 
        topVert = [-(L/2+T),W/2,H; -(L/2+T+panel_t),W/2,H; 
            -(L/2+panel_t+T),-W/2,H; -(L/2+T),-W/2,H]; 

        stowed(k).Vertices = [bottomVert; topVert];
        stowed(k).CG_XYZ = [-(L+panel_t+2*T)/2,0,H/2];
        T = T + panel_t; 
    end
    deploy(1) = stowed(1);
    
    if count >= 2
        P = 0;
        for l = 2:count
            deploy(l) = panel;
            deploy(l).Mass = panel.Mass/count;
            deploy(l).Dim(1) = structure.Dim(1);
            deploy(l).Dim(2) = structure.Dim(3);
            
            L1 = L/2+panel_t;              H1 = 0;
            L2 = L1-panel_t*cos(theta);      H2 = -panel_t*sin(theta);
            L3 = L2+H*sin(theta);            H3 = H2-H*cos(theta);
            L4 = L3+panel_t*cos(theta);      H4 = H3+panel_t*sin(theta);
            %These make up the positions of the 8 vertices that will make
            %up the first deployed solar panel where its angle to the
            %body mounted panel is defined as rad. 
            
            topVert = [-L1,W/2+P,H1; -L2,W/2+P,H2; 
                -L2,-W/2+P,H2; -L1,-W/2+P,H1]; 
            bottomVert = [-L3,W/2+P,H3; -L4,W/2+P,H4; 
                -L4,-W/2+P,H4; -L3,-W/2+P,H3]; 
            deploy(l).Vertices = [bottomVert; topVert];
            deploy(l).CG_XYZ = [-(L1+L3)/2,P,(H1+H3)/2];
            phi = pi/2 + theta;
            deploy(l).RotateToSatBodyFrame = [cos(phi),0,sin(phi);0,1,0;-sin(phi),0,cos(phi)];
            P = P-W;
        end
    end
    
    
end
    
end