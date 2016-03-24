function sat_out = sat_script(sat_in)

% for keeping track of the run
total = numel(sat_in);
counter = 1;

for i = 1:size(sat_in,1)
    for j = 1:size(sat_in,2)
        for k = 1:size(sat_in,3)
            for l = 1:size(sat_in,4)
                for m = 1:size(sat_in,5)
                    
                    temp = sat_in(i,j,k,l,m);
                    
                    % orbit dynamics model
                    %temp = sat_orbit(temp);
                    
                    % optical payload model
                    temp = sat_optics(temp);

                    % First STK module
                    %temp = sat_mini_stk(temp,conid);
                    
                    % ADCS model
                    %temp = sat_adcs(temp);
   
                    % OBDH model
                    %temp = sat_obdh(temp);
                    
                    % communications subsystem model
                    %temp = sat_comm(temp,conid);
                    
                    % STK simulation
                    %temp = sat_stk(temp,conid);

                    % thermal model
                    %temp = sat_thermal(temp);
                    
                    % propulsion model
                    %temp = sat_prop(temp);
                    
                    % power model
                    temp = sat_power(temp);
                    
                    % mass budget
                    temp = sat_mass(temp);
                    
                    % cost model
                    temp = sat_cost(temp);
  
                     % Reformatting
                    temp.Cost               = temp.Cost/1000; % From k$ to M$
                    temp.ResponseTimeMean   = temp.ResponseTimeMean/3600; % From seconds to hours
                    temp.NImagesPerDay      = temp.Ntargets*temp.NImagesPerDay;
                    temp.CoverageTime       = temp.CoverageTime/3600;
                    sat_out(i,j,k,l,m) = temp;
                                      
                    % display message
                    %fprintf('%3.0f of %3.0f\n', counter, total);
                    %counter = counter + 1;
                    
                    % keep a record
                    %save sat_log sat_out;
                    
                end
            end
        end
    end
end