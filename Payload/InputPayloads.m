function [payload] = InputPayloads()
% Uploads GUI that will prompt user to input values for the instruments
% that will compile as the satellite payload. 

%Cornell University 
%Samuel Wu scw223

%Indexing the payload such that user can input multiple instruments
i = 1; 

%Iterating to account for multiple instrument as payload
RUN = 0;
while ~RUN

prompt = {'Instrument name:','Mass (kg):','Shape:','X dimension (m):'...
    ,'Y dimension (m):','Z dimension (m);','Data per day (bps):'...
    ,'Power (W):','Cost (thousands of $):','Pointing Accuracy (degrees)'};
dlg_title = 'Payload Parameters';
num_lines = 1;
defaultans = {'Payload','1','Rectangle','0.1','0.1','0.1','5e6','3','200','.5'};
input = inputdlg(prompt,dlg_title,num_lines,defaultans,'on');

%Takes user input and stores in payload variable
comp = struct('Name',input(1),'Subsystem','Payload','Shape',input(3),'Mass',str2double(input(2))...
    ,'Dim',[str2double(input(4)),str2double(input(5)),str2double(input(6))]...
    ,'CG_XYZ',[],'Vertices',[],'LocationReq','Specific','Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame', [],'HeatPower',str2double(input(8)));
payload.comp(i) = comp; 
payload.dataperday(i) = str2double(input(7))*86400; %convert from bps to bpd
payload.mass(i) = str2double(input(2));
payload.power(i) = str2double(input(8));
payload.cost(i) = str2double(input(9));
payload.pointacc(i) = str2double(input(10));

%Interactive GUI that prompts the user if they wish to add another
%instrument and input parameters 
choice = questdlg('Add another instrument to payload?','Input Payload','Yes','No','Yes');
switch choice 
    case 'Yes'
        i = i+1;
    case 'No'
        RUN = 1;
end
end
end