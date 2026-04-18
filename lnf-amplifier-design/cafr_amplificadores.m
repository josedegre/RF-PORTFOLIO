clear, clc, close all;

%% Definicion de Variables e Importar parametros S
f=2e9;
GT_dB=16.3;
Z0=50;
gammaOPT=0.86*exp(1j*13.9*pi/180);
NFmin_dB = 0.36;
Fmin      = 10^(NFmin_dB/10);   % factor de ruido mínimo
Rn        = 0.23;               % ohmios

S=sparameters('mgf4921am_2a6GHz_10mA.s2p');
freq=S.Frequencies;
S=S.Parameters;

% Índice de la frecuencia más cercana a f
[~, idx] = min(abs(freq - f));

% Parámetros S a esa frecuencia
S = S(:,:,idx);       % matriz Nport x Nport

S11 = S(1,1);
S21 = S(2,1);
S12 = S(1,2);
S22 = S(2,2);

%% Utilidades
GL = @(GamL) (1 - abs(GamL).^2) ./ abs(1 - S22.*GamL).^2;
GS = @(GamS) (1 - abs(GamS).^2) ./ abs(1 - S11.*GamS).^2;
F_fun  = @(GamS) Fmin + (4*Rn/Z0) .* ...
    (abs(GamS - gammaOPT).^2 ./ ((1 - abs(GamS).^2) * abs(1 + gammaOPT)^2));


%% ------------------ Test de estabilidad K - Delta y mu ------------------
Delta = S11*S22 - S12*S21;

K = (1 - abs(S11)^2 - abs(S22)^2 + abs(Delta)^2) / ( 2*abs(S12*S21) );
mu = (1 - abs(S11)^2) / ( abs(S22 - Delta*conj(S11)) + abs(S12*S21) );

fprintf('f = %.3f GHz\n', f/1e9);
fprintf('|Delta| = %.4f\n', abs(Delta));
fprintf('K       = %.3f\n', K);
fprintf('mu      = %.3f\n\n', mu);

if (K>1) && (abs(Delta)<1)
    fprintf('=> El transistor es incondicionalmente estable según K-Delta.\n');
else
    fprintf('=> El transistor es CONDICIONALMENTE estable.\n');
end

if mu > 1
    fprintf('=> mu > 1: margen de estabilidad aceptable.\n');
else
    fprintf('=> mu <= 1: margen de estabilidad pobre.\n');
end

% ------------------ Círculos de estabilidad analíticos ------------------
phi = linspace(0,2*pi,400);

% Fuente (plano Gamma_S)
Cs_est = conj((S11 - Delta*conj(S22))) / (abs(S11)^2 - abs(Delta)^2);
Rs_est = abs(S12*S21 / (abs(S11)^2 - abs(Delta)^2));
Gamma_circle_S = Cs_est + Rs_est*exp(1j*phi);

% Carga (plano Gamma_L)
CL_est = conj((S22 - Delta*conj(S11))) / (abs(S22)^2 - abs(Delta)^2);
RL_est = abs(S12*S21 / (abs(S22)^2 - abs(Delta)^2));
Gamma_circle_L = CL_est + RL_est*exp(1j*phi);

% ------------------ Regiones estables numéricas ------------------
% Malla densa dentro del círculo unidad
Nr = 200; Nth = 400;
r   = linspace(0,0.99,Nr);
th  = linspace(-pi,pi,Nth);
[RR, TT] = meshgrid(r, th);
Gamma_grid = RR .* exp(1j*TT);

% --- Región estable en plano de carga (Gamma_L):
% Estabilidad respecto a la fuente: |Gamma_in| < 1
GammaL_grid = Gamma_grid;
Gamma_in = S11 + (S12*S21 .* GammaL_grid) ./ (1 - S22 .* GammaL_grid);
mask_stable_L = abs(Gamma_in) < 1;

% --- Región estable en plano de fuente (Gamma_S):
% Estabilidad respecto a la carga: |Gamma_out| < 1
GammaS_grid = Gamma_grid;
Gamma_out = S22 + (S12*S21 .* GammaS_grid) ./ (1 - S11 .* GammaS_grid);
mask_stable_S = abs(Gamma_out) < 1;

% ------------------ Plot: plano de FUENTE ------------------
figure('color','white');
hS = smithplot;
hold on;

% --- puntos estables (fuente) ---
Gs_stable = GammaS_grid(mask_stable_S);
hRegionS = plot(real(Gs_stable), imag(Gs_stable), '.', ...
                'MarkerSize', 3);    % lo que se ve en la figura

% --- círculo de estabilidad analítico (fuente) ---
hCircleS = plot(real(Gamma_circle_S), imag(Gamma_circle_S), 'k', ...
                'LineWidth', 1.5);

% --- curva dummy solo para la leyenda (misma apariencia que una línea) ---
hDummyRegionS = plot(NaN, NaN, '-', ...
                     'Color', get(hRegionS,'Color'), ...
                     'LineWidth', 1.5);

title('Plano de fuente: regiones estables y círculo de estabilidad');

% Leyenda usando el dummy + el círculo
lg = legend([hDummyRegionS hCircleS], ...
    'Región estable (|\Gamma_{out}|<1)', ...
    'Círculo de estabilidad (fuente)', ...
    'Location','best');
lg.FontSize = 18;

% ------------------ Plot: plano de CARGA ------------------
figure('color','white');
hL = smithplot;
hold on;

% --- puntos estables (carga) ---
Gl_stable = GammaL_grid(mask_stable_L);
hRegion = plot(real(Gl_stable), imag(Gl_stable), '.', ...
               'MarkerSize', 3);   % esto es lo que se ve

% --- círculo de estabilidad analítico ---
hCircle = plot(real(Gamma_circle_L), imag(Gamma_circle_L), 'k', ...
               'LineWidth', 1.5);

% --- curva dummy solo para la leyenda (misma color que los puntos) ---
hDummyRegion = plot(NaN, NaN, '-', ...
                    'Color', get(hRegion,'Color'), ...
                    'LineWidth', 1.5);

title('Plano de carga: regiones estables y círculo de estabilidad');

% En la leyenda usamos el dummy + el círculo
lg = legend([hDummyRegion hCircle], ...
    'Región estable (|Γ_{in}|<1)', ...
    'Círculo de estabilidad (carga)', ...
    'Location','best');
lg.FontSize = 18;


%% Diseño Unilateral

U=abs(S11)*abs(S21)*abs(S12)*abs(S22)/((1-abs(S11)^2)*(1-abs(S22)^2));

G0=abs(S21)^2;
G0_dB=10*log10(G0);


% Suponiendo la menor figura de ruido gammaS=gammaOPT
gammaS=gammaOPT;
Gs_Fmin=GS(gammaS);
Gs_Fmin_dB=10*log10(Gs_Fmin);
gammaL=conj(S22);
GL_max=GL(gammaL);
GL_max_dB=10*log10(GL_max);

G_TU=Gs_Fmin_dB+G0_dB+GL_max_dB;

fprintf('Ganancia unilateral máxima con NF mínimo: %.2f dB\n', G_TU);
fprintf('Ganancia objetivo: %.2f dB\n', GT_dB);

if G_TU < GT_dB
    fprintf('==> La ganancia UNILATERAL con NF mínimo es INSUFICIENTE (%.2f dB por debajo de la especificación).\n', ...
            GT_dB - G_TU);
else
    fprintf('==> La ganancia cumple la especificación.\n');
end

% Hay que buscar la GS que ofrezca la menor figura de ruido y que se cumpla la GT

Gs_req_dB = GT_dB - (G0_dB + GL_max_dB);      % lo que debe aportar la fuente
Gs_req = 10^(Gs_req_dB/10);       % lineal


% Barrido sobre la carta de Smith para buscar rhoS
Ngamma   = 10001;
Ntheta = 1441;
gamma    = linspace(0,0.99,Ngamma);     % magnitud de Gamma_S
theta  = linspace(-pi,pi,Ntheta);   % ángulo
[RR,TT] = meshgrid(gamma,theta);
gammaS_grid = RR .* exp(1j*TT);       % todos los posibles Gamma_S

Gs_grid_lin = GS(gammaS_grid);
Gs_grid_dB  = 10*log10(Gs_grid_lin);

% Figura de ruido para cada punto
F_grid    = F_fun(gammaS_grid);
NF_grid_dB = 10*log10(F_grid);

% Condición: Gs = Gs_req (con un pequeño margen)
margen_dB = 0.001;   % ajustar el margen
mask = Gs_grid_dB >= (Gs_req_dB - margen_dB);

% Entre los que cumplen ganancia, buscamos mínimo NF
NF_masked = NF_grid_dB;
NF_masked(~mask) = inf;    % descartamos puntos que no cumplen la ganancia

[NF_best_dB, idx_best] = min(NF_masked(:));

if isinf(NF_best_dB)
    error('No se ha encontrado ningún rhoS que cumpla la ganancia requerida.');
end

gammaS_best    = gammaS_grid(idx_best);
Gs_best_dB   = Gs_grid_dB(idx_best);
Gs_best_lin  = Gs_grid_lin(idx_best);

% Resultados
fprintf('\n=== Diseño compromiso (unilateral) ===\n');
fprintf('Gs_req = %.3f dB\n', Gs_req_dB);
fprintf('GammaS_best: |%.3f| ang=%.1f deg\n', ...
    abs(gammaS_best), angle(gammaS_best)*180/pi);
fprintf('Gs(GammaS_best) = %.3f dB\n', Gs_best_dB);
fprintf('NF(GammaS_best) = %.3f dB (NFmin = %.3f dB)\n', NF_best_dB, NFmin_dB);

% Impedancia equivalente de fuente
Zs_best = Z0 * (1 + gammaS_best) / (1 - gammaS_best);
fprintf('Zs_best = %.2f + j%.2f ohm\n', real(Zs_best), imag(Zs_best));

% Ganancia total que obtendrías con este rhoS y GL_max
GT_best_dB = Gs_best_dB + G0_dB + GL_max_dB;
fprintf('GT con GammaS_best y GL_max = %.3f dB (objetivo %.3f dB)\n', ...
    GT_best_dB, GT_dB);



%% PLOT DE IMPEDANCIAS SELECCIONADAS Y CIRCULOS DE GANANCIA Y NF
% Impedancias de entrada y salida del diseño

% Entrada (GammaS_best)
Zs_best = Z0 * (1 + gammaS_best) / (1 - gammaS_best);
fprintf('\nImpedancia de entrada (diseño): Zs_best = %.2f + j%.2f ohm\n', ...
        real(Zs_best), imag(Zs_best));

% Salida (GammaL = conj(S22))
ZL_best = Z0 * (1 + gammaL) / (1 - gammaL);
fprintf('Impedancia de salida (diseño): ZL_best = %.2f + j%.2f ohm\n', ...
        real(ZL_best), imag(ZL_best));


% ================= Carta de Smith de ENTRADA =================
%   - círculo de ganancia normalizada g_S constante (Gs_req)
%   - círculo de figura de ruido constante (NF = NF_best_dB)
%   - punto GammaS_best

figure('color','white');
smithplot; hold on;

% Ganancia máxima de entrada (unilateral)
Gs_max = 1 / (1 - abs(S11)^2);          % lineal
gS_req = Gs_req / Gs_max;               % ganancia normalizada g_S = Gs/Gs_max

% ---------------- CÍRCULO DE ESTABILIDAD (FUENTE) ----------------
Delta = S11*S22 - S12*S21;

Cs_est = conj((S11 - Delta*conj(S22))) / (abs(S11)^2 - abs(Delta)^2);
Rs_est = abs(S12*S21 / (abs(S11)^2 - abs(Delta)^2));

phi = linspace(0,2*pi,400);
Gamma_circle_EstabS = Cs_est + Rs_est * exp(1j*phi);
plot(real(Gamma_circle_EstabS), imag(Gamma_circle_EstabS), '-', 'LineWidth', 1.5);

% ----------- CÍRCULO gS (usando fórmulas correctas de diapositiva) -------
Cs = (gS_req * conj(S11)) / ( 1 - (1 - gS_req)*abs(S11)^2 );
Rs = sqrt( 1 - gS_req)*(1 - abs(S11)^2) / (1 - (1 - gS_req)*abs(S11)^2 );


Gamma_circle_Gs = Cs + Rs * exp(1j*phi);
plot(real(Gamma_circle_Gs), imag(Gamma_circle_Gs), 'LineWidth', 1.5);

% Círculo de figura de ruido constante NF = NF_best_dB
Ftarget = 10^(NF_best_dB/10);   % factor de ruido objetivo

N = (Ftarget - Fmin) * abs(1 + gammaOPT)^2 / (4*Rn/Z0);

Cf = gammaOPT / (N + 1);
Rf = sqrt( N * (N + 1 - abs(gammaOPT)^2) ) / (N + 1);

Gamma_circle_NF = Cf + Rf * exp(1j*phi);
plot(real(Gamma_circle_NF), imag(Gamma_circle_NF), ':', 'LineWidth', 1.5);


% Punto de diseño GammaS_best
plot(real(gammaS_best), imag(gammaS_best), 'rx', 'MarkerSize', 8, 'LineWidth', 2);

title('Entrada: círculos de g_S y NF');
lg=legend('Círculo de Estabilidad de Fuente','Círculo g_S = const', 'Círculo NF = const', '\Gamma_S^{best}', ...
       'Location', 'best');
lg.FontSize = 18;


% ================= Carta de Smith de SALIDA ==================
%   - punto GammaL = conj(S22)

figure('color','white');
smithplot; hold on;

% ---------------- CÍRCULO DE ESTABILIDAD (CARGA) ----------------
CL_est = conj((S22 - Delta*conj(S11))) / (abs(S22)^2 - abs(Delta)^2);
RL_est = abs(S12*S21 / (abs(S22)^2 - abs(Delta)^2));

Gamma_circle_EstabL = CL_est + RL_est * exp(1j*phi);
plot(real(Gamma_circle_EstabL), imag(Gamma_circle_EstabL), '-', 'LineWidth', 1.5);

% Impedancia de diseño
plot(real(gammaL), imag(gammaL), 'bx', 'MarkerSize', 8, 'LineWidth', 2);
% text(real(gammaL)+0.05, imag(gammaL), ...
%     sprintf('Z_L = %.1f + j%.1f \\Omega', real(ZL_best), imag(ZL_best)), ...
%     'FontSize', 10);

title('Salida: punto de carga \Gamma_L');
lg=legend('Círculo de Estabilidad de Carga','\Gamma_L^{best}', 'Location', 'best');
lg.FontSize = 18;

