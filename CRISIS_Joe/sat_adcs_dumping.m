function sat_out = sat_adcs_dumping(sat_in)

%Initialization
h = sat_in.RWMomentum;
L = sat_in.ThrusterMomentArm;
t = sat_in.BurnTime;
DT = sat_in.MaxTorque;
I = sat_in.Ixx;

%Thruster force level sizing for external disturbances
F1 = DT/L;

%Thruster pulse life
Maneuver = 2*sat_in.axes*12*sat_in.Lifetime;
MomentumDump = 1*sat_in.NumberofRW*365*sat_in.Lifetime;
Pulses = Maneuver + MomentumDump;

%Sizing force level for momentum dumping
F2 = h/(L*t);

%Sizing force level to meet slew rates
rate = sat_in.SlewDeg * sat_in.SlewTime;
accel = rate/(sat_in.AccelPercentage*sat_in.SlewTime);
F3 = I*accel/L;

%Propellant mass
TotImpulse = Maneuver*3*F3 + MomentumDump*t*F2;
Mp = TotImpulse/(sat_in.SpecificImpulse*9.8);

%Outputs
sat_out.PropellantMass = Mp;
sat_out.PulseLife = Pulses;
sat_out.SizingForce = F2;

