% Obtain transfer function using symbolic maths

syms T s;

K1= 1; K2= 1; B1= 1; B2= 1; J= 1;

C= [T; 0];

A= [(1+s+s^2)   (-1-s); (-1-s)  (2+2*s)];

% inv(A)*C= A]C
Theta= A\C;

% G_s= Theta_2/T
G_s= Theta(2,:)/T;

pretty(G_s)