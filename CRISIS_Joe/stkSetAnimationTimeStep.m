function stkSetAnimationTimeStep(conid,scenario_path,dt)
%       stkSetAnimationTimeStep.m
%       stkSetAnimationTimeStep(scenario_path,dt)
%       Sets the value of the animation time step from the scenario to dt
%       (dt in s)

call = ['SetAnimation ' scenario_path ' TimeStep ' num2str(dt)];
stkExec(conid,call);
return