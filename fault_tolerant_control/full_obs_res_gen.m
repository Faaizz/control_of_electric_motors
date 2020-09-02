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


%% Fault Design
fault_time= 5;
% Fault amplitude
fault_amp= -15;

%% Simulation

end_time= 15;

sim_out= sim('full_obs_res_gen_sim', end_time);

% View results
Simulink.sdi.view