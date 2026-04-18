% %% Diseño de Array en Fase Lineal - Ejercicio 1
% clear; clc; close all;
% 
% % Especificaciones
% f = 4.7e9;           % Frecuencia [Hz]
% D_dBi = 14;         % Directividad [dBi]
% c = 3e8;            % Velocidad de la luz [m/s]
% 
% fprintf('=== DISEÑO DE ARRAY EN FASE LINEAL ===\n');
% fprintf('Frecuencia: %.0f GHz\n', f/1e9);
% fprintf('Directividad requerida: %.0f dBi\n\n', D_dBi);
% 
% %% a) Cálculo del tamaño de la antena
% lambda = c/f;                % Longitud de onda [m]
% D_linear = 10^(D_dBi/10);    % Conversión a valor lineal
% 
% % Para un array lineal uniformemente alimentado:
% % D ≈ 2 * L / λ  →  L = D * λ / 2
% L = D_linear * lambda / 2;   % Longitud del array [m]
% 
% fprintf('a) TAMAÑO DE LA ANTENA:\n');
% fprintf('   Longitud de onda: λ = %.4f mm\n', lambda*1000);
% fprintf('   Longitud requerida del array: L = %.4f m = %.1f mm\n', L, L*1000);
% 
% %% b) Cálculo del número de elementos
% d = 0.7*lambda;       % Separación entre elementos [m]
% N = 4; % Número de elementos
% N_total = N;
% 
% fprintf('\nb) NÚMERO DE ELEMENTOS (ARRAY LINEAL):\n');
% fprintf('   Separación entre elementos: d = λ/2 = %.4f mm\n', d*1000);
% fprintf('   Número de elementos: N = %.0f\n', N_total);
% 
% % Verificación de directividad aproximada
% D_actual = 2 * (N * d) / lambda;  % D ≈ 2L/λ con L = N·d
% D_actual_dBi = 10*log10(D_actual);
% fprintf('   Directividad obtenida: %.2f dBi\n', D_actual_dBi);
% 
% %% c) Cálculo del ancho de haz a -3dB
% % Aproximación empírica: BW_3dB ≈ 50.8 / (N*d/λ)
% BW_3dB_deg = 50.8 / (N * d / lambda);
% 
% fprintf('\nc) ANCHO DE HAZ A -3dB:\n');
% fprintf('   BW_3dB = %.2f°\n', BW_3dB_deg);
% 
% %% PROGRAMA GENERAL PARA PATRÓN DE ARRAY EN FASE
% fprintf('\n=== PROGRAMA GENERAL DE ARRAY EN FASE ===\n');
% 
% beam_steering_theta = input('Ingrese ángulo de steering en theta [grados] (0 para broadside): ');
% if isempty(beam_steering_theta)
%     beam_steering_theta = 0;
% end
% beam_steering_theta = deg2rad(beam_steering_theta);
% 
% % Opciones de distribución de amplitud
% fprintf('\nOpciones de distribución de amplitud:\n');
% fprintf('1 - Uniforme\n');
% fprintf('2 - Triangular\n');
% fprintf('3 - Binomial\n');
% amp_option = input('Seleccione distribución (1-3) [1 por defecto]: ');
% if isempty(amp_option)
%     amp_option = 1;
% end
% 
% %% Coordenadas de los elementos (solo eje X)
% x_pos = (-(N-1)/2:(N-1)/2) * d;
% 
% %% Distribución de amplitud
% amplitude = ones(1, N);
% switch amp_option
%     case 2 % Triangular
%         for i = 1:N
%             amplitude(i) = 1 - 0.8 * abs(i - (N+1)/2) / ((N-1)/2);
%         end
%     case 3 % Binomial
%         binom_coeff = @(n,k) factorial(n)/(factorial(k)*factorial(n-k));
%         for i = 1:N
%             amplitude(i) = binom_coeff(N-1, i-1);
%         end
%         amplitude = amplitude / max(amplitude);
% end
% 
% %% Fases para beam steering
% kx = 2*pi/lambda * sin(beam_steering_theta);
% phase = -kx * x_pos;
% 
% %% Cálculo del patrón de radiación
% theta_range = deg2rad(-90:0.5:90);
% AF = zeros(size(theta_range));
% 
% for idx = 1:length(theta_range)
%     theta = theta_range(idx);
%     psi = 2*pi/lambda * d * sin(theta);
%     sum_AF = sum(amplitude .* exp(1j * (phase + (0:N-1) * psi)));
%     AF(idx) = abs(sum_AF);
% end
% 
% AF = AF / max(AF);
% AF_dB = 20*log10(AF);
% 
% %% Visualización
% figure('Position', [100, 100, 1200, 800]);
% 
% % Subplot 1: Distribución de amplitud
% subplot(2,3,1);
% stem(x_pos*1000, amplitude, 'filled');
% xlabel('x [mm]'); ylabel('Amplitud');
% title('Distribución de Amplitud');
% grid on;
% 
% % Subplot 2: Distribución de fase
% subplot(2,3,2);
% plot(x_pos*1000, rad2deg(phase), 'o-', 'LineWidth', 1.5);
% xlabel('x [mm]'); ylabel('Fase [°]');
% title('Distribución de Fase');
% grid on;
% 
% % Subplot 3: Patrón de radiación en dB
% subplot(2,3,3);
% plot(rad2deg(theta_range), AF_dB, 'b-', 'LineWidth', 2);
% grid on;
% xlabel('θ [grados]'); ylabel('|AF| [dB]');
% title('Patrón de Radiación (Plano E)');
% xlim([-90, 90]); ylim([-40, 0]);
% line([-90,90], [-3,-3], 'Color','red','LineStyle','--');
% legend('Patrón', '-3 dB');
% 
% % Subplot 4: Patrón lineal
% subplot(2,3,4);
% plot(rad2deg(theta_range), AF, 'b-', 'LineWidth', 2);
% xlabel('θ [grados]'); ylabel('|AF| [lineal]');
% title('Patrón de Radiación (Lineal)');
% grid on; xlim([-90, 90]); ylim([0, 1]);
% 
% % Subplot 5: Patrón polar
% subplot(2,3,5);
% polarplot(theta_range, AF, 'b-', 'LineWidth', 2);
% title('Patrón Polar');
% 
% % Subplot 6: Información del diseño
% subplot(2,3,6);
% axis off;
% info_str = {
%     sprintf('RESUMEN DEL DISEÑO:'),
%     sprintf('Frecuencia: %.0f GHz', f/1e9),
%     sprintf('λ = %.4f mm', lambda*1000),
%     sprintf(''),
%     sprintf('ARRAY LINEAL:'),
%     sprintf('Longitud: %.1f mm', L*1000),
%     sprintf('Nº de elementos: %d', N_total),
%     sprintf('Separación: %.2f mm', d*1000),
%     sprintf(''),
%     sprintf('CARACTERÍSTICAS:'),
%     sprintf('Directividad: %.2f dBi', D_actual_dBi),
%     sprintf('BW -3dB: %.2f°', BW_3dB_deg),
%     sprintf(''),
%     sprintf('CONFIGURACIÓN:'),
%     sprintf('Steering θ: %.1f°', rad2deg(beam_steering_theta)),
%     sprintf('Dist. amplitud: %d', amp_option)
% };
% text(0.1, 0.9, info_str, 'VerticalAlignment', 'top', 'FontSize', 10);
% 
% sgtitle('Diseño de Array Lineal en Fase a 30 GHz', ...
%     'FontSize', 14, 'FontWeight', 'bold');
% 
% %% Resultados en consola
% fprintf('\n=== RESULTADOS FINALES ===\n');
% fprintf('Longitud del array: %.1f mm\n', L*1000);
% fprintf('Número total de elementos: %d\n', N_total);
% fprintf('Ancho de haz a -3dB: %.2f°\n', BW_3dB_deg);
% fprintf('Directividad obtenida: %.2f dBi\n', D_actual_dBi);
% 
% % Guardar datos
% save('array_lineal_design_data.mat', 'f', 'lambda', 'L', 'N', ...
%     'N_total', 'BW_3dB_deg', 'D_actual_dBi');
clc;clear;close all;
N = 4; % número de parches

% Coeficientes binomiales
binom_coeff = zeros(1,N);
for k = 0:N-1
    binom_coeff(k+1) = nchoosek(N-1,k);
end

% Amplitudes normalizadas (máximo = 1)
A_norm = binom_coeff / max(binom_coeff);

% Potencias relativas (cuadrado de amplitud)
P_rel = A_norm.^2;

% Normalizar para que la suma total sea 1
P_rel = P_rel / sum(P_rel);

% Convertir a dB
P_dB = 10*log10(P_rel);

% Y si quieres recuperar la potencia lineal desde dB:
P_lineal = 10.^(P_dB/10);

% Mostrar resultados
fprintf('Elemento\tCoef Binomial\tP_rel\t\tP_dB [dB]\tP_lineal (10^(dB/10))\n');
for k = 1:N
    fprintf('%d\t\t%.0f\t\t%.4f\t\t%.2f\t\t%.4f\n', ...
        k, binom_coeff(k), P_rel(k), P_dB(k), P_lineal(k));
end
