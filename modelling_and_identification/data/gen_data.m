% THIS SCRIPT GENERATES IDENTIFICATION DATA FOR THE MODEL SUPPLIED 
% USING THE PRBS SIGNAL CONTAINED IN u_prbs.mat

function [input, output]= gen_data(A,B,C,D,u,time_steps)

% PARAMS
% A,B,C,D: are system state space matrices
% time_steps: Number of time steps for which to simulate
% must not exceed 500 which is the persistent order of excitation of the 
% prbs signal

% Restrict number of time steps to length of u
if time_steps > length(u)
    time_steps= length(u);
end

% Get systems dimensions
n= size(A,1); % No of state variables
m= size(B,2); % No of inputs variables
p= size(C,1); % No of output variables

% Setup PRBS input vector
u= u(:,1:time_steps);

% Setup output vector
y= zeros(p,time_steps);

% Initialize States
% To Zero
x_k= zeros(n,1);

% SIMULATION
for idx= 1:time_steps
    % Get current input
    u_k= u(:,idx);
    % Get next state
    x_k_1= A*x_k + B*u_k;
    % Compute output
    y(:,idx)= C*x_k + D*u_k;
    % Update state
    x_k= x_k_1;
    
end

input= u;
output= y;

end