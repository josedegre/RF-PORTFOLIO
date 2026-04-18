clear, clc, close all
%% Respuesta combinador gysel con lineas ideales


% --- Parámetros ---
Z0   = 50;                   % Ohm
f0   = 2.5e9;                % Hz (frecuencia de diseño)
f    = linspace(1.5e9,3.5e9,2001);
N = numel(f);
c    = physconst('lightspeed');
theta_H1=pi/2*f./f0;
theta_H2=pi*f./f0;
theta_V=pi/2*f./f0;

% Impedancias típicas (ajústalas si tu diseño lo requiere)
ZH1  = sqrt(2)*Z0;           % brazos serie (lambda/4)
u    = 0.75;                 % factor de ajuste para ramas shunt
ZH2  = u*Z0;                 % ramas shunt a masa (lambda/4)
ZV=Z0;


% Atajos
dB = @(x) 20*log10(abs(x));
j  = 1i;

%%  ================ MODO PAR =======================
% =======================
%  CASO 1: PAR 1–2
%  TL(ZH1, th_H1) -> SHUNT(Y_LH1)
%  con Y_LH1 = Y_open(ZH2, th_H2/2) + Y_open(ZV, th_V)
%  Zref1 = 2*Z01, Zref2 = Z02
% =======================
ZLe=inf;
Zin_H2e=tl_zin_lossless(ZH2,ZLe,theta_H2/2);

Zin_H2_Z03=zparallel(Z0,Zin_H2e);
YLH1=invZ_safe(tl_zin_lossless(ZV,Zin_H2_Z03,theta_V));

T_case1=abcd_cascade(abcd_line(ZH1,theta_H1),abcd_shuntY(YLH1));
S_case1=abcd2s_2port(T_case1,2*Z0,Z0);

% =======================
%  CASO 2: PAR 1–P (A)
%  TL(ZH1,th_H1) -> SERIES(Z02) -> TL(ZV,th_V) -> SHUNT(YLH2)
%  con  YLH2 = 1/Zin(H2 abierto, media)  =  invZ_safe( tl_zin_lossless(ZH2, Inf, th_H2/2) )
%  Zref1 = 2*Z01, Zref2 = Z03
% =======================
Zin_H2e_2 = tl_zin_lossless(ZH2, ZLe, theta_H2/2);      % stub H2/2 abierto
YLH2      = invZ_safe(Zin_H2e_2);                       % Y del stub al plano

% armo la cascada: TL(ZH1,th_H1) — Z02 (serie) — TL(ZV,th_V) — shunt(YLH2)
T_case2 = abcd_cascade( ...
            abcd_line(ZH1,theta_H1), ...
            abcd_shuntY(invZ_safe(Z0*ones(1,N))), ...               % serie constante
            abcd_line(ZV,theta_V), ...
            abcd_shuntY(YLH2) );
S_case2 = abcd2s_2port(T_case2, 2*Z0, Z0);              % (2Z01) y (Z03)

% =======================
%  CASO 3: PAR 2–P (A)
%  SHUNT(YLH3) -> TL(ZV,th_V) -> SHUNT(YLH4)
%  con  YLH3 = 1/Zin(H1 abierto, H1 completo) = invZ_safe( tl_zin_lossless(ZH1, Inf, theta_H1) )
%       YLH4 = 1/Zin(H2 abierto, media)       = invZ_safe( tl_zin_lossless(ZH2, Inf, theta_H2/2) )
%  Zref1 = Z02, Zref2 = Z03
% =======================
Zin_H1e   = tl_zin_lossless(ZH1, 2*Z0, theta_H1);         % stub H1 abierto
YLH3      = invZ_safe(Zin_H1e);
YLH4      = invZ_safe(Zin_H2e_2);                         % ya calculado arriba

T_case3 = abcd_cascade( ...
            abcd_shuntY(YLH3), ...
            abcd_line(ZV,theta_V), ...
            abcd_shuntY(YLH4) );
S_case3 = abcd2s_2port(T_case3, Z0, Z0);                  % (Z02) y (Z03)

 
% -------- Se directo a partir de los tres dos-puertos -------------
Se = zeros(3,3,N);   % orden de puertos: [1, 2, A]

% Caso 1: (1,2) con la red de A incorporada  -> S_12_e “bueno” de tu 1er código
Se(1,1,:) = S_case1(1,1,:);   % S11e
Se(1,2,:) = S_case1(1,2,:);   % S12e
Se(2,1,:) = S_case1(2,1,:);   % S21e
Se(2,2,:) = S_case1(2,2,:);   % S22e

% Caso 2: (1,A) con 2 adaptado
Se(1,3,:) = S_case2(1,2,:);   % S1A
Se(3,1,:) = S_case2(2,1,:);   % SA1
Se(3,3,:) = S_case2(2,2,:);   % SAA  (debería coincidir con el del caso 3)

% Caso 3: (2,A) con 1 adaptado
Se(2,3,:) = S_case3(1,2,:);   % S2A
Se(3,2,:) = S_case3(2,1,:);   % SA2

%% ================ MODO IMPAR =======================
% Solo 1 caso: puertos (2, A)
% Topología:  SHUNT(YLH5) -> TL(ZV,th_V) -> SHUNT(YLH6)
% Donde:
%   YLH5 = 1 / Zin_H1o  con H1 corto en el extremo
%   YLH6 = 1 / Zin_H2o  con H2/2 corto en el extremo

% --- Cálculo de YLH5 y YLH6 ---
ZLo = 0;   % corto en plano de simetría
Zin_H1o = tl_zin_lossless(ZH1, ZLo, theta_H1);       % línea H1 terminada en corto
Zin_H2o = tl_zin_lossless(ZH2, ZLo, theta_H2/2);     % línea H2/2 terminada en corto

YLH5 = invZ_safe(Zin_H1o);
YLH6 = invZ_safe(Zin_H2o);

% --- Red total ---
T_odd = abcd_cascade( ...
            abcd_shuntY(YLH5), ...
            abcd_line(ZV, theta_V), ...
            abcd_shuntY(YLH6) );

So = abcd2s_2port(T_odd, Z0, Z0);     % Z02 = Z03 = Z0 en referencia

%% ================== S TOTAL DEL 5-PUERTOS (orden [1,2,3,4,5]) ==================
% Usa:  Se (3x3xN) en orden [1,2,4],    So (2x2xN) en orden [2,4]
% Salida: S5 (5x5xN) en orden físico [1,2,3,4,5]
% Nota: el puerto 1 es el puerto 1; el puerto 4 es A; 3~2 por simetría, 5~4 por simetría.

S5 = zeros(5,5,N);

% Transformaciones modales (constantes)
is2 = 1/sqrt(2);

% === Transformaciones modales CORRECTAS (coherentes con S5_from_even_odd) ===
% Even: a_even = M_e * a_phys ;  b_phys = R_e * b_even
M_e = [ 1   0    0    0    0 ;
        0  is2  is2   0    0 ;
        0   0    0   is2  is2 ];     % = A'

R_e = [ 1   0    0 ;
        0  is2   0 ;
        0  is2   0 ;
        0   0   is2 ;
        0   0   is2 ];               % = A

% Odd: a_odd = M_o * a_phys ;  b_phys = R_o * b_odd
M_o = [ 0   is2  -is2   0    0 ;
        0    0     0   is2  -is2 ];  % = C'   <<< CAMBIO DE SIGNO vs tu versión

R_o = [ 0    0 ;
        is2  0 ;
       -is2  0 ;
        0   is2 ;
        0  -is2 ];                   % = C    <<< CAMBIO DE SIGNO vs tu versión

% Construcción por frecuencia:  S5 = R_e*Se*M_e  +  R_o*So*M_o
for k = 1:N
    Se_k = Se(:,:,k);   % [1,2,4]  == [1, e(2,3), e(4,5)]
    So_k = So(:,:,k);   % [2,4]    == [o(2,3), o(4,5)]
    S5(:,:,k) = R_e * Se_k * M_e  +  R_o * So_k * M_o;
end

% Limpieza numérica opcional
S5(abs(S5) < 1e-13) = 0;

%% ==== Plots de magnitud |Sij| en dB usando S5 (5x5xN) ====
% --- Normaliza intérpretes a 'tex' (compatible con S_{ij}, | |, etc.) ---
set(groot,'defaultTextInterpreter','tex');
set(groot,'defaultLegendInterpreter','tex');
set(groot,'defaultAxesTickLabelInterpreter','tex');

% ===== Cargar S-params de ADS (Touchstone .s5p) =====
ads_file = 'gysel_ideal.s5p';   % cambia si tu ruta es otra
Sads = sparameters(ads_file);             % requiere RF Toolbox
f_ads = Sads.Frequencies;                 % Hz
S5_ads = Sads.Parameters;                 % 5x5xN_ads (complejo)
f_ads_GHz = f_ads/1e9;
f_GHz     = f/1e9;

magdB = @(x) 20*log10(abs(squeeze(x)));
phdeg = @(x) rad2deg((angle(squeeze(x))));  % fase desenvuelta por trazado

% ---------- Define los grupos (modifica a tu gusto) ----------
groups = { ...
  struct('title','Retornos', ...
         'pairs',[1 1; 2 2; 3 3; 4 4; 5 5], ...
         'ylimmag',[-40 0]), ...
  struct('title','Desde puerto 1', ...
         'pairs',[1 2; 1 3; 1 4; 1 5], ...
         'ylimmag',[-40 0]), ...
  struct('title','Cruces simétricos salida (2,3)↔(4,5)', ...
         'pairs',[2 4; 2 5; 3 4; 3 5], ...
         'ylimmag',[-15 -2]), ...
  struct('title','Entre ramas homólogas', ...
         'pairs',[2 3; 4 5], ...
         'ylimmag',[-35 -5]) ...
};

baseColors = lines(8);   % paleta estable por grupo

for g = 1:numel(groups)
    G = groups{g};
    figure('Name',sprintf('Grupo: %s',G.title),'Color','w');
    t = tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

    % ===== Subfigura A: MÓDULO =====
    ax1 = nexttile(t,1); hold(ax1,'on'); grid(ax1,'on'); box(ax1,'on');
    leg1 = {};
    for k = 1:size(G.pairs,1)
        i = G.pairs(k,1); j = G.pairs(k,2);
        col = baseColors(k,:);
        plot_matlab_ads(ax1, f_GHz, magdB(S5(i,j,:)), f_ads_GHz, magdB(S5_ads(i,j,:)),col);
        % % MATLAB (sólido)
        % h = plot(ax1, f_GHz, magdB(S5(i,j,:)), 'LineWidth',1.8, 'Color',col); 
        % % ADS (discontinuo, mismo color)
        % col_ads = vary_color(col, 'lighten', 0.25);  % ~25% más claro
        % plot(ax1, f_ads_GHz, magdB(S5_ads(i,j,:)), 'LineWidth',1.6, 'LineStyle','--', 'Color',col_ads);
        % plot(ax1, f_ads_GHz, magdB(S5_ads(i,j,:)), 'LineWidth',1.2, 'LineStyle','--', 'Color', get(h,'Color'));
        leg1{end+1} = sprintf('S_{%d%d} (MATLAB)',i,j);
        leg1{end+1} = sprintf('S_{%d%d} (ADS)',   i,j);
    end
    if exist('f0','var') && isscalar(f0) && ~isnan(f0)
        xline(ax1, f0/1e9,'--','f_0','LabelVerticalAlignment','bottom');
    end
    xlabel(ax1,'Frecuencia [GHz]'); ylabel(ax1,'|S_{ij}| [dB]');
    if isfield(G,'ylimmag') && ~isempty(G.ylimmag), ylim(ax1,G.ylimmag); end
    title(ax1,[G.title ' — Módulo']);
    legend(ax1, leg1, 'Location','best', 'NumColumns',2);

    % ===== Subfigura B: FASE =====
    ax2 = nexttile(t,2); hold(ax2,'on'); grid(ax2,'on'); box(ax2,'on');
    leg2 = {};
    for k = 1:size(G.pairs,1)
        i = G.pairs(k,1); j = G.pairs(k,2);
        col = baseColors(k,:);
        plot_matlab_ads(ax2, f_GHz, phdeg(S5(i,j,:)), ...
                      f_ads_GHz, phdeg(S5_ads(i,j,:)), ...
                      col);
        % MATLAB (sólido) 
        h = plot(ax2, f_GHz, phdeg(S5(i,j,:)), 'LineWidth',1.8, 'Color',col); 
        % ADS (discontinuo) 
        plot(ax2, f_ads_GHz, phdeg(S5_ads(i,j,:)), 'LineWidth',1.2,'LineStyle','--', 'Color', get(h,'Color'));
        leg2{end+1} = sprintf('S_{%d%d} (MATLAB)',i,j);
        leg2{end+1} = sprintf('S_{%d%d} (ADS)',   i,j);
    end
    if exist('f0','var') && isscalar(f0) && ~isnan(f0)
        xline(ax2, f0/1e9,'--','f_0','LabelVerticalAlignment','bottom');
    end
    xlabel(ax2,'Frecuencia [GHz]'); ylabel(ax2,'Fase [°]');
    title(ax2,[G.title ' — Fase']);
    legend(ax2, leg2, 'Location','best', 'NumColumns',2);

    sgtitle(t, sprintf('Comparativa MATLAB (sólido) vs ADS (--) — %s', G.title));
end

% ---- (B) Figuras por COLUMNA j: curvas i=1..5 + ADS ----
colors = lines(5); % colores por fila (i)
for col = 1:5
    figure('Name',sprintf('Columna %d (MATLAB vs ADS)',col),'Color','w');
    hold on; grid on; box on;

    leg = cell(1, 2*5); kleg = 0;

    for row = 1:5
        col_base = colors(row,:);
        plot_matlab_ads(gca, ...
            f_GHz, 20*log10(abs(squeeze(S5(row,col,:)))), ...
            f_ads_GHz, 20*log10(abs(squeeze(S5_ads(row,col,:)))), ...
            col_base);
        kleg = kleg+1; leg{kleg} = sprintf('S_{%d%d} (MATLAB)',row,col);
        kleg = kleg+1; leg{kleg} = sprintf('S_{%d%d} (ADS)',row,col);
    end

    if exist('f0','var') && isscalar(f0) && ~isnan(f0)
        xline(f0/1e9,'--','f_0','LabelVerticalAlignment','bottom');
    end
    ylim([-60 5]);
    xlabel('Frecuencia [GHz]');
    ylabel('|S_{ij}| [dB]');
    title(sprintf('Módulo de la columna %d de la matriz S', col));
    legend(leg,'Location','best','NumColumns',2);
    hold off;
end

%% ================== MATRIZ COMPLETA S5 (5x5): |S| y ∠S ==================
% Requisitos en workspace:
%  - S5 (5x5xN), f (1xN)
%  - S5_ads (5x5xN_ads), f_ads (1xN_ads)
%  - helper plot_matlab_ads(ax, fx, yx, fy, yy, color)
%  - (opcional) f0

if ~exist('S5','var') || ~exist('f','var') || ~exist('S5_ads','var') || ~exist('f_ads','var')
    error('Faltan S5/f o S5_ads/f_ads en el workspace.');
end

f_GHz     = f/1e9;
f_ads_GHz = f_ads/1e9;

magdB = @(X) 20*log10(abs(squeeze(X)));
% Fase "suave" por frecuencia (desenvuelve a lo largo de la 3ª dimensión):
phdeg = @(x) rad2deg((angle(squeeze(x))));  % fase desenvuelta por trazado

% Paleta por fila (i): mismo color para S_{i1}..S_{i5}
rowColors = lines(5);


%% --------- (C) FIGURA POR COLUMNAS: 5 filas x 2 columnas (S_{*j}) ---------
if ~exist('phdeg','var')
    % Fase SIN desenvuelto, respetando tu preferencia
    phdeg = @(X) rad2deg(angle(squeeze(X)));  % devuelve vector (N,)
end

colset = lines(5);  % un color por fila i (1..5)

for j = 1:5
    figure('Name',sprintf('S5 — Columna j=%d (MATLAB vs ADS)',j),'Color','w');
    t = tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

    % ===== Subfigura 1: MÓDULO |S_{*j}| [dB] =====
    axM = nexttile(t,1); hold(axM,'on'); grid(axM,'on'); box(axM,'on');
    legM = {};
    for i = 1:5
        plot_matlab_ads(axM, ...
            f_GHz,     magdB(S5(i,j,:)), ...
            f_ads_GHz, magdB(S5_ads(i,j,:)), ...
            colset(i,:));
        legM{end+1} = sprintf('S_{%d%d} (MATLAB)',i,j);
        legM{end+1} = sprintf('S_{%d%d} (ADS)',   i,j);
    end
    if exist('f0','var') && isscalar(f0) && ~isnan(f0)
        xline(axM,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom');
    end
    ylim(axM,[-60 5]); xlabel(axM,'Frecuencia [GHz]'); ylabel(axM,'|S| [dB]');
    title(axM, sprintf('Columna j=%d — Módulo (S_{*%d})', j, j));
    legend(axM, legM, 'Location','best','NumColumns',2);

    % ===== Subfigura 2: FASE ∠S_{*j} [°] =====
    axP = nexttile(t,2); hold(axP,'on'); grid(axP,'on'); box(axP,'on');
    legP = {};
    for i = 1:5
        plot_matlab_ads(axP, ...
            f_GHz,     phdeg(S5(i,j,:)), ...
            f_ads_GHz, phdeg(S5_ads(i,j,:)), ...
            colset(i,:));
        legP{end+1} = sprintf('S_{%d%d} (MATLAB)',i,j);
        legP{end+1} = sprintf('S_{%d%d} (ADS)',   i,j);
    end
    if exist('f0','var') && isscalar(f0) && ~isnan(f0)
        xline(axP,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom');
    end
    xlabel(axP,'Frecuencia [GHz]'); ylabel(axP,'Fase [°]');
    title(axP, sprintf('Columna j=%d — Fase (S_{*%d})', j, j));
    legend(axP, legP, 'Location','best','NumColumns',2);

    sgtitle(t, sprintf('S5 — Columna j=%d (S_{*%d}) — MATLAB (sólido) vs ADS (--)', j, j));
end


%% ======= Comparativa de matrices modales: Se (puertos 6-7-8) y So (puertos 9-10) =======
% (supuesto) Mapeo: Se -> [6 7 8] ≡ [1 2 A],  So -> [9 10] ≡ [2 A]
ads10_file = 'gysel_ads.s10p';
Sads10 = sparameters(ads10_file);
f10_ads      = Sads10.Frequencies;      f10_ads_GHz = f10_ads/1e9;
S10_ads_full = Sads10.Parameters;       % 10x10xN10

% --- Extraer submatrices ADS en el mismo orden que MATLAB ---
idx_e = [6 7 8];         % [1,2,A] (en Se)
idx_o = [9 10];          % [2,A]   (en So)

Se_ads = S10_ads_full(idx_e, idx_e, :);    % 3x3xN10
So_ads = S10_ads_full(idx_o, idx_o, :);    % 2x2xN10

% Reutiliza helpers existentes:
magdB = @(x) 20*log10(abs(squeeze(x)));
phdeg = @(x) rad2deg((angle(squeeze(x))));  % fase desenvuelta por trazado
f_GHz = f/1e9;

% ===================== PLOTS COMPLETOS PARA Se (3x3) =====================
% Módulo
figure('Name','Se - TODOS (|S|) MATLAB vs ADS','Color','w');
t = tiledlayout(3,3,'Padding','compact','TileSpacing','compact');
baseColors = lines(9); kcol = 0;
for i = 1:3
    for j = 1:3
        kcol = kcol + 1; col = baseColors(kcol,:);
        ax = nexttile(t,(i-1)*3 + j); hold(ax,'on'); grid(ax,'on'); box(ax,'on');
        plot_matlab_ads(ax, f_GHz, magdB(Se(i,j,:)), f10_ads_GHz, magdB(Se_ads(i,j,:)), col);
        if exist('f0','var'); xline(ax,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom'); end
        ylim(ax,[-60 5]); xlabel(ax,'f [GHz]'); ylabel(ax,'|S| [dB]');
        title(ax, sprintf('S^{e}_{%s%s}', lab_e(i), lab_e(j)));
        legend(ax, {'MATLAB','ADS'}, 'Location','best','Box','off');
    end
end
sgtitle(t,'Se (3×3) — |S| — MATLAB (sólido) vs ADS (--)');

% Fase
figure('Name','Se - TODOS (∠S) MATLAB vs ADS','Color','w');
t = tiledlayout(3,3,'Padding','compact','TileSpacing','compact');
baseColors = lines(9); kcol = 0;
for i = 1:3
    for j = 1:3
        kcol = kcol + 1; col = baseColors(kcol,:);
        ax = nexttile(t,(i-1)*3 + j); hold(ax,'on'); grid(ax,'on'); box(ax,'on');
        plot_matlab_ads(ax, f_GHz, phdeg(Se(i,j,:)), f10_ads_GHz, phdeg(Se_ads(i,j,:)), col);
        if exist('f0','var'); xline(ax,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom'); end
        xlabel(ax,'f [GHz]'); ylabel(ax,'Fase [°]');
        title(ax, sprintf('S^{e}_{%s%s}', lab_e(i), lab_e(j)));
        legend(ax, {'MATLAB','ADS'}, 'Location','best','Box','off');
    end
end
sgtitle(t,'Se (3×3) — ∠S — MATLAB (sólido) vs ADS (--)');

% ===================== PLOTS COMPLETOS PARA So (2x2) =====================
% Módulo
figure('Name','So - TODOS (|S|) MATLAB vs ADS','Color','w');
t = tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
baseColors = lines(4); kcol = 0;
for i = 1:2
    for j = 1:2
        kcol = kcol + 1; col = baseColors(kcol,:);
        ax = nexttile(t,(i-1)*2 + j); hold(ax,'on'); grid(ax,'on'); box(ax,'on');
        plot_matlab_ads(ax, f_GHz, magdB(So(i,j,:)), f10_ads_GHz, magdB(So_ads(i,j,:)), col);
        if exist('f0','var'); xline(ax,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom'); end
        ylim(ax,[-60 5]); xlabel(ax,'f [GHz]'); ylabel(ax,'|S| [dB]');
        title(ax, sprintf('S^{o}_{%s%s}', lab_o(i), lab_o(j)));
        legend(ax, {'MATLAB','ADS'}, 'Location','best','Box','off');
    end
end
sgtitle(t,'So (2×2) — |S| — MATLAB (sólido) vs ADS (--)');

% Fase
figure('Name','So - TODOS (∠S) MATLAB vs ADS','Color','w');
t = tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
baseColors = lines(4); kcol = 0;
for i = 1:2
    for j = 1:2
        kcol = kcol + 1; col = baseColors(kcol,:);
        ax = nexttile(t,(i-1)*2 + j); hold(ax,'on'); grid(ax,'on'); box(ax,'on');
        plot_matlab_ads(ax, f_GHz, phdeg(So(i,j,:)), f10_ads_GHz, phdeg(So_ads(i,j,:)), col);
        if exist('f0','var'); xline(ax,f0/1e9,'--','f_0','LabelVerticalAlignment','bottom'); end
        xlabel(ax,'f [GHz]'); ylabel(ax,'Fase [°]');
        title(ax, sprintf('S^{o}_{%s%s}', lab_o(i), lab_o(j)));
        legend(ax, {'MATLAB','ADS'}, 'Location','best','Box','off');
    end
end
sgtitle(t,'So (2×2) — ∠S — MATLAB (sólido) vs ADS (--)');


% ===== Helpers para etiquetas modales (legibilidad) =====
function s = lab_e(k)
    % Mapea índices 1..3 -> {1,2,A} para Se
    map = {'1','2','A'}; s = map{k};
end
function s = lab_o(k)
    % Mapea índices 1..2 -> {2,A} para So
    map = {'2','A'}; s = map{k};
end


%%
function plot_matlab_ads(ax, x_mat, y_mat, x_ads, y_ads, col_base)
    % === Estilo visual mejorado ===
    % MATLAB → claro y continuo
    % ADS    → original (más oscuro), discontínuo, más grueso
    col_mat = col_base + (1 - col_base)*0.45;     % 45 % más claro
    col_mat = max(min(col_mat,1),0);

    % --- Curva MATLAB (clara, sólida) ---
    plot(ax, x_mat, y_mat, 'LineWidth',2.0, ...
         'Color', col_mat, 'LineStyle','-');

    % --- Curva ADS (oscura, discontinua) ---
    n = numel(x_ads);
    idx = round(linspace(1, n, min(25,n)));       % marcadores escasos
    h = plot(ax, x_ads, y_ads, ...
         'LineStyle','--', 'LineWidth',3, ...
         'Color', col_base);
    try, set(h,'LineJoin','round','LineCap','round'); end
end
