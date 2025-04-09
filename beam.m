%% --- Load and Process Experimental Data ---
filename = 'Trial 3.txt';
fid = fopen(filename, 'r');
data = textscan(fid, 'Accel X: %d Y: %d Z: %d');
fclose(fid);

rawX = double(data{3});
accX = rawX / 16384 * 9.81;  % Convert to m/s^2 (assuming ±2g)
accX = accX - mean(accX);
% Time vector (sampling frequency)
Fs = 100;         % Hz
dt = 1 / Fs;
t = (0:length(accX)-1) * dt;

% FFT
N = length(accX);           % Number of samples
Y = fft(accX);
P2 = abs(Y / N);            % Two-sided spectrum
P1 = P2(1:N/2+1);           % Single-sided spectrum
P1(2:end-1) = 2 * P1(2:end-1);  % Mirror symmetry

f = Fs * (0:(N/2)) / N;     % Frequency vector

% Plotting the FFT
figure;
plot(f, P1);
xlabel('Frequency (Hz)');
ylabel('|Amplitude|');
title('Single-Sided Amplitude Spectrum of accX');

%% --- Fit Damped Oscillation Model ---
model = @(b, t) (b(1) * cos(b(2)*t + b(3)) .* exp(-b(4)*t)).';  % A*cos(wt + φ)*exp(-ζt)
b0 = [10, 20, 0, 1];  % [amplitude, omega, phase, damping]

% Fit using lsqcurvefit
b = lsqcurvefit(model, b0, t, accX);
a_fit = model(b, t);
damping_coeff = 2*b(4)*10/1000;

% Display fitted parameters
fprintf('\n--- Fitted Parameters ---\n');
fprintf('Amplitude      = %.3f m/s²\n', b(1));
fprintf('Frequency ω    = %.3f rad/s (%.2f Hz)\n', b(2), b(2)/(2*pi));
fprintf('Phase φ        = %.3f rad\n', b(3));
fprintf('Damping factor = %.3f 1/s\n', b(4));
fprintf('Damping coefficient = %.3f', damping_coeff);

%% --- Plot All ---
figure;
plot(t, accX, 'b', 'DisplayName', 'Experimental');
hold on;
plot(t, a_fit, 'k-.', 'DisplayName', 'Fitted (Damped)', 'Color', 'red');
xlabel('Time (s)');
ylabel('Acceleration (m/s²)');
title('Acceleration Comparison at Ruler Tip');
legend('Location', 'best');
ylim([-6, 6]);
grid on;
