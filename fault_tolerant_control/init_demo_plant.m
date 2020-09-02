% THIS SCRIPT INITIALIZES SYSTEM MATRICES FOR A DEMO PLANT
%====================================================================

sprintf("Initializing System Model...")

%% State Equation
% x(k+1)= A.x(k) + B.u(k) + E_d.d(k) + E_f.f(k)
% x(k)- State vector
% u(k)- Input vector
% d(k)- Disturbance vector
% f(k)- Fault vector
%====================================================================
A= [ [0.5,1,0]; [1, 0, -1]; [1, 1, -0.5] ]
B= [ [1, -1]; [0, 1]; [1, 0] ]
E_d= [1; 0; 1]
E_f= [0; 0; 1]


%% Output Equation
% y(k)= C.x(k) + D.u(k) + F_d.d(k) + F_f.f(k)
%====================================================================
C= [ [1, 0, 0]; [0, 0, 1] ]
D= [ [0, 0]; [0, 0] ]
F_d= [0; 0]
F_f= [1; 0]

sprintf("System Model Initialized")