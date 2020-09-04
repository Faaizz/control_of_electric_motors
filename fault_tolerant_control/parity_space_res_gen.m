% THIS SCRIPT GENERATES RESIDUAL SIGNAL(S) USING THE PARITY SPACE  
% APPROACH.
%
% SIMULINK MODEL: parity_space_res_gen_sim.slx
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


%% Parity Relation Equation (Matrix Version)

% Window size
s= 3;

% H_os, H_us, H_ds, H_fs
H_os = zeros(s*p,n);
H_us= zeros(s*p,s*m);
H_ds= zeros(s*p,s*n_d);
H_fs= zeros(s*p,s*n_f);

for r = 1:s
    H_os((r-1)*p+1:r*p,1:n) = C*(A^(r-1));
    for c = 1:r
        if r == c
            H_us((r-1)*p+1:r*p,(c-1)*m+1:c*m) = D;
            H_ds((r-1)*p+1:r*p,(c-1)*n_d+1:c*n_d) = F_d;
            H_fs((r-1)*p+1:r*p,(c-1)*n_f+1:c*n_f) = F_f;
        else 
            H_us((r-1)*p+1:r*p,(c-1)*m+1:c*m) = C*A^(r-c-1)*B;
            H_ds((r-1)*p+1:r*p,(c-1)*n_d+1:c*n_d) = C*A^(r-c-1)*E_d;
            H_fs((r-1)*p+1:r*p,(c-1)*n_f+1:c*n_f) = C*A^(r-c-1)*E_f;
        end
    end
end


%% Parity Vector
% v_s*H_us = 0
% v_s must be in the left null space of H_us = right null space of H_us'

% Parity Matrix
V_s= (null(H_os'))';

% Parity Vector
v_s= V_s(1,:);


% Pre-computation of v_s*H_os
v_s_H_us= v_s*H_us;


%% Simulation Signals

% Number of steps
sim_steps= 150;

% Input Matrix
mag_min= -5;
mag_max= 5;
u_k= randi([mag_min, mag_max], m, sim_steps);

% Disturbance Matrix
d_k= 0.01*rand(n_d, sim_steps); 

% Faults
f_times= randi([(s+1), (sim_steps-50)], n_f, 1);
f_k= zeros(n_f, sim_steps);

% Output matrix
y_k= zeros(p, sim_steps);
% State matrix
x_k= zeros(n, sim_steps);

% Initial state
x_k(:,1)= 2+zeros(n,1);

% Residual
r_k= zeros(1, (sim_steps-s));


%% Simulation

% Before time k
% We need prior data for k-s to be valid
for idx= 1:(s*+1)
    % Next state
    x_k(:, (idx+1))= A*x_k(:,idx) + B*u_k(:,idx) + E_d*d_k(:,idx);
    % Output
    y_k(:, idx)= C*x_k(:,idx) + D*u_k(:,idx) + F_d*d_k(:,idx);
end


% After Time k
for idx= (s+1):sim_steps
    
    % Fault
    f_k_curr= mag_max*ones(n_f, 1)*(idx>=f_times);
    f_k(:, idx)= f_k_curr;
    % Next state
    x_k(:, (idx+1))= A*x_k(:,idx) + B*u_k(:,idx) + E_d*d_k(:,idx) + E_f*f_k(:, idx);
    % Output
    y_k(:, idx)= C*x_k(:,idx) + D*u_k(:,idx) + F_d*d_k(:,idx) + F_f*f_k(:, idx);
    
    % Residual Generation
    % y_s
    y_s_k= y_k(:, (idx-s+1):(idx));
    y_s_k= y_s_k(:);
    % u_s
    u_s_k= u_k(:, (idx-s+1):(idx));
    u_s_k= u_s_k(:);
    % Residual
    r_k(:, (idx-s))= v_s*y_s_k - v_s_H_us*u_s_k;
    
end


%% Plotting

% Signal Conditioning
x_plot= x_k(:, s+1:sim_steps);
u_plot= u_k(:, s+1:sim_steps);
y_plot= y_k(:, s+1:sim_steps);
d_plot= d_k(:, s+1:sim_steps);
f_plot= f_k(:, s+1:sim_steps);
r_plot= r_k;


% Plot time
plot_end= size(x_plot, 2)-1;
plot_time= 0:(plot_end);

LineWidth = 1;
LineWidthAxes = 1;
FontName = 'Cambria';
FontSize = 16;

% Inputs
subplot(3,2,1);
hold on;
plot(plot_time,u_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
%set(gca,'XTick',[0:10:plot_end]);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it u}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("Inputs");
axis([0 plot_end mag_min*1.2 mag_max*1.2]);
grid minor;

% Disturbances
subplot(3,2,5);
hold on;
plot(plot_time,d_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it d}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("Disturbances");
grid minor;

% Outputs
subplot(3,2,3);
hold on;
plot(plot_time,y_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it y}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("Outputs");
grid minor;


% Faults
subplot(3,2,2);
hold on;
plot(plot_time,f_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it f}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
axis([0 plot_end mag_min mag_max]);
title("Faults");
grid minor;

% Residual
subplot(3,2,4);
hold on;
plot(plot_time,r_plot,'Marker','none','LineWidth',LineWidth, 'Color', 'r');
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it r}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("Residual");
grid minor;


