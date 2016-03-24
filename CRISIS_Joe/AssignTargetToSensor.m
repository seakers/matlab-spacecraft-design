function AssignTargetToSensor(conid, sensor_path, targetsfile)

call = ['Point ' sensor_path ' Targeted File ' targetsfile];
stkExec(conid,call);

%call = ['Point ' sensor_path ' Targeted Tracking ' target_path];
%stkExec(conid,call);
return