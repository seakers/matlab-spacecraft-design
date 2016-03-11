function [AE, params] = Anjit_init()    
    javaaddpath('.\java\jess.jar');
    javaaddpath('.\java\jxl.jar');
    javaaddpath('./java/combinatoricslib-2.0.jar');
    javaaddpath('./java/commons-lang3-3.1.jar');
    javaaddpath('./java/matlabcontrol-4.0.0.jar');
    javaaddpath( '.\java\EOSS.jar' );
    import rbsa.eoss.*
    import rbsa.eoss.local.*
    import java.io.*;
%     params = Params('C:\Users\Ana-Dani\Dropbox\Nozomi - Dani\RBES SMAP for IEEEAero14','CRISP-ATTRIBUTES','test','normal','');%C:\\Users\\Ana-Dani\\Dropbox\\EOCubesats\\RBES_Cubesats7" OR C:\\Users\\dani\\My Documents\\My Dropbox\\EOCubesats\\RBES_Cubesats7
    params = Params([filesep,'Users',filesep,'IcyHotFrancis',filesep,'Dropbox',filesep,'RBES_EOSS_Spandan',filesep,'RBES_EOSS'],'CRISP-ATTRIBUTES','test','normal','');%C:\\Users\\Ana-Dani\\Dropbox\\EOCubesats\\RBES_Cubesats7" OR C:\\Users\\dani\\My Documents\\My Dropbox\\EOCubesats\\RBES_Cubesats7
%     params = Params('C:\Users\Nozomi\Dropbox\Nozomi - Dani\RBES SMAP for IEEEAero14','CRISP-ATTRIBUTES','test','normal','');
    AE = ArchitectureEvaluator.getInstance;
    AE.init(1);
end
