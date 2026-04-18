%% Diseño de Array en Fase Cuadrado - Ejercicio 1
clear; clc; close all;

% Especificaciones
f = 30e9;           
D_dBi = 25;         
c = 3e8;            

fprintf('=== DISEÑO DE ARRAY EN FASE CUADRADO ===\n');
fprintf('Frecuencia: %.0f GHz\n', f/1e9);
fprintf('Directividad requerida: %.0f dBi\n\n', D_dBi);

%% a) Cálculo del tamaño de la antena
lambda = c/f;      
D_linear = 10^(D_dBi/10); 


A = D_linear * lambda^2 / (4*pi); 
L = sqrt(A);       

fprintf('a) TAMAÑO DE LA ANTENA:\n');
fprintf('   Longitud de onda: λ = %.4f mm\n', lambda*1000);
fprintf('   Área requerida: A = %.4f m²\n', A);
fprintf('   Lado del array cuadrado: L = %.4f m = %.1f mm\n', L, L*1000);

%% b) Cálculo del número de elementos
d = lambda/2;      
N_per_side = floor(L/d) + 1; 
N_total = N_per_side^2; 

fprintf('\nb) NÚMERO DE ELEMENTOS:\n');
fprintf('   Separación entre elementos: d = λ/2 = %.4f mm\n', d*1000);
fprintf('   Elementos por lado: N = %.0f\n', N_per_side);
fprintf('   Número total de elementos: N_total = %.0f\n', N_total);

% Verificación de directividad
D_actual = 4*pi * (N_per_side*d)^2 / lambda^2;
D_actual_dBi = 10*log10(D_actual);
fprintf('   Directividad obtenida: %.2f dBi\n', D_actual_dBi);

%% c) Cálculo del ancho de haz a -3dB
% Para un array uniforme lineal de N elementos:
BW_3dB_deg = 50.8 / (N_per_side * d/lambda); % [grados]

fprintf('\nc) ANCHO DE HAZ A -3dB:\n');
fprintf('   Planos H y E: BW_3dB = %.2f°\n', BW_3dB_deg);

%% PROGRAMA GENERAL PARA PATRÓN DE ARRAY EN FASE
fprintf('\n=== PROGRAMA GENERAL DE ARRAY EN FASE ===\n');

% Parámetros configurables
beam_steering_theta = input('Ingrese ángulo de steering en theta [grados] (0 para broadside): ');
if isempty(beam_steering_theta)
    beam_steering_theta = 0;
end

beam_steering_phi = input('Ingrese ángulo de steering en phi [grados] (0 por defecto): ');
if isempty(beam_steering_phi)
    beam_steering_phi = 0;
end

beam_steering_theta = deg2rad(beam_steering_theta);
beam_steering_phi = deg2rad(beam_steering_phi);

fprintf('\nOpciones de distribución de amplitud:\n');
fprintf('1 - Uniforme\n');
fprintf('2 - Triangular\n');
fprintf('3 - Binomial\n');
amp_option = input('Seleccione distribución (1-3) [1 por defecto]: ');
if isempty(amp_option)
    amp_option = 1;
end

x_pos = (-(N_per_side-1)/2:(N_per_side-1)/2) * d;
y_pos = x_pos;
[X, Y] = meshgrid(x_pos, y_pos);

amplitude = ones(N_per_side, N_per_side);
switch amp_option
    case 2 % Triangular
        for i = 1:N_per_side
            for j = 1:N_per_side
                amplitude(i,j) = 1 - 0.8 * (abs(i-(N_per_side+1)/2) + abs(j-(N_per_side+1)/2)) / (N_per_side-1);
            end
        end
    case 3 % Binomial
        binom_coeff = @(n,k) factorial(n)/(factorial(k)*factorial(n-k));
        for i = 1:N_per_side
            for j = 1:N_per_side
                amplitude(i,j) = binom_coeff(N_per_side-1, i-1) * binom_coeff(N_per_side-1, j-1);
            end
        end
        amplitude = amplitude / max(amplitude(:));
end

% Fases para beam steering
phase = zeros(N_per_side, N_per_side);
kx = 2*pi/lambda * sin(beam_steering_theta) * cos(beam_steering_phi);
ky = 2*pi/lambda * sin(beam_steering_theta) * sin(beam_steering_phi);

for i = 1:N_per_side
    for j = 1:N_per_side
        phase(i,j) = - (kx * X(i,j) + ky * Y(i,j));
    end
end

% Calcular patrón de radiación
theta_range = deg2rad(-90:0.5:90);
phi_slice = 0; % Plano E (phi=0)
[u,v]=meshgrid(linspace(-1,1,500),linspace(-1,1,500));
% AF = zeros(500); % Array Factor

% for idx = 1:length(theta_range)
%     theta = theta_range(idx);
%     sum_AF = 0;
%     % u=sin(theta) * cos(phi_slice);
%     % v=sin(theta) * sin(phi_slice);
%     for i = 1:N_per_side
%         for j = 1:N_per_side
%             psi = 2*pi/lambda * d * (i - (N_per_side+1)/2) *u + 2*pi/lambda * d * (j - (N_per_side+1)/2) *v;
%             sum_AF = sum_AF + amplitude(i,j) * exp(1j * (phase(i,j) + psi));
%         end
%     end
% 
%     AF = abs(sum_AF);
% end
sum_AF = 0;
% u=sin(theta) * cos(phi_slice);
% v=sin(theta) * sin(phi_slice);
for i = 1:N_per_side
    for j = 1:N_per_side
        psi = 2*pi/lambda * d * (i - (N_per_side+1)/2) *u + 2*pi/lambda * d * (j - (N_per_side+1)/2) *v;
        sum_AF = sum_AF + amplitude(i,j) * exp(1j * (phase(i,j) + psi));
    end
end

AF = abs(sum_AF);
B=(u.^2+v.^2<=1);
AF=AF.*B;
% Normalizar
AF = AF/max(AF,[],'all');
AF_dB = 20*log10(AF);
figure(1)
surf(u,v,AF_dB, 'LineStyle','none','FaceColor','texturemap')
colormap jet;
caxis([-60 0]);
colorbar;
title('Array Factor', 'FontSize',12);
xlabel('u')
ylabel('v')
set(gca,'View',[0,90])
axis equal

%%
E_0=1-u.^2-v.^2;
E_0=E_0.*B;
% Normalizar
E_0 = E_0/max(E_0,[],'all');
E_0_dB = 20*log10(E_0);

figure(2)
surf(u,v,E_0_dB, 'LineStyle','none','FaceColor','texturemap')
colormap jet;
caxis([-60 0]);
colorbar;
title('Radiation Pattern of the radiating element(dB)', 'FontSize',12);
xlabel('u')
ylabel('v')
set(gca,'View',[0,90])
axis equal

%%
PA=E_0.*AF;
% Normalizar
PA = PA/max(PA,[],'all');
PA_dB = 20*log10(PA);

figure(3)
surf(u,v,PA_dB, 'LineStyle','none','FaceColor','texturemap')
colormap jet;
caxis([-60 0]);
colorbar;
title('Radiation Pattern of Planar Array Antenna(dB)', 'FontSize',12);
xlabel('u')
ylabel('v')
set(gca,'View',[0,90])
axis equal

%%
figure(4)
% Subplot 4: Patrón de radiación lineal
plot(180/pi*asin(u(1,:)), AF_dB(250,:), 'b--', 'LineWidth', 2);
hold on;
plot(180/pi*asin(u(1,:)),PA_dB(250,:), 'r', 'LineWidth', 2);
grid on;
xlabel('θ [grados]'); ylabel('|AF| [lineal]');
title('\phi=0º ');
xlim([-90, 90]); ylim([-40, 0]);

figure(5)
% Subplot 4: Patrón de radiación lineal
plot(180/pi*asin(v(:,1)), AF_dB(:,250), 'b--', 'LineWidth', 2);
hold on;
plot(180/pi*asin(v(:,1)),PA_dB(:,250), 'r', 'LineWidth', 2);
grid on;
xlabel('θ [grados]'); ylabel('|AF| [lineal]');
title('\phi=90º ');
xlim([-90, 90]); ylim([-40, 0]);


%%
sum_AF_elem_failure=0;
for i = 1:N_per_side
    for j = 1:N_per_side
        if (i==2 && j==7) || (i==9 && j==10)
            amplitude(i,j)=0;
        end
        psi = 2*pi/lambda * d * (i - (N_per_side+1)/2) *u + 2*pi/lambda * d * (j - (N_per_side+1)/2) *v;
        sum_AF_elem_failure = sum_AF_elem_failure + amplitude(i,j) * exp(1j * (phase(i,j) + psi));
    end
end
AF_elem = abs(sum_AF_elem_failure);

PA_elem=E_0.*AF_elem;
% Normalizar
PA_elem = PA_elem/max(PA_elem,[],'all');
PA_elem_dB = 20*log10(PA_elem);

figure(6)
surf(u,v,PA_elem_dB, 'LineStyle','none','FaceColor','texturemap')
colormap jet;
caxis([-60 0]);
colorbar;
title('Radiation Pattern of Planar Array Antenna(dB)', 'FontSize',12);
xlabel('u')
ylabel('v')
set(gca,'View',[0,90])
axis equal


sum_AF_row_failure=0;
for i = 1:N_per_side
    for j = 1:N_per_side
        if (i==2) || (i==6)
            amplitude(i,j)=0;
        end
        psi = 2*pi/lambda * d * (i - (N_per_side+1)/2) *u + 2*pi/lambda * d * (j - (N_per_side+1)/2) *v;
        sum_AF_row_failure = sum_AF_row_failure + amplitude(i,j) * exp(1j * (phase(i,j) + psi));
    end
end

AF_row = abs(sum_AF_row_failure);

PA_row=E_0.*AF_row;
% Normalizar
PA_row = PA_row/max(PA_row,[],'all');
PA_row_dB = 20*log10(PA_row);

figure(7)
surf(u,v,PA_row_dB, 'LineStyle','none','FaceColor','texturemap')
colormap jet;
caxis([-60 0]);
colorbar;
title('Radiation Pattern of Planar Array Antenna(dB)', 'FontSize',12);
xlabel('u')
ylabel('v')
set(gca,'View',[0,90])
axis equal

% % Subplot 5: Patrón polar
% figure(5)
% polarplot(theta_range, AF, 'b-', 'LineWidth', 2);
% title('Patrón de Radiación (Polar)');
%% Visualización
% figure('Position', [100, 100, 1200, 800]);
% 
% subplot(2,3,1);
% imagesc(x_pos*1000, y_pos*1000, amplitude);
% colorbar; axis equal tight;
% xlabel('x [mm]'); ylabel('y [mm]');
% title('Distribución de Amplitud');
% colormap(jet);
% 
% subplot(2,3,2);
% imagesc(x_pos*1000, y_pos*1000, rad2deg(phase));
% colorbar; axis equal tight;
% xlabel('x [mm]'); ylabel('y [mm]');
% title('Distribución de Fase [°]');
% colormap(hsv);
% 
% subplot(2,3,3);
% plot(rad2deg(theta_range), AF_dB, 'b-', 'LineWidth', 2);
% grid on;
% xlabel('θ [grados]'); ylabel('|AF| [dB]');
% title('Patrón de Radiación (Plano E)');
% xlim([-90, 90]); ylim([-40, 0]);
% line([-90,90], [-3,-3], 'Color','red','LineStyle','--');
% legend('Patrón', '-3 dB');
% 
% % Subplot 4: Patrón de radiación lineal
% subplot(2,3,4);
% plot(rad2deg(theta_range), AF, 'b-', 'LineWidth', 2);
% grid on;
% xlabel('θ [grados]'); ylabel('|AF| [lineal]');
% title('Patrón de Radiación (Lineal)');
% xlim([-90, 90]); ylim([0, 1]);
% 
% % Subplot 5: Patrón polar
% subplot(2,3,5);
% polarplot(theta_range, AF, 'b-', 'LineWidth', 2);
% title('Patrón de Radiación (Polar)');
% 
% % Subplot 6: Información del diseño
% subplot(2,3,6);
% axis off;
% info_str = {
%     sprintf('RESUMEN DEL DISEÑO:'),
%     sprintf('Frecuencia: %.0f GHz', f/1e9),
%     sprintf('λ = %.4f mm', lambda*1000),
%     sprintf(''),
%     sprintf('ARRAY CUADRADO:'),
%     sprintf('Lado: %.1f mm', L*1000),
%     sprintf('Elementos por lado: %d', N_per_side),
%     sprintf('Total elementos: %d', N_total),
%     sprintf('Separación: %.2f mm', d*1000),
%     sprintf(''),
%     sprintf('CARACTERÍSTICAS:'),
%     sprintf('Directividad: %.2f dBi', D_actual_dBi),
%     sprintf('BW -3dB: %.2f°', BW_3dB_deg),
%     sprintf(''),
%     sprintf('CONFIGURACIÓN:'),
%     sprintf('Steering θ: %.1f°', rad2deg(beam_steering_theta)),
%     sprintf('Steering φ: %.1f°', rad2deg(beam_steering_phi)),
%     sprintf('Dist. amplitud: %d', amp_option)
% };
% text(0.1, 0.9, info_str, 'VerticalAlignment', 'top', 'FontSize', 10);
% 
% sgtitle('Diseño de Array en Fase Cuadrado a 30 GHz', 'FontSize', 14, 'FontWeight', 'bold');
% 
% %% Resultados en consola
% fprintf('\n=== RESULTADOS FINALES ===\n');
% fprintf('Tamaño del array: %.1f × %.1f mm\n', L*1000, L*1000);
% fprintf('Número total de elementos: %d\n', N_total);
% fprintf('Ancho de haz a -3dB: %.2f°\n', BW_3dB_deg);
% fprintf('Directividad obtenida: %.2f dBi\n', D_actual_dBi);
% 
% % Guardar datos
% save('array_design_data.mat', 'f', 'lambda', 'L', 'N_per_side', 'N_total', 'BW_3dB_deg');

