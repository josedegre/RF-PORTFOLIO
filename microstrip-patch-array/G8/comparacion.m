% Load data from the file
s = importdata('G8.s1p');

% Extract S11 and frequency data
s11 = str2double(s.textdata(7:end, 2));
freq = str2double(s.textdata(7:end, 1));

% Plot S11 vs. frequency
figure;
plot(freq, s11);  % You can use a different marker style if needed
xlabel('Frequency (Hz)');
ylabel('S11');
title('|S11|');
grid on;

%% Diagramas de radiación
% Especifica la ruta completa de los archivos .ASC
phi0485 = 'C8_04850_dBi.CAB.CortePH0.ASC';
phi0459 = 'C8_04590_dBi.CAB.CortePH0.ASC';
phi0507 = 'C8_05070_dBi.CAB.CortePH0.ASC';

% Utiliza importdata para cargar los datos
phi0485 = importdata(phi0485);
phi0459 = importdata(phi0459);
phi0507 = importdata(phi0507);

% Accede a los datos según su estructura
if isstruct(phi0485)
    % Si los datos son una estructura, puede que estén en el campo .data
    % Ajusta esto según la estructura específica de tu archivo
    matriz_datos1 = phi0485.data;
else
    % Si los datos son simplemente una matriz, úsalos directamente
    matriz_datos1 = phi0485;
end

% Accede a los datos según su estructura
if isstruct(phi0459)
    % Si los datos son una estructura, puede que estén en el campo .data
    % Ajusta esto según la estructura específica de tu archivo
    matriz_datos2 = phi0459.data;
else
    % Si los datos son simplemente una matriz, úsalos directamente
    matriz_datos2 = phi0459;
end

% Accede a los datos según su estructura
if isstruct(phi0507)
    % Si los datos son una estructura, puede que estén en el campo .data
    % Ajusta esto según la estructura específica de tu archivo
    matriz_datos3 = phi0507.data;
else
    % Si los datos son simplemente una matriz, úsalos directamente
    matriz_datos3 = phi0507;
end

% Visualizar los datos
figure;
plot(matriz_datos1(:, 1), matriz_datos1(:, 2)-max(matriz_datos1(:, 2))); 
hold on;
plot(matriz_datos1(:, 1), matriz_datos1(:, 4)-max(matriz_datos1(:, 2)));
xlabel('\theta [º]');
ylabel('Ganancia Realizada [dB]');
title('Diagrama de radiación en \phi = 0º y f = 4.85 GHz');
legend('CP','XP','Location','northeast')
grid on;
hold off;

figure;
plot(matriz_datos2(:, 1), matriz_datos2(:, 2)-max(matriz_datos2(:, 2))); 
hold on;
plot(matriz_datos2(:, 1), matriz_datos2(:, 4)-max(matriz_datos2(:, 2)));
xlabel('\theta [º]');
ylabel('Ganancia Realizada [dB]');
title('Diagrama de radiación en \phi = 0º y f = 4.59 GHz');
legend('CP','XP','Location','northeast')
grid on;
hold off;

figure;
plot(matriz_datos3(:, 1), matriz_datos3(:, 2)-max(matriz_datos3(:, 2))); 
hold on;
plot(matriz_datos3(:, 1), matriz_datos3(:, 4)-max(matriz_datos3(:, 2)));
xlabel('\theta [º]');
ylabel('Ganancia Realizada [dB]');
title('Diagrama de radiación en \phi = 0º y f = 5.07 GHz');
legend('CP','XP','Location','northeast')
grid on;
hold off;

%% Comparativa S11

% Import measured data 
s = importdata('G8.s1p');

% Extract S11 and frequency data
s11 = str2double(s.textdata(7:end, 2));
freq = str2double(s.textdata(7:end, 1));

% Import CST data
load('s11cst.mat');

% Plot S11 vs. frequency
figure;
plot(freq, s11);
hold on
plot(s11cst(:,1)*1e9,s11cst(:,2));
xlabel('Frequency (Hz)');
ylabel('S11');
title('Comparativa de |S11|');
axis([4e9 5.5e9 -30 0])
legend('S11 medido','S11 CST')
grid on;
hold off

%% Comparativa Diagramas de radiación
% Especifica la ruta completa de los archivos .ASC
phi0485 = 'C8_04850_dBi.CAB.CortePH0.ASC';


% Utiliza importdata para cargar los datos
phi0485 = importdata(phi0485);


% Cargar datos de cst
gain485=load('gain485.mat').gain485;
freq=[];
gain=[];
for i=1:length(gain485(:,1))
    freq=[freq;gain485{i,1}];
    gain=[gain;gain485{i,3}];
end
% Visualizar los datos
figure;
plot(matriz_datos1(:, 1), matriz_datos1(:, 2)); 
hold on;
plot(freq, gain);
xlabel('\theta [º]');
ylabel('Ganancia Realizada [dB]');
title('Comparación Diagrama de radiación en \phi = 0º y f = 4.85 GHz');
legend('Medido','CST','Location','northeast')
grid on;
hold off;


