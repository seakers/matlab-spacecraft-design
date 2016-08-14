function HP=HeatPipeProperties

%working fluid is assumed to be ammonia for it's relatively common
%availability and wide T range([-75,125]).
%heatpipe tubing is assued to be aluminum for it's low density and
%compatibiliy with ammonia.
%wick structure is assumed to be groove. It's cheap and satisfies most
%common space usage. Note it's very sensitive to gravity.

%can be updated as seen fair when changing heatpipe type and configuration

HP.price=50;      %[dollar/m]
HP.density=2e-5;  %[kg/m]

%HP.diameter=0.0005; %[m]
%specific heat pipe selection and desgin will be determinded after power
%estimation on components carried on board.
end