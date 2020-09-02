% INITIALIZATION SCRIPT FOR 2 QUADRANT OPERATION DC MACHINE WITH 
% THYRISTOR BRIDGE.
% Simulink model: two_Q_DC.slx

%% GRID SUPPLY PARAMETERS
U_rms= 400;     % Line rms voltage[V]
freq= 50;       % Frequency[Hz]

%% B6C
u_drop= 0.6;    % Forward drop per Thyristor[V]
%v_drop= 0;
L_k= 1.5;       % Filter[H]

%% PULSE GENERATOR FOR B6C
alpha= 30;       % Switching angle [deg]
%p_wd= 90-(alpha+30);    % Phase width [deg]
p_wd= 60;

%% DC MOTOR PARAMETERS
K_l= 30*pi;     % Speed constant [V/rpm]
K_t= K_l/(2*pi);        % Torque constant [N.m/A]
J= 2.5;         % Inertia [kg.m^2]
B= 0;           % Coefficient of viscous friction [N.m.s]
R_a= 0.02;      % Armature resistance[Ohms]
L_a= 1.2;       % Armature inductance[H]

%% LOAD PARAMETERS
T_l= 50;        % Load torque[N.m]


%% CONTROLLER DESIGN
% Maximum Thyristor Bridge Output[V] (i.e. at alpha=30deg)
U_di0_calc= 3*sqrt(2)*U_rms*cos(alpha)/pi;   %Theoretical
%U_di0= polyfit(sim_out.tout, sim_out.u_d{1}.Values.Data, 0);

% Pulse Generator
U_s0= 5;        % Maximum Supply to Pulse Generator[V]
pg_slope= -180/(2*U_s0);     % Pulse Generator Slope[deg/V]


% Current Controller
% Using Pole-Zero Cancellation (PI Controller)
omega_c= 100;     % Controller Bandwidth[Hz]
K_ii= omega_c*L_a;
K_ii= K_ii/5;     % For less oscillations
K_pi= omega_c*R_a;

% Current limiter
max_i= 5;       % Maximum Current[A]

% Speed Controller
omega_s= omega_c/10; %Controller bandwidth[Hz]
K_is= J*(omega_s^2)/(5*K_t);
K_ps= J*omega_s/K_t;


%% PERFORMANCE
n_soll= 1500;       % Desired speed[rpm]


%% SIMULATION
t_max= 20;      % Simulation stop time[s]
sim_out= sim('controlled_two_Q_DC.slx', t_max);

%% PLOTTING





