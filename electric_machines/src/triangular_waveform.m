% Generate Triangular Waveform
function out= triangular_waveform(amp, freq, time)

% Period
T= 1/freq;
% Find posiiton in current period
t_pos= mod(time, T);
% Slope
m= amp/(T/2);

% Iutput sequence
out= zeros(size(time));

% Rising half
out(t_pos <= T/2)= m*t_pos(t_pos <= T/2);


% Falling half
out(t_pos > T/2)= amp - m*(t_pos(t_pos > T/2)-(T/2));


end