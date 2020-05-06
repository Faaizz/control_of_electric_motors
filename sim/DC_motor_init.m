%% DC MOTOR CONSTANTS

% RATED
% Power (W)
Power= 3336;
% Supply Voltage (V)
Va_rated= 140;
% Current (A)
Ia_rated= 25;
% Angular Velocity (rad/s)
Wm_rated= 3000*(2*pi/60);

% PARAMETERS
% Electrical
% Armature Resistance (Ohm)
Ra= 0.26;
% Armature Inductance (H)
La= 1.7e-3;

% Mechanical
% Moment of Inertia (kg/m^2)
J= 0.00252;
% Coefficient of Viscous Friction (kgm^2/sec)
B= 0;

%% SIMULATION

% Simulation end time (s)
end_time= 0.5;

