%% Comparativa |S21| y |S11| para N = 3 y N = 4 en el mismo gráfico
clear all; close all; clc;
j = sqrt(-1);
c0 = 299792458;

% ---- Parámetros del filtro (comunes a ambos órdenes) ----
fo_GHz = sqrt(9.8*10.2);        % GHz
bw_MHz = 400;                   % MHz
Z0_Ohm = 50;                    % ohm
Qres = 1e6;                     % factor de calidad
LAr_dB = 0.04;                  % rizado Chebyshev en transmisión (dB)
prototipo = 0;                  % 0-> empieza en paralelo; 1-> empieza en serie

% ---- Derivados / barrido ----
Deltabwfrac = (bw_MHz*1e-3) / fo_GHz;  % BW fraccional
wo_radGHz   = 2*pi*fo_GHz;             % rad*GHz
npuntos_rep = 4001;
f_span      = 5;
f_GHz       = linspace(fo_GHz - f_span*bw_MHz*1e-3, ...
                       fo_GHz + f_span*bw_MHz*1e-3, npuntos_rep);
lw = 2;

% ---- Especificaciones y máscaras ----
f1=9.8e9; f2=10.2e9;                     % Hz
fPB = [f1; f2];
ILreq_dB = 0.1;                           % máx pérdida en PB
RLreq_dB = 18;                            % mín RL en PB
SB = [ 8.00e9  9.25e9  40;
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];
f_Hz = f_GHz*1e9;

% ====== Cálculo y gráfico ======
Nvals = [3 4];
col_S21 = {[0.9290 0.6940 0.1250],'r'};   % colores S21 por orden
col_S11 = {[0.8500 0.3250 0.0980],'b'};   % colores S11 por orden
hS21 = gobjects(1,numel(Nvals));
hS11 = gobjects(1,numel(Nvals));

figure('Name','Comparativa |S21| y |S11| (N=3 vs N=4)'); hold on; grid on; box on;

% Parche de máscaras UNA VEZ (coherentes con dB negativos)
ylim([-60 0]); yl = ylim;
% PB: |S21| >= -ILreq (zona válida entre 0 y -ILreq)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
% PB: |S11| <= -RLreq (zona válida por debajo de -RLreq)
patch([f1 f2 f2 f1]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.4, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:');

% Stopbands: |S21| <= -Areq (línea y zona por debajo)
for r = 1:size(SB,1)
    Areq_dB = -SB(r,3);                           % negativo (p. ej., -40)
    plot([SB(r,1) SB(r,2)]/1e9, [Areq_dB Areq_dB], 'r-', 'LineWidth', 2);
    % Máscara desde 0 hasta Areq_dB (no hasta -inf)
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, ...
          [0 0 Areq_dB Areq_dB], [1.0 0.8 0.8], ...
          'FaceAlpha',0.25, 'EdgeColor','none');
end

% Curvas por cada orden
for iN = 1:numel(Nvals)
    N_orden = Nvals(iN);

    % === Cálculo gk (Chebyshev) ===
    g0 = 1;
    beta  = log(coth(LAr_dB/17.37));
    gamma = sinh(beta/(2*N_orden));
    mvec  = 1:N_orden;
    a     = sin((2*mvec-1)*pi/(2*N_orden));
    b     = gamma^2 + (sin(mvec*pi/N_orden)).^2;

    g = zeros(1, N_orden+1);
    g(1) = 2*a(1)/gamma;
    for m = 2:N_orden
        g(m) = 4*a(m-1)*a(m) / (b(m-1)*g(m-1));
    end
    if mod(N_orden,2), g(N_orden+1) = 1;
    else,              g(N_orden+1) = (coth(beta/4))^2;
    end

    % === Fuente/carga y elementos paso banda ===
    if prototipo==1
        Rg_Ohm = Z0_Ohm/g0;
        RL_Ohm = (mod(N_orden,2)~=0) * (Z0_Ohm/g(N_orden+1)) + ...
                 (mod(N_orden,2)==0)  * (g(N_orden+1)*Z0_Ohm);
        L_nH = zeros(1,N_orden); C_nF = zeros(1,N_orden);
        RserieOhm_Q = zeros(1,N_orden); GparSie_Q = zeros(1,N_orden);
        m = 1:2:N_orden; % serie
        L_nH(m) = g(m) ./ (wo_radGHz*Deltabwfrac) * Z0_Ohm;
        C_nF(m) = Deltabwfrac ./ (wo_radGHz*g(m)) / Z0_Ohm;
        RserieOhm_Q(m) = sqrt( L_nH(m) ./ C_nF(m) ) ./ Qres;
        m = 2:2:N_orden; % paralelo
        L_nH(m) = Deltabwfrac ./ (wo_radGHz*g(m)) * Z0_Ohm;
        C_nF(m) = g(m) ./ (wo_radGHz*Deltabwfrac) / Z0_Ohm;
        GparSie_Q(m) = sqrt( C_nF(m) ./ L_nH(m) ) ./ Qres;
    else
        Rg_Ohm = g0*Z0_Ohm;
        RL_Ohm = (mod(N_orden,2)~=0) * (Z0_Ohm*g(N_orden+1)) + ...
                 (mod(N_orden,2)==0)  * (Z0_Ohm/g(N_orden+1));
        L_nH = zeros(1,N_orden); C_nF = zeros(1,N_orden);
        RserieOhm_Q = zeros(1,N_orden); GparSie_Q = zeros(1,N_orden);
        m = 1:2:N_orden; % paralelo
        L_nH(m) = Deltabwfrac ./ (wo_radGHz*g(m)) * Z0_Ohm;
        C_nF(m) = g(m) ./ (wo_radGHz*Deltabwfrac) / Z0_Ohm;
        GparSie_Q(m) = sqrt( C_nF(m) ./ L_nH(m) ) ./ Qres;
        m = 2:2:N_orden; % serie
        L_nH(m) = g(m) ./ (wo_radGHz*Deltabwfrac) * Z0_Ohm;
        C_nF(m) = Deltabwfrac ./ (wo_radGHz*g(m)) / Z0_Ohm;
        RserieOhm_Q(m) = sqrt( L_nH(m) ./ C_nF(m) ) ./ Qres;
    end

    % === Barrido S-params ===
    Z01 = Rg_Ohm; Z02 = RL_Ohm;
    s21 = zeros(1, npuntos_rep);
    s11 = zeros(1, npuntos_rep);

    for k = 1:npuntos_rep
        w_radGHz = 2*pi*f_GHz(k);
        Ttotal = eye(2);
        for m = 1:N_orden
            if prototipo==1
                if mod(m,2) % impar -> serie
                    zs  = RserieOhm_Q(m) + 1j*w_radGHz*L_nH(m) + 1./(1j*w_radGHz*C_nF(m));
                    Tres = [1 zs; 0 1];
                else        % par -> paralelo
                    yp  = GparSie_Q(m) + 1j*w_radGHz*C_nF(m) + 1./(1j*w_radGHz*L_nH(m));
                    Tres = [1 0; yp 1];
                end
            else
                if mod(m,2) % impar -> paralelo
                    yp  = GparSie_Q(m) + 1j*w_radGHz*C_nF(m) + 1./(1j*w_radGHz*L_nH(m));
                    Tres = [1 0; yp 1];
                else        % par -> serie
                    zs  = RserieOhm_Q(m) + 1j*w_radGHz*L_nH(m) + 1./(1j*w_radGHz*C_nF(m));
                    Tres = [1 zs; 0 1];
                end
            end
            Ttotal = Ttotal * Tres;
        end
        At=Ttotal(1,1); Bt=Ttotal(1,2); Ct=Ttotal(2,1); Dt=Ttotal(2,2);
        denom1 = At + Bt/Z02 + Ct*Z01 + Dt*Z01/Z02;
        s21(k) = 2*sqrt(Z01/Z02)/denom1;
        s11(k) = (At+Bt/Z02 - Ct*Z01 - Dt*Z01/Z02)/denom1;
    end

    % Magnitudes en dB (negativos hasta 0 dB)
    s21_dB = 20*log10(abs(s21));
    s11_dB = 20*log10(abs(s11));

    % Graficar
    hS21(iN) = plot(f_GHz, s21_dB, '-', 'Color', col_S21{iN}, 'LineWidth', lw);
    hS11(iN) = plot(f_GHz, s11_dB, '-','Color', col_S11{iN}, 'LineWidth', lw);
end

% Ejes y leyenda
xlabel('f (GHz)'); ylabel('dB');
title('|S_{21}|^2 y |S_{11}|^2 con máscaras — Comparativa N=3 vs N=4');
ylim([-60 0]);
xlim([f_GHz(1) f_GHz(end)]);
legend([hS21(:).' hS11(:).'], {'|S_{21}|^2 N=3','|S_{21}|^2 N=4','|S_{11}|^2 N=3','|S_{11}|^2 N=4'}, 'Location','NE');

% --- Chequeo PASS/FAIL (opcional) ---
inBand = (f_Hz >= fPB(1)) & (f_Hz <= fPB(2));
% (ejemplo rápido con el último orden calculado; si quieres para cada orden, guarda s21_dB/s11_dB por orden)
% pass_PB_IL = all( s21_dB(inBand) >= -ILreq_dB );
% pass_PB_RL = all( s11_dB(inBand) <= -RLreq_dB );
