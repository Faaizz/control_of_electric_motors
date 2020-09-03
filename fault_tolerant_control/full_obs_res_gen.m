% THIS SCRIPT GENERATES RESIDUAL SIGNAL(S) USING A 
% FULL-ORDER OBSERVER.
%
% SIMULINK MODEL: full_obs_res_gen_sim.slx
%====================================================================

%% Initialize Plant Model
init_demo_plant

% No of states
n= size(A,1);
% No of inputs
m= size(B,2);
% No of disturbance inputs
n_d= size(E_d,2);
% No of fault inputs
n_f= size(E_f,2);
% No of outputs
p= size(C,1);
% No of residual signals to generate
q= p;

% Initial State
x_0= 5.*ones(3,1);

% Residual weighting Matrix
W= eye(q,p);


%% Oberver Design
% Poles
poles= [-0.5; -0.5; 0.0];
L= place(A', C', poles)';


%% Simulation Signals

end_time= 150;

% Signals
% Min & Max input amplitude
mag_min= -5;
mag_max= 5;
% Input stairs interval
stair_int= 3;

% Create DemoSignals object
sigs= DemoSignals(m, mag_min, mag_max, n_d, n_f, stair_int, end_time);



%% Simulation

sim_out= sim('full_obs_res_gen_sim', end_time);

% View results
Simulink.sdi.view