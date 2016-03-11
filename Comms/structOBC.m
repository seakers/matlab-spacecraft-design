% Creates a Struct array with estimated specifications for a satellite's
%  on-board computers, from the data downloaded per and redundancy

function obcs = structOBC(ddpd, redundancy)

        %  Units used:
        %     cost -- $
        %     power -- W
        %     mass -- kg
        %     dimensions -- m
        %     temperature -- C
        %     data -- B
        %     frequency -- Hz

        
      % Estimate program memory, RAM, and frequency -- based on SMAD 
      % tables, data downloaded per day, and margin of error (50%)
      
      MAR = 50;

      m = ddpd/300;
      
      progm = 176742.4;
      ram = 133324.8 + ddpd;
      freq = 1648.5 + 0.25*m;
      
      obc.Progm = (1 + MAR/100)*progm;
      obc.Ram = (1 + MAR/100)*ram;
      obc.Freq = (1 + MAR/100)*freq;
      
      obc.DDPD = ddpd;
      
      x = [1 log(progm) log(ram) log(freq)];
      
      
      % Estimate remaining parameters, based on existing cubesat OBCs
      
      obc.Cost = exp(dot([1.390067, 0.336528, 0.245416, -0.10272],x));

      obc.AvgPwr = exp(dot([-9.81788, 0.173328, 0.143292, 0.194043],x));
      
      obc.PeakPwr = 2*(obc.AvgPwr);
      
      
      obc.Mass = exp(dot([-1.04807, 0.169433, 0.186482, -0.00983],x))/1000;
      
       
      L = exp(dot([3.540926, -0.01921, -0.00858, 0.072602],x))/1000;
      
      W = exp(dot([2.763307, 0.091377, 0.053965, -0.02504],x))/1000;
      
      H = exp(dot([-3.92369, 0.297605, 0.230538, -0.09338],x))/1000;
   
      minTemp = -40;
      
      maxTemp = 85;

      
      obc.Dim = [L, W, H];
      
      obc.Thermal = [minTemp, maxTemp];
      
      
      % General information
      
      obc.Name = 'OBC';
      obc.Subsystem = 'Avionics';
      obc.Shape = 'Rectangle';
      obc.LocationReq = 'Inside';
      
      
      % Other
     
      obc.Vertices = [];
      obc.CG_XYZ = [];
      obc.Orientation = [];
      
      
      % Create array of redundant OBCs
      
      obcs = obc;
      
      i = 1;
      
      while i < redundancy
          obcs = [obcs obc];
          i = i + 1;
      end
      
end
      
      
