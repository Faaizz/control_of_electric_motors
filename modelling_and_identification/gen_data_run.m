%% SETUP SYSTEM MATRIX
A= [0.5 1 0; 1 0 -1; 1 1 -0.5];
%B= [1 -1; 0 1; 1 0];
B= [-1; 0; 1];
%C= [1 0 0; 0 0 1];
C= [1 0 -1];
%D= [0 0; 0 0];
D= [0];

%% MISC
time_steps= 500;

% Get systems dimensions
n= size(A,1); % No of state variables
m= size(B,2); % No of inputs variables
p= size(C,1); % No of output variables

%% SETUP INPUT SIGNAL
% Load PRBS input
u_prbs= load('u_prbs_500.mat', 'u_prbs').u_prbs;

% Setup PRBS input vector
u= ones(m,1) .* u_prbs;
%u= ones(m,time_steps);

%% GENERATE OUTPUT DATA
[input, output]= gen_data(A,B,C,D,u,time_steps);

% Plot
plot(1:time_steps, output);



