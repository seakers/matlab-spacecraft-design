function massA_DL=check_prova_helix(f_DL_GHz,Gtx)
f_DL=f_DL_GHz*1e9;
lambda=3e8/f_DL;
[N,D,S,pa,theta] = Gain2Helical(Gtx,f_DL_GHz);
Nreal=ceil(N);
massA_DL=helixMassFromDimensions(Nreal,D,S,pa,lambda);
end