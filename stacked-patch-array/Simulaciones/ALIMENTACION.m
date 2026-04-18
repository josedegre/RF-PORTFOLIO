clc; clear; close all;

% Definir el rango de ZL_parche de 35 a 50 en pasos de 1
ZL_parche_valores = 35:0.1:50;

% Crear arrays para almacenar los resultados
resultados_Z_adapt = zeros(length(ZL_parche_valores), 6);
resultados_L = zeros(length(ZL_parche_valores), 4);

% Bucle principal para cada valor de ZL_parche
for i = 1:length(ZL_parche_valores)
    ZL_parche = ZL_parche_valores(i);
    
    % Cálculos existentes (sin cambios)
    P1 = 10^(-1/10); P2 = 10^(-1/10); P3 = 10^(-1/10); P4 = 10^(-1/10);
    P1_2 = P1 + P2;
    P3_4 = P3 + P4;
    ZL = 50;
    
    Z1 = 100;
    Z2 = P1 * Z1 / P2;
    Z_UNION_1_2 = Z1 * Z2 / (Z1 + Z2);
    
    Z1_2 = 100;
    Z3_4 = P1_2 * Z1_2 / P3_4;
    Z_ENTRADA = Z1_2 * Z3_4 / (Z1_2 + Z3_4);
    Z_intermedia = (Z1 + ZL_parche) / 2;
    
    % Adaptadores en λ/4
    Z_adapt_1 = sqrt(Z_intermedia * ZL_parche);
    Z_adapt_2 = sqrt(Z_intermedia * Z1);
    
    Z_intermedia_2 = (Z_UNION_1_2 + Z1_2) / 2;
    Z_adapt_3 = sqrt(Z_UNION_1_2 * Z_intermedia_2);
    Z_adapt_4 = sqrt(Z_intermedia_2 * Z1_2);
    
    Z_intermedia_3 = (Z_ENTRADA + ZL) / 2;
    Z_adapt_5 = sqrt(Z_ENTRADA * Z_intermedia_3);
    Z_adapt_6 = sqrt(Z_intermedia_3 * ZL);
    
    % DESFASE
    theta = 5;
    K_o = 2 * pi;
    lambda = 0.3 / 5.2 * 1000;
    d = 0.5*lambda;
    Alpha = -K_o * d * sind(-theta);
    
    L1 = 90;
    L2 = L1 + Alpha;
    L3 = L1 + 2*Alpha;
    L4 = L1 + 3*Alpha;
    
    % Almacenar resultados
    resultados_Z_adapt(i, :) = [Z_adapt_1, Z_adapt_2, Z_adapt_3, Z_adapt_4, Z_adapt_5, Z_adapt_6];
    resultados_L(i, :) = [L1, L2, L3, L4];
    
    % Mostrar resultados para cada valor
    fprintf('ZL_parche = %.1f Ω:\n', ZL_parche);
    fprintf('  Z_adapt: %.3f, %.3f, %.3f, %.3f, %.3f, %.3f\n', ...
            Z_adapt_1, Z_adapt_2, Z_adapt_3, Z_adapt_4, Z_adapt_5, Z_adapt_6);
    fprintf('  L: %.3f, %.3f, %.3f, %.3f\n\n', L1, L2, L3, L4);
end

% Opcional: Mostrar tabla resumen
fprintf('\n=== RESUMEN DE RESULTADOS ===\n');
fprintf('ZL_parche\tZ_adapt1\tZ_adapt2\tZ_adapt3\tZ_adapt4\tZ_adapt5\tZ_adapt6\n');
for i = 1:length(ZL_parche_valores)
    fprintf('%.1f\t\t', ZL_parche_valores(i));
    fprintf('%.3f\t\t', resultados_Z_adapt(i, :));
    fprintf('\n');
end

% También puedes guardar los resultados en variables del workspace si lo necesitas
ZL_parche_resultados = ZL_parche_valores;
Z_adapt_resultados = resultados_Z_adapt;
L_resultados = resultados_L;