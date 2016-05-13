function dV = DeltaV(h,life) 
%--------------------------------------------------------------------------
% This function estimates the total Delta-V for a mission, excluding ADCS
% Based on Spandan's model; assumes circular orbit
% Inputs:
%   h:    Altitude [km]
%   life: Satellite lifetime [years]
% Output
%   dV: Total Delta-V for the mission [m/s]
%--------------------------------------------------------------------------
    
    % Constants
    RE = 6378136.6;    % Earth's equatorial radius [m]
    B = 50;            % Ballistic coefficient [m^2/kg] (assumed)
    
    % Convert altitude to meters
    h = h*1000;
    
    % Semi-major axis
    a = RE + h;

    % Maximum altitude for Low Earth Orbit [m]
    LEOMAX = 2E6;
    
    % Find Delta-V for Injection and Deorbiting
    if h > LEOMAX
        dVi = compute_dV_injection (RE+150000,a);
        dVd = compute_dV_graveyard(a,B);
    else
        dVi = 0;
        dVd = compute_dV_deorbit(a,RE);
    end
    
    % Find Delta-V for Orbit Maintenance
    if h < 500
        dVy = 12;
    elseif h < 600
        dVy = 5;
    elseif h < 1000
        dVy = 2;
    else 
        dVy = 0;
    end
    dVm = dVy * life;

    % Total Delta-V
    dV = dVi + dVd + dVm;

end

function V = orbitVelocity(a,r)
    GM = 3.986004418E14;
    V = sqrt(GM*(2/r - 1/a));
end

function dV =  compute_dV(rp1,ra1,rp2,ra2,r)
    a1 = (rp1 + ra1)/2;
    a2 = (rp2 + ra2)/2;
    dV = abs(orbitVelocity(r,a2) - orbitVelocity(r,a1));
end

function dV = compute_dV_injection(ainj,a)
    dV = compute_dV(ainj,a,a,a,a);
end
    
function dV = compute_dV_deorbit(a,adeorbit)
    dV = compute_dV(a,a,adeorbit,a,a);
end

function dV = compute_dV_graveyard(a,B)
    dh = 235000 + 1E6 * B;
    dV = compute_dV(a,a,a,a+dh,a);
end
