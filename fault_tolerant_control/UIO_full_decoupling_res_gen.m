% THIS SCRIPT GENERATES RESIDUAL SIGNAL(S) USING THE UNKNOWN INPUT  
% OBSERVER APPROACH
%
% THE AIM IS TO GENERATE RESIDUALS THAT ARE INDEPENDENT OF UNKNOWN 
% DISTURBANCES.
%
% SIMULINK MODEL: 
%====================================================================

%% Initialize Plant Model
init_demo_plant_2

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


%% Observer Design

M= inv(C*E_d);

poles= [-0.2, 0.13, 0.07];

L= place((A-E_d*M*C*A)', C', poles)';


%% Simulation Signals


% System Transformation
A_tot= A-E_d*M*C*A;
B_tot= B-E_d*M*C*B;
E_d_M= E_d*M;
A_tot_E_d_M= A_tot*E_d_M;

% Number of steps
sim_steps= 150;

% Input Matrix
mag_min= -15;
mag_max= 15;
u_k= randi([mag_min, mag_max], m, sim_steps);

% Disturbance Matrix
d_k= 0.01*rand(n_d, sim_steps); 

% Faults
f_times= randi([(1), (sim_steps-50)], n_f, 1);
f_k= zeros(n_f, sim_steps);

% Output matrix
y_k= zeros(p, sim_steps);
% Observer Output
y_k_hat= zeros(p, sim_steps);
% State matrix
x_k= zeros(n, sim_steps);
z_k= zeros(n, sim_steps);
% Observer State matrix
x_k_hat= zeros(n, sim_steps);
z_k_hat= zeros(n, sim_steps);

% Initial state
x_k(:,1)= 2+zeros(n,1);
z_k(:,1)= 2+zeros(n,1);
% Observer Initial state
x_k_hat(:,1)= zeros(n,1);
z_k_hat(:,1)= zeros(n,1);

% Errors
e_k= zeros(n, (sim_steps));
e_z_k= zeros(n, (sim_steps));

% Residual
r_k= zeros(p, (sim_steps));


%% Simulation

% Before time k
% We need prior data for k-s to be valid
for idx= 1:sim_steps
    
    % Fault
    f_k_curr= 0.5*mag_max*ones(n_f, 1)*(idx>=f_times);
    f_k(:, idx)= f_k_curr;
    
    % SYSTEM
    % Next state
    x_k(:, (idx+1))= A*x_k(:,idx) + B*u_k(:,idx) + E_d*d_k(:,idx) + ...
                        E_f*f_k(:, idx);
    
    % Output
    y_k(:, idx)= C*x_k(:,idx) + D*u_k(:,idx) + F_d*d_k(:,idx) + ...
                    F_f*f_k(:,idx);
    z_k(:, (idx))= x_k(:, (idx)) - E_d_M*y_k(:,idx);                
    
    % OBSERVER
    % Estimated State
    x_k_hat(:, (idx))= z_k_hat(:, (idx)) + E_d_M*y_k(:, idx);
    % Output
    y_k_hat(:, idx)= C*z_k_hat(:,idx) + C*E_d*y_k(:,idx);
    % Next state
    z_k_hat(:, (idx+1))= A_tot*z_k_hat(:,idx) + B_tot*u_k(:,idx) + ...
                   A_tot_E_d_M*y_k(:,idx) + L*(y_k(:,idx) - y_k_hat(:,idx));
               
    % Estimation Error
    e_k(:, (idx))= x_k(:,idx)- x_k_hat(:,idx);
    
    % Residual Generation
    % Residual
    r_k(:, (idx))= W*( y_k(:,idx) - y_k_hat(:,idx) );
    
end


%% Plotting

% Signal Conditioning
x_plot= x_k(:, 1:sim_steps);
e_plot= e_k(:, 1:sim_steps);
u_plot= u_k(:, 1:sim_steps);
y_plot= y_k(:, 1:sim_steps);
d_plot= d_k(:, 1:sim_steps);
f_plot= f_k(:, 1:sim_steps);
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
plot(plot_time,r_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it r}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("Residual");
grid minor;

% State
subplot(3,2,6);
hold on;
plot(plot_time,e_plot,'Marker','none','LineWidth',LineWidth);
set(gca,'LineWidth',LineWidthAxes);
set(gca,'FontName',FontName,'FontSize',FontSize);
xlabel('{\it k}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
ylabel('{\it e}','FontName',FontName,'FontSize',FontSize,'Interpreter','tex');
title("State Estimation Error");
grid minor;


