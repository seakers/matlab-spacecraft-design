function antenna = AttachAntenna(outside_comp,dim)

l = outside_comp.Dim(1);
w = outside_comp.Dim(2);
t = outside_comp.Dim(3);

L = dim(1);
W = dim(2);
H = dim(3);
T = dim(4);

antenna = outside_comp;

bottomVert = [l/2,W/2,H-l; -l/2,W/2,H-l;
    -l/2,W/2+t,H-l; l/2,W/2+t,H-l];
topVert = [l/2,W/2,H; -l/2,W/2,H;
    -l/2,W/2+t,H; l/2,W/2+t,H];

antenna.Vertices = [bottomVert; topVert];
antenna.CG_XYZ = [0,(W+t)/2,(2*H-w)/2];


end

