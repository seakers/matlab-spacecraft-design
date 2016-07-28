function filled_comp = FillStruct(inside_comp,dim)

% After creating the structural panels, this function fills the "box" with
% each component, given that the component dimensions are the same length
% and width as the structure. This function will over-simplify the entire
% configuration, but give a general approach of cubesat design where the
% components are stacked. This is practical if the components are made
% in-house, but can become impratical from ordering parts from
% manufacturers. 

% For reference, dim = [ L, W, H, init_t ]

% Sorts components placed inside in descending order such that the heaviest
% comps will be placed on the bottom first. 

filled_comp = struct('Name',[],'Subsystem',[],'Shape',[],'Mass',[]...
    ,'Dim',[],'CG_XYZ',[],'Vertices',[],'LocationReq',[]...
    ,'Orientation',[],'Thermal',[],'InertiaMatrix',[],'Volume',[]);

L = dim(1);     W = dim(2);     H = dim(3);     t = dim(4);
stackH = t;

for i = 1:length(inside_comp)
    filled_comp(i) = inside_comp(i);
    filled_comp(i).Dim(1) = L-2*t;
    filled_comp(i).Dim(2) = W-2*t;
    filled_comp(i).Dim(3) = inside_comp(i).Volume/((L-2*t)*(W-2*t));
    tempH = filled_comp(i).Dim(3);
    
    L1 = (L-t)/2;       W1 = (W-t)/2;
    L2 = -L1;           W2 = -W1;
    
    bottomVert = [L1,W1,stackH; L2,W1,stackH;
        L2,W2,stackH; L1,W2,stackH];
    topVert = [L1,W1,stackH+tempH; L2,W1,stackH+tempH;
        L2,W2,stackH+tempH; L1,W2,stackH+tempH];
    
    filled_comp(i).Vertices = [bottomVert; topVert];
    filled_comp(i).CG_XYZ = [0,0,(2*stackH+tempH)/2];
    stackH = stackH + tempH;
end
end