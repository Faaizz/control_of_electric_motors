% THIS SCRIPT INITIALIZES SYSTEM MATRICES FOR A DEMO PLANT
% THIS DEMO PLANT HAS:
% 3 INPUTS
% 3 STATE VARIABLES
% 3 DISTURBANCE INPUTS
% 1 FAULTS
% 3 OUTPUTS
%====================================================================

sprintf("Initializing System Model...")

%% State Equation
% x(k+1)= A.x(k) + B.u(k) + E_d.d(k) + E_f.f(k)
% x(k)- State vector
% u(k)- Input vector
% d(k)- Disturbance vector
% f(k)- Fault vector
%====================================================================
A= [ [0.5,0.41,0.7]; [0.75, 0, -1.8]; [1.1, 0.8, -0.5] ]
B= [ [0.1, -0.2, 0.3]; [0.5, 0.1, 0.35]; [1, 0, 0.7] ]
E_d= [ [0.1, 0.2, 0]; [0, 0.5, 0.2]; [1, 0.5, 0.7]]
E_f= [0; 0; 1]


%% Output Equation
% y(k)= C.x(k) + D.u(k) + F_d.d(k) + F_f.f(k)
%====================================================================
C= [ [1, 0, 0]; [0, 0, 1]; [0, 1, 0] ]
D= [ [0, 0, 0]; [0, 0, 0]; [0, 0, 0] ]
F_d= [ [0, 0, 0]; [0, 0, 0]; [0, 0, 0] ]
F_f= [0.2; 0.6; 0]

sprintf("System Model Initialized")