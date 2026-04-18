% Limpiar el espacio de trabajo
close all
clear
clc

% Definir parámetros
f = 4.85e9;
lambda0 = 3e8 / f;
k0 = (2 * pi) / lambda0;
theta = -90:0.1:90;

% Elemento radiante aproximado (coseno)
E0 = cos(theta * pi / 180);
plot(theta,E0);
axis([-90 90 0 1]);
xlabel('\theta [º]');
ylabel('E_0 [lineales]');
title('Diagrama de radiación del elemento unitario')

N = 16;
a = ones(1, N);
d = lambda0 / 2;
alpha = 0;

% Calcular el factor de array
F_A = zeros(size(theta));
num = 0:N-1;

for i = 1:length(theta)
    F_A(i) = sum(a .* exp(1i * num * (k0 * d * sin(theta(i) * pi / 180) + alpha)));
end

% Calcular el campo total radiado por el array
E_A = E0 .* F_A;

% Normalizar el campo radiado
E_A_norm = E_A / max(abs(E_A));

% Calcular el factor de array en dB
E_A_dB = 20 * log10(abs(E_A_norm));

% Graficar el campo total radiado normalizado
figure;
plot(theta, E_A_dB);
title('Campo Total Radiado Normalizado');
xlabel('Ángulo \theta (º)');
ylabel('|E_A| (dB)');
grid on;
axis([-90 90 -110 0])

%% CASO 1:
N = 36;
a = ones(1, N);
d = lambda0 / 2;
alpha = 0;

% Calcular el factor de array
F_A = zeros(size(theta));
num = 0:N-1;

for i = 1:length(theta)
    F_A(i) = sum(a .* exp(1i * num * (k0 * d * sin(theta(i) * pi / 180) + alpha)));
end

% Calcular el campo total radiado por el array
E_A = E0 .* F_A;

% Normalizar el campo radiado
E_A_norm = E_A / max(abs(E_A));

% Calcular el factor de array en dB
E_A_dB = 20 * log10(abs(E_A_norm));

% Graficar el campo total radiado normalizado
figure;
plot(theta, E_A_dB);
title('Campo Total Radiado Normalizado');
xlabel('Ángulo \theta (grados)');
ylabel('|E_A| (dB)');
grid on;
axis([-90 90 -110 0])

%% CASO 2
N = 8;
a = ones(1, N);
d = lambda0*(3/4);
alpha = -1.99154164;

% Calcular el factor de array
F_A = zeros(size(theta));
num = 0:N-1;

for i = 1:length(theta)
    F_A(i) = sum(a .* exp(1i * num * (k0 * d * sin(theta(i) * pi / 180) + alpha)));
end

% Calcular el campo total radiado por el array
E_A = E0 .* F_A;

% Normalizar el campo radiado
E_A_norm = E_A / max(abs(E_A));

% Calcular el factor de array en dB
E_A_dB = 20 * log10(abs(E_A_norm));

% Graficar el campo total radiado normalizado
figure;
plot(theta, E_A_dB);
title('Campo Total Radiado Normalizado');
xlabel('Ángulo \theta (grados)');
ylabel('|E_A| (dB)');
grid on;
axis([-90 90 -110 0])

%% CASO 3
N = 8;
w = taylorwin(N,3,-25);
a=w';
d = lambda0*(3/4);
alpha = 0;

% Calcular el factor de array
F_A = zeros(size(theta));
num = 0:N-1;

for i = 1:length(theta)
    F_A(i) = sum(a .* exp(1i * num * (k0 * d * sin(theta(i) * pi / 180) + alpha)));
end

% Calcular el campo total radiado por el array
E_A = E0 .* F_A;

% Normalizar el campo radiado
E_A_norm = E_A / max(abs(E_A));

% Calcular el factor de array en dB
E_A_dB = 20 * log10(abs(E_A_norm));

% Graficar el campo total radiado normalizado
figure;
plot(theta, E_A_dB);
title('Campo Total Radiado Normalizado');
xlabel('Ángulo \theta (grados)');
ylabel('|E_A| (dB)');
grid on;
axis([-90 90 -110 0])

%% PARTE 2
close all
clear
clc

% Definir parámetros
f = 4.85e9;
lambda0 = 3e8 / f;
k0 = (2 * pi) / lambda0;
theta = -90:0.1:90;

% Elemento radiante aproximado (coseno)
E0 = cos(theta * pi / 180);

N = 4;
a = ones(1, N);
d = 37e-3;
alpha = 0;

% Calcular el factor de array
F_A = zeros(size(theta));
num = 0:N-1;

for i = 1:length(theta)
    F_A(i) = sum(a .* exp(1i * num * (k0 * d * sin(theta(i) * pi / 180) + alpha)));
end

% Calcular el campo total radiado por el array
E_A = E0 .* F_A;

% Normalizar el campo radiado
E_A_norm = E_A / max(abs(E_A));

% Calcular el factor de array en dB
E_A_dB = 20 * log10(abs(E_A_norm));

% Graficar el campo total radiado normalizado
figure;
plot(theta, E_A_dB);
title('Campo Total Radiado Normalizado');
xlabel('Ángulo \theta (grados)');
ylabel('|E_A| (dB)');
grid on;
axis([-90 90 -90 0])

