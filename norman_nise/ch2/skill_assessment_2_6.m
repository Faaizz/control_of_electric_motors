% Solve system of equations using Symbolic Maths

syms s V I1 I2 I3;

I_vec= [I1; I2; I3];
eq1_vec= [(s+1), -s, -1];
eq2_vec= [-s, (2*s+1), -1];
eq3_vec= [-1, -1, (s+2)];

eq1= eq1_vec * I_vec == V;
eq2= eq2_vec * I_vec == 0;
eq3= eq3_vec * I_vec == 0;

sol= solve([eq1, eq2, eq3], I1, I2, I3);

V_l= sol.I2 * s;

G_s= V_l/V;

pretty(G_s)