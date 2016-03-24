function sat_out = sat_toto(sat_in)

% SAT_SYSTEM
%   sat_out = sat_system(sat_in)
%
%   Function to model the CRISIS-sat system, either a single realization of
%   the system or an entire family of architectures.  Operates on an array 
%   of  'sat' structures containing the CRISIS-sat design parameters.  Thus
%   sat_in can be a single structure, a vector of structures, or an array
%   of structures.  
%
%   sat_system runs the subsystem modules on each of the sat structures in
%   the sat_in array.  The fully-populated models are returned in the
%   sat_out array, which has the same dimensions and sizes as the sat_in
%   array.  
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   13 Oct 2008

for i = 1:size(sat_in,1)
    for j = 1:size(sat_in,2)
        for k = 1:size(sat_in,3)
            for l = 1:size(sat_in,4)
                for m = 1:size(sat_in,5)
                    
                    temp = sat_in(i,j,k,l,m);
                    
                    % orbit dynamics model
                    %temp = sat_orbit(temp);
                    
                    % optical payload model
                    %temp = sat_optics(temp);
                    
                    % ADCS model
                   % temp = sat_adcs(temp);
                    temp = sat_adcs_MassPower(temp);
                    % communications subsystem model
                   % temp = sat_comm(temp);
                    
                    %temp = sat_cost(temp);
                    sat_out(i,j,k,l,m) = temp;
                    
                end
            end
        end
    end
end

return;