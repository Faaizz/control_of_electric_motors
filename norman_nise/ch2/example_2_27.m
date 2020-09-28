% Solving differential equation using Symbolic Maths Toolbox

syms x(t);

% First order defivative
Dx= diff(x,t);
% Second order derivative
D2x= diff(x,t,2);

% Differential equation
ode= D2x + 2*Dx - (sqrt(2)/2) * x == (sqrt(2)/2);

% Solution
xSol(t)= dsolve(ode);

pretty(xSol(t))