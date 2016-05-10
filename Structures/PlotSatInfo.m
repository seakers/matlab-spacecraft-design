function PlotSatInfo(payload,comms,eps,avionics,thermal,structures, propulsion)

% Create the vectors containing the mass info
mass = [payload.mass,comms.mass,eps.mass,thermal.mass,avionics.Mass,structures.structuresMass,propulsion.mass];
mass_subsystemStrings = {'Payload','Comms','EPS','Thermal','Avionics','Structures','Propulsion'};

% Create the vectors containing the power info
power = [payload.power,comms.power,avionics.AvgPwr,propulsion.power];
power_subsystemStrings = {'Payload','Comms','Avionics','Propulsion'};

% Create the vectors containing the cost info
cost = [avionics.Cost/1000, comms.cost, eps.cost, thermal.cost,propulsion.cost];
cost_subsystemStrings = {'Avionics','Comms','EPS','Thermal','Propulsion'};

% Establish the figure
figure('units','normalized','outerposition',[0 0 1 1])

% Plot the Pie chart for the mass
subplot(2, 3, 2);
mass_subsystemStrings = PieChartPlotter(mass,mass_subsystemStrings,'Mass (kg)');
legend(mass_subsystemStrings)

subplot(2, 3, 3);
PieChartPlotter(power,power_subsystemStrings,'Power (W)')

subplot(2, 3, 5);
PieChartPlotter(cost,cost_subsystemStrings,'Cost (Thousands $)')

subplot(1, 3, 1);
PlotSatellite(structures.components,structures.structures)

% [FaceColor,EdgeColor] = ColorSelection(Subsystem);


% edit1 = str2num(char(get(hObject,'String')));
%  if ~isempty(edit1) && edit1>0
%      edit1 = ceil(edit1);
%      data = cell(edit1,4);
%      % convert the values matrix to a cell array
%      valuesAsCell = mat2cell(data);
%      % update the table
%      set(handles.uitable,'Data',valuesAsCell{:});
%  end
% hL = legend([line1,line2,line3,line4],{'Data Axes 1','Data Axes 2','Data Axes 3','Data Axes 4'});
% newPosition = [0.4 0.4 0.2 0.2];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);

function dataSubsystems = PieChartPlotter(data,dataSubsystems,dataTitle)

% sort the data from largest to smallest
[data,ind] = sort(data);
dataSubsystems = dataSubsystems(ind);

h = pie(data);
rotate(h,[0 0 1],270);
hp = findobj(h, 'Type', 'patch');
hText = findobj(h,'Type','text'); % text object handles


for i = 1:length(hp)
    [FaceColor,~] = ColorSelection(dataSubsystems(i));
    set(hp(i), 'FaceColor', FaceColor);
    percentValue = get(hText(i),'String'); % percent values
    str = num2str(data(i)); % strings
    combinedstrings = [str,' (',percentValue,')']; % strings and percent values
    set(hText(i),'String',combinedstrings)
end

title([dataTitle, ' Total: ',num2str(sum(data))])