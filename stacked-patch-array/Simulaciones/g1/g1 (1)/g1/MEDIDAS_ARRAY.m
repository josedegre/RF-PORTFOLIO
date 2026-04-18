
clc;clear;close all;

S11_medido = readmatrix('g1_s11.txt');
S11_simulado = readmatrix('s11.txt');

figure(1)
plot(S11_medido(:,1)./(10^9), S11_medido(:,2), 'LineWidth', 2);
grid on;
xlabel("frecuencia [GHz]");
ylabel("S11 [dB]");
title("Parametros de adaptación de la antena completa");
hold on

plot(S11_simulado(:,1), S11_simulado(:,2), '--', 'LineWidth', 2);
grid on;
xlabel("frecuencia [GHz]");
ylabel("S11 [dB]");
title("Respuesta del Array Medida vs Simulada ");
legend("Medida","Simulada");



%%
clc;clear;close all;

M = readmatrix('.\G1.xlsx');
M3= readmatrix('.\cop.txt');
M2= readmatrix('.\contra.txt');
M4=readmatrix('.\DIRECTIVIDAD_GANANCIA.txt');
size(M)
fila_ini = 1;
fila_fin = 121;
fila_fin2 = 41;
fila_fin3 = 361;
fila_fin4 = 21;


x1 = M(fila_ini:fila_fin, 1);
x1p = M2(fila_ini:fila_fin3, 1);

figure(1)
plot(x1, M(fila_ini:fila_fin, 2), 'LineWidth', 1.2); hold on;                      % Medido
plot(x1, M(fila_ini:fila_fin, 3), 'LineWidth', 1.2);                              % Medido
plot(x1p, M2(fila_ini:fila_fin3, 2), '--', 'LineWidth', 1.5);                     % Simulado (discontinuo)
plot(x1p, M3(fila_ini:fila_fin3, 2), '--', 'LineWidth', 1.5);                     % Simulado (discontinuo)
ylim([-40,20])
xlim([-180,180])
grid on;
xlabel("\Theta º");
ylabel("[dB]");
title("Diagrama de radiación no normalizado");
legend("Contrapolar Medida","Copolar Medida","Copolar Simulada","Contrapolar Simulada ");

figure(2)
plot(-x1, M(fila_ini:fila_fin, 2), 'LineWidth', 1.2); hold on;                    % Medido
plot(-x1, M(fila_ini:fila_fin, 3), 'LineWidth', 1.2);                              % Medido
plot(x1p, M2(fila_ini:fila_fin3, 2), '--', 'LineWidth', 1.5);                     % Simulado (discontinuo)
plot(x1p, M3(fila_ini:fila_fin3, 2), '--', 'LineWidth', 1.5);                     % Simulado (discontinuo)
ylim([-40,20])
xlim([-180,180])

grid on;
xlabel("\Theta º");
ylabel("[dB]");
title("Diagrama diagrama de radiación no normalizado");
legend("Contrapolar Medida","Copolar Medida","Copolar Simulada","Contrapolar Simulada ");

x2 = M(fila_ini:fila_fin2, 5);
x3 = M4(fila_ini:fila_fin4, 1);

figure(3)
plot(x2, M(fila_ini:fila_fin2, 6), 'LineWidth', 1.2); hold on;
plot(x2, M(fila_ini:fila_fin2, 7), 'LineWidth', 1.2);
plot(x3, M4(fila_ini:fila_fin4, 2), '--', 'LineWidth', 1.2);
plot(x3, M4(fila_ini:fila_fin4, 3), '--', 'LineWidth', 1.2);


grid on;
xlabel("frecuencia [GHz]");
ylabel("[dBi]");
title("Directividad Y Ganancia");
legend("Directividad Medida","Ganancia Medida", "Directividad Simulada","Ganancia Simulada");

max1=13.96;
max2=max(M2(:,2));
% === Datos ===
x  = -x1;                                      % Curvas medidas
xS = x1p;                                      % Curvas simuladas (discontinuas)

y1 = M(fila_ini:fila_fin,   2) - max1;         % Contrapolar Medida
y2 = M(fila_ini:fila_fin,   3) - max1;         % Copolar Medida

y3 = M2(fila_ini:fila_fin3, 2) - max2;         % Copolar Simulada
y4 = M3(fila_ini:fila_fin3, 2) - max2;         % Contrapolar Simulada

y_target = -3;                                 % Corte a -3 dB


% === Calcular cruces ===
x_cross1 = cruces(x,  y1, y_target);   % Contrapolar medida
x_cross2 = cruces(x,  y2, y_target);   % Copolar medida
x_cross3 = cruces(xS, y3, y_target);   % Copolar simulada
x_cross4 = cruces(xS, y4, y_target);   % Contrapolar simulada


% === Mostrar valores de corte ===
disp("Cruces curva 1 (Contrapolar Medida):");
disp(x_cross1);

disp("Cruces curva 2 (Copolar Medida):");
disp(x_cross2);

disp("Cruces curva 3 (Copolar Simulada):");
disp(x_cross3);

disp("Cruces curva 4 (Contrapolar Simulada):");
disp(x_cross4);


% === GRÁFICA COMPLETA ===
figure(4)
plot(x,  y1, 'LineWidth', 1.2); hold on;
plot(x,  y2, 'LineWidth', 1.2);

plot(xS, y3, '--', 'LineWidth', 1.5);
plot(xS, y4, '--', 'LineWidth', 1.5);

yline(y_target);

% Marcar puntos de corte
plot(x_cross1, y_target*ones(size(x_cross1)), 'ro', 'LineWidth', 2);
plot(x_cross2, y_target*ones(size(x_cross2)), 'bo', 'LineWidth', 2);

plot(x_cross3, y_target*ones(size(x_cross3)), 'rs', 'LineWidth', 2);
plot(x_cross4, y_target*ones(size(x_cross4)), 'bs', 'LineWidth', 2);

ylim([-60,0])
xlim([-180,180])
grid on;

xlabel("\Theta º");
ylabel("[dB]");
title("Diagrama de radiación normalizado");

legend("Contrapolar Medida","Copolar Medida", ...
       "Copolar Simulada","Contrapolar Simulada");

ANCHO_THETA_MENOS_3DB_MEDIDA=3.4756+14.5027;
ANCHO_THETA_MENOS_3DB_SIM=4.1372+14.39;

% === Función de cruces ===
function xc = cruces(x, y, y_target)
    xc = [];
    for k = 1:length(x)-1
        yk1 = y(k) - y_target;
        yk2 = y(k+1) - y_target;

        if yk1 * yk2 < 0
            xc(end+1) = x(k) + (x(k+1)-x(k)) * abs(yk1)/(abs(yk1)+abs(yk2));
        end
    end
end
