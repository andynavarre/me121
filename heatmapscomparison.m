freqs_straight = [80, 100, 114, 144, 160, 172, 264];
freqs_modified = [95, 106, 119, 125.8, 139, 153.8, 162.8];

loc_to_grid = [ %12 locations
    5, 2; 3, 2; 3, 4; 6, 6;
    5, 5; 1, 6; 1, 4; 4, 3;
    2, 5; 1, 2; 4, 1; 3, 5
];

data_straight = [... % straight plate
    1.00E-09, 1E-12, 3.30E-09, 1.20E-09, 1E-12, 1E-12, 5.00E-12;
    2.20E-11, 1E-12, 1.30E-10, 3.00E-10, 1.50E-10, 1E-12, 5.00E-12;
    5.00E-11, 1E-12, 3.00E-10, 5.00E-10, 6.50E-10, 9.00E-10, 5.00E-12;
    1.00E-10, 1E-12, 6.00E-10, 1E-12, 1.60E-09, 8.00E-10, 1E-12;
    2.50E-11, 1E-12, 7.00E-11, 7.50E-11, 1E-12, 2.00E-11, 1E-12;
    1.00E-11, 3.00E-11, 6.50E-11, 3.00E-11, 2.00E-11, 2.00E-11, 1E-12;
    1.00E-11, 2.00E-11, 4.00E-11, 3.00E-11, 6.00E-11, 3.00E-11, 1.00E-11;
    1.00E-11, 2.00E-11, 5.00E-11, 6.50E-11, 4.00E-11, 1E-12, 1.00E-11;
    2.00E-11, 5.00E-11, 1.1E-10, 1.1E-10, 1.2E-10, 7.5E-11, 1E-12;
    5.00E-12, 1.2E-11, 2.00E-11, 6E-11, 7.5E-11, 3.2E-11, 1E-11;
    4E-11, 1E-12, 4E-11, 1.2E-10, 8.7E-11, 3.8E-11, 1.00E-11;
    5E-12, 9E-12, 1.8E-11, 3.7E-11, 1E-12, 1.7E-11, 5E-12
];

data_modified = [... % modified plate data
    5.20E-12, 1.07E-11, 1.50E-11, 1.38E-11, 1.24E-11, 1.43E-11, 8.90E-12;
    2.00E-11, 2.00E-11, 1.00E-10, 2.00E-10, 2.00E-10, 1E-12, 1.80E-10;
    5.00E-12, 1.20E-11, 8.00E-12, 1.20E-11, 2.00E-11, 1.20E-11, 1E-12;
    2.50E-11, 1.50E-11, 1.52E-11, 6.00E-11, 4.70E-11, 5.00E-11, 4.50E-11;
    3.70E-11, 4.00E-11, 1.00E-11, 5.60E-11, 1.10E-10, 1.20E-10, 8.00E-11;
    6.00E-12, 1.57E-11, 6.50E-12, 1.90E-11, 2.10E-11, 1.10E-11, 2.00E-11;
    3.00E-11, 4.50E-11, 5.30E-11, 4.50E-11, 3.00E-11, 2.00E-11, 1.60E-11;
    8.00E-12, 1.05E-11, 4.50E-12, 1.47E-11, 3.00E-11, 1.20E-11, 1.20E-11;
    1.00E-11, 1.00E-11, 1.80E-11, 7.00E-11, 2.50E-11, 3.50E-11, 1.50E-11;
    3.00E-12, 1.50E-11, 2.30E-11, 1.40E-11, 1.10E-11, 2.30E-11, 1.20E-11;
    1.50E-11, 4.00E-11, 8.00E-11, 1.00E-12, 5.00E-11, 3.30E-11, 3.20E-11;
    3.00E-12, 7.20E-12, 3.50E-11, 7.50E-12, 1.25E-11, 1.00E-12, 1.00E-11
];

% ----------- PLOT: FFT Response Comparison -----------
% Parameters for synthetic peak broadening
f_plot = linspace(60, 280, 1000); % smooth frequency axis
sigma = 3; % width of each peak

% Plot smoothed peak-like response
figure;
for loc = 1:12
    y_straight = zeros(size(f_plot));
    y_modified = zeros(size(f_plot));
    
    % Simulate Gaussian-like responses
    for k = 1:length(freqs_straight)
        y_straight = y_straight + data_straight(loc, k) * exp(-2*((f_plot - freqs_straight(k))/sigma).^2);
    end
    for k = 1:length(freqs_modified)
        y_modified = y_modified + data_modified(loc, k) * exp(-2*((f_plot - freqs_modified(k))/sigma).^2);
    end
    
    subplot(3,4,loc)
    plot(f_plot, y_straight, 'b-', 'DisplayName','Straight'); hold on;
    plot(f_plot, y_modified, 'r-', 'DisplayName','Modified');
    title(['Location ' num2str(loc)]);
    xlabel('Frequency (Hz)');
    ylabel('FFT Mag (Simulated Response)');
    grid on;
end
legend('Location', 'BestOutside');



% ----------- PLOT: Frequency Shift (Bar) -----------
[maxS, idxS] = max(data_straight,[],2);
[maxM, idxM] = max(data_modified,[],2);
peakS = freqs_straight(idxS);
peakM = freqs_modified(idxM);
peakS = peakS(:);
peakM = peakM(:);

figure;
bar(1:12, [peakS, peakM]);
legend('Straight','Modified');
xlabel('Location');
ylabel('Dominant Frequency (Hz)');
title('Resonance Frequency Shift');
grid on;

% ----------- DIFFERENCE HEATMAP at selected mode -----------
% Pick matching frequency index
idx_straight = 1; % 100 Hz
idx_modified = 2; % 106.8 Hz

% Create grids
gridS = nan(6,6); gridM = nan(6,6);
for i = 1:12
    r = loc_to_grid(i,1); c = loc_to_grid(i,2);
    gridS(r,c) = data_straight(i,idx_straight);
    gridM(r,c) = data_modified(i,idx_modified);
end
% Symmetry patches
gridS(3,6) = gridS(1,4); gridM(3,6) = gridM(1,4);
gridS(5,4) = gridS(3,2); gridM(5,4) = gridM(3,2);
gridS(1,1) = gridS(6,6); gridM(1,1) = gridM(6,6); 
gridS(2,2) = gridS(5,5); gridM(2,2) = gridM(5,5);
gridS(5,6) = gridS(1,2); gridM(5,6) = gridM(1,2);
gridS(6,3) = gridS(1,4); gridM(6,3) = gridM(1,4);
gridS(2,4) = gridS(3,5); gridM(2,4) = gridM(3,5);

% Compute difference
diffGrid = gridS - gridM;

% Plot
figure;
h = heatmap(diffGrid, 'Colormap', parula);
h.Title = 'Change in Mode Shape (Low Frequency Node)';
h.XLabel = 'X Position'; h.YLabel = 'Y Position';
h.CellLabelFormat = '%.1e';

% ----------- DIFFERENCE HEATMAP at selected mode -----------
% Pick matching frequency index
idx_straight = 4; % 160 Hz
idx_modified = 4; % 139.8 Hz

% Create grids
gridS = nan(6,6); gridM = nan(6,6);
for i = 1:12
    r = loc_to_grid(i,1); c = loc_to_grid(i,2);
    gridS(r,c) = data_straight(i,idx_straight);
    gridM(r,c) = data_modified(i,idx_modified);
end
% Symmetry patches
gridS(3,6) = gridS(1,4); gridM(3,6) = gridM(1,4);
gridS(5,4) = gridS(3,2); gridM(5,4) = gridM(3,2);
gridS(1,1) = gridS(6,6); gridM(1,1) = gridM(6,6); 
gridS(2,2) = gridS(5,5); gridM(2,2) = gridM(5,5);
gridS(5,6) = gridS(1,2); gridM(5,6) = gridM(1,2);
gridS(6,3) = gridS(1,4); gridM(6,3) = gridM(1,4);
gridS(2,4) = gridS(3,5); gridM(2,4) = gridM(3,5);

% Compute difference
diffGrid = gridS - gridM;

% Plot
figure;
h = heatmap(diffGrid, 'Colormap', parula);
h.Title = 'Change in Mode Shape (Medium Frequency Node)';
h.XLabel = 'X Position'; h.YLabel = 'Y Position';
h.CellLabelFormat = '%.1e';

% ----------- DIFFERENCE HEATMAP at selected mode -----------
% Pick matching frequency index
idx_straight = 6; 
idx_modified = 6; 

% Create grids
gridS = nan(6,6); gridM = nan(6,6);
for i = 1:12
    r = loc_to_grid(i,1); c = loc_to_grid(i,2);
    gridS(r,c) = data_straight(i,idx_straight);
    gridM(r,c) = data_modified(i,idx_modified);
end
% Symmetry patches
gridS(3,6) = gridS(1,4); gridM(3,6) = gridM(1,4);
gridS(5,4) = gridS(3,2); gridM(5,4) = gridM(3,2);
gridS(1,1) = gridS(6,6); gridM(1,1) = gridM(6,6); 
gridS(2,2) = gridS(5,5); gridM(2,2) = gridM(5,5);
gridS(5,6) = gridS(1,2); gridM(5,6) = gridM(1,2);
gridS(6,3) = gridS(1,4); gridM(6,3) = gridM(1,4);
gridS(2,4) = gridS(3,5); gridM(2,4) = gridM(3,5);

% Compute difference
diffGrid = gridS - gridM;

% Plot
figure;
h = heatmap(diffGrid, 'Colormap', parula);
h.Title = 'Change in Mode Shape (High frequency mode)';
h.XLabel = 'X Position'; h.YLabel = 'Y Position';
h.CellLabelFormat = '%.1e';


% --- Symmetric Horizontal Path (Custom Location Sequence) ---
horizontal_path_locs = [4, 10, 5, 2, 12, 3, 12, 2, 5, 10, 4];
x_positions = 1:length(horizontal_path_locs);

% --- Recalculate dominant frequencies from FFT peaks ---
[max_straight, idx_straight] = max(data_straight, [], 2);
[max_modified, idx_modified] = max(data_modified, [], 2);
dominant_freqs_straight = freqs_straight(idx_straight);  % Should be 12x1
dominant_freqs_modified = freqs_modified(idx_modified);  % Should be 12x1

% --- Extract dominant frequencies at specified locations ---
freqs_straight_path = dominant_freqs_straight(horizontal_path_locs);
freqs_modified_path = dominant_freqs_modified(horizontal_path_locs);

% --- Plot the results ---
figure;
plot(x_positions, freqs_straight_path, '-o', 'LineWidth', 1.5, ...
    'DisplayName', 'Straight Plate');
hold on;
plot(x_positions, freqs_modified_path, '--s', 'LineWidth', 1.5, ...
    'DisplayName', 'Modified Plate');

xticks(x_positions);
xticklabels(compose('Loc %d', horizontal_path_locs));
xlabel('Horizontal Path (Location Sequence)');
ylabel('Dominant Resonance Frequency (Hz)');
title('Resonance Frequencies Along Horizontal Symmetry Path');
legend('Location', 'Best');
grid on;

% --- Vertical scan locations in order ---
vertical_path_locs = [1, 8, 3, 12, 9, 6];
x_vertical = 1:length(vertical_path_locs);

% --- Ensure dominant frequency vectors exist ---
[max_straight, idx_straight] = max(data_straight, [], 2);
[max_modified, idx_modified] = max(data_modified, [], 2);
dominant_freqs_straight = freqs_straight(idx_straight);
dominant_freqs_modified = freqs_modified(idx_modified);

% --- Extract data for this vertical path ---
freqs_straight_vertical = dominant_freqs_straight(vertical_path_locs);
freqs_modified_vertical = dominant_freqs_modified(vertical_path_locs);

% --- Plot vertical path comparison ---
figure;
plot(x_vertical, freqs_straight_vertical, '-o', 'LineWidth', 1.5, ...
    'DisplayName', 'Straight Plate');
hold on;
plot(x_vertical, freqs_modified_vertical, '--s', 'LineWidth', 1.5, ...
    'DisplayName', 'Modified Plate');

xticks(x_vertical);
xticklabels(compose('Loc %d', vertical_path_locs));
xlabel('Vertical Path (Location Sequence)');
ylabel('Dominant Resonance Frequency (Hz)');
title('Resonance Frequencies Along Vertical Path');
legend('Location', 'Best');
grid on;
