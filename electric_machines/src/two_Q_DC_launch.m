% INITIALIZATION SCRIPT FOR 2 QUADRANT OPERATION DC MACHINE WITH 
% THYRISTOR BRIDGE.
% Simulink model: two_Q_DC.slx

%% GRID SUPPLY PARAMETERS
V_rms= 400;     % Line rms voltage[V]
freq= 50;       % Frequency[Hz]

%% B6C
v_drop= 0.6;    % Forward drop per Thyristor[V]
L_k= 1.5;       % Filter[H]

%% PULSE GENERATOR FOR B6C
alpha= 0;       % Switching angle [deg]
p_wd= 90-(alpha+30);    % Phase width [deg]
%p_wd= 60;

%% DC MOTOR PARAMETERS
K_t= 15;        % Torque constant [N.m/A]
J= 2.5;         % Inertia [kg.m^2]
B= 0;           % Coefficient of viscous friction [N.m.s]
R_a= 0.02;      % Armature resistance[Ohms]
L_a= 1.2;       % Armature inductance[H]

%% LOAD PARAMETERS
T_l= 50;        % Load torque[N.m]

%% SIMULATION
t_max= 5;      % Simulation stop time[s]
sim_out= sim('two_Q_DC.slx', t_max);



