function access = stkComputeAccess(conid,path)
%% stkComputeAccess.m
% Computes access for a given Coverage Grid and a given Constellation using
% the CovAccess Connect function of STK.
% 
% access = stkComputeAccess(conid,path)
%
% 'path' - The path of the Coverage Definition Object
%
% Daniel Selva <dselva> 11/11/08

%% STK Call
call = ['CovAccess ' path ' Compute ' ''];
results = stkExec(conid, call);

access = results;
return
%% end of stkComputeAccess.m
