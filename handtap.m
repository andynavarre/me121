clear all;
close all;
clc;

% List your files
fileNames = {'Trial1Center.txt', 'Trial2Center.txt', 'Trial3Center.txt', 'Trial4Center.txt', 'Trial5Center.txt'};

% Define expected peak regions [min max] in kHz
targetBands = [
    0  0.175;   % Peak 1: around 0.2 kHz
    0.18  0.35;    % Peak 2: around 1 kHz
    0.4  0.6;    % Peak 3: around 4.6 kHz
    0.7  0.9;    % Peak 4: around 8-9 kHz
    0.9  1.1    % Peak 5: around 11 kHz
];

% Initialize
figure;
hold on;
colors = lines(numel(fileNames));
peakInfo = cell(length(fileNames), 1);
top5Matrix = NaN(length(fileNames), size(targetBands,1)); % Rows = files, Cols = peak regions

for k = 1:length(fileNames)
    % Load time and amplitude data
    data = readmatrix(fileNames{k});
    time = data(:,1);
    signal = data(:,2);

    % Sampling info
    dt = mean(diff(time));
    Fs = 1 / dt;
    N = length(signal);

    % Compute FFT
    Y = fft(signal);
    f = Fs * (0:(N/2)) / N;
    P2 = abs(Y / N);
    P1 = P2(1:N/2+1);
    P1(2:end-1) = 2 * P1(2:end-1);

    % Convert frequency to kHz
    f_kHz = f / 1000;

    % Plot magnitude spectrum
    plot(f_kHz, P1, 'DisplayName', sprintf('File %d', k), 'Color', colors(k,:));

    % Find all peaks
    [pks, locs] = findpeaks(P1, f_kHz, ...
        'MinPeakProminence', max(P1)*0.02, ...
        'MinPeakDistance', 0.001); 

    % Match peaks inside each target band
    peakFreqs = NaN(1, size(targetBands,1)); % 1x5 for 5 bands
    peakAmps = NaN(1, size(targetBands,1));

    for bandIdx = 1:size(targetBands,1)
        bandMin = targetBands(bandIdx,1);
        bandMax = targetBands(bandIdx,2);

        % Find peaks inside this band
        bandMask = locs >= bandMin & locs <= bandMax;
        if any(bandMask)
            [maxAmp, maxIdx] = max(pks(bandMask));
            bandLocs = locs(bandMask);
            peakFreqs(bandIdx) = bandLocs(maxIdx);
            peakAmps(bandIdx) = maxAmp;
        end
    end

    % Save peaks for this file
    peakInfo{k} = table(peakFreqs(:), peakAmps(:), ...
        'VariableNames', {'Frequency_kHz', 'Amplitude'});
    top5Matrix(k, :) = peakFreqs;

    % Display top peaks for debug
    fprintf('\nTop Peaks for File %d:\n', k);
    disp(peakInfo{k});
end

% Finalize plot
xlabel('Frequency (kHz)');
ylabel('|P1(f)|');
title('Frequency Response Function of Straight Plate (Center)');
xlim([0 3]);
legend('show');
grid on;
hold off;

% Ensure x-axis doesn't use scientific notation
ax = gca;
ax.XAxis.Exponent = 0;
ax.XTickLabel = string(ax.XTick);

% Compute average and standard deviation across files
avgPeaks = mean(top5Matrix, 1, 'omitnan');
stdPeaks = std(top5Matrix, 0, 1, 'omitnan');

% Display group statistics
fprintf('\nMean and Std Dev of Peaks (Matched by Frequency Bands):\n');
for i = 1:size(targetBands,1)
    fprintf('Peak %d: Mean = %.4f kHz, Std = %.4f kHz\n', ...
        i, avgPeaks(i), stdPeaks(i));
end
