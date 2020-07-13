% PLOTTING

figure
 
hold on

% PLOT OUTPUT
motor_speed= sim_out.Wm{1}.Values.Data;
time= sim_out.tout;

plot(time, motor_speed, 'Color', 'r', 'LineWidth', 1.5);

grid minor

legend('motor speed');
xlabel('Time(s)');
ylabel('Motor Speed(rpm)');
title('No Load Speed');