%% ================================================================
% A) PROTOTIPO LP NORMALIZADO — BLOQUE COMPLETO (1.A)1)–1.A)7)
% ================================================================
clear; close all; clc;
%%
j = sqrt(-1);

% ===== Parámetros de representación comunes =====
lw        = 1.8;
yaxisUp   = 0;         % dB
yaxisDown = -60;       % dB
Omega     = linspace(0, 3, 2001);
N_default = 5;

% ===== Utilidades locales (sin toolboxes) =====
chebT = @(N,x) arrayfun(@(xi) chebT_scalar(N, xi), x);
eps_from_Rp = @(Rp_dB) sqrt(10^(Rp_dB/10)-1);
S21_butter  = @(N,Om) 1 ./ sqrt( 1 + Om.^(2*N) );
S21_cheby   = @(N,Om,eps) 1 ./ sqrt( 1 + (eps*chebT(N,Om)).^2 );

%% ------------------------------------------------
% 1.A)1) — |S21| (dB) N=5: Butterworth vs Chebyshev (0.1/0.01 dB)
% ------------------------------------------------
N = N_default; Rp_dB_1 = 0.1; Rp_dB_2 = 0.01;
eps1 = eps_from_Rp(Rp_dB_1);
eps2 = eps_from_Rp(Rp_dB_2);

H_butt  = S21_butter(N, Omega);
H_cheb1 = S21_cheby  (N, Omega, eps1);
H_cheb2 = S21_cheby  (N, Omega, eps2);

S21dB_butt  = 20*log10(abs(H_butt));
S21dB_cheb1 = 20*log10(abs(H_cheb1));
S21dB_cheb2 = 20*log10(abs(H_cheb2));

figure('Name','A1.1 — |S21| completo','Color','w'); hold on; grid on; box on;
plot(Omega, S21dB_butt , 'b-' , 'LineWidth', lw);
plot(Omega, S21dB_cheb1, 'r--', 'LineWidth', lw);
plot(Omega, S21dB_cheb2, 'g-.', 'LineWidth', lw);
xline(1,'k:','LineWidth',1.2);
xlabel('\Omega (LP norm.)'); ylabel('|S_{21}| (dB)');
title(sprintf('LP N=%d — Butterworth vs Chebyshev (%.2f/%.2f dB)', N, Rp_dB_1, Rp_dB_2));
xlim([0 3]); ylim([yaxisDown yaxisUp]);
legend('Butterworth','Chebyshev 0.1 dB','Chebyshev 0.01 dB','Location','SouthWest');

% Zoom PB
maskPB = Omega <= 1;
figure('Name','A1.1 — |S21| pasobanda','Color','w'); hold on; grid on; box on;
plot(Omega(maskPB), S21dB_butt (maskPB), 'b-' , 'LineWidth', lw);
plot(Omega(maskPB), S21dB_cheb1(maskPB), 'r--', 'LineWidth', lw);
plot(Omega(maskPB), S21dB_cheb2(maskPB), 'g-.', 'LineWidth', lw);
yline(-Rp_dB_1, 'r:','0.1 dB'); yline(-Rp_dB_2, 'g:','0.01 dB');
xline(1,'k:','HandleVisibility','off');
xlabel('\Omega'); ylabel('|S_{21}| (dB)'); title('Zoom pasobanda');
xlim([0 1]); yminPB = min([S21dB_butt(maskPB), S21dB_cheb1(maskPB), S21dB_cheb2(maskPB)]);
ylim([min(-0.5, yminPB)-0.02, 0]);
legend('Butterworth','Chebyshev 0.1 dB','Chebyshev 0.01 dB','Location','SouthWest');

%% ------------------------------------------------
% 1.A)2) — |S11| (dB) N=5 (red ideal): |S11|^2 = 1 - |S21|^2
% ------------------------------------------------
S11_2_butt  = max(0, 1 - abs(H_butt ).^2);
S11_2_c01   = max(0, 1 - abs(H_cheb1).^2);
S11_2_c001  = max(0, 1 - abs(H_cheb2).^2);

S11dB_butt  = 10*log10(max(S11_2_butt , realmin));
S11dB_c01   = 10*log10(max(S11_2_c01  , realmin));
S11dB_c001  = 10*log10(max(S11_2_c001 , realmin));

figure('Name','A1.2 — |S11| (dB)','Color','w'); hold on; grid on; box on;
plot(Omega, S11dB_butt, 'b-' , 'LineWidth', lw);
plot(Omega, S11dB_c01 , 'r--', 'LineWidth', lw);
plot(Omega, S11dB_c001, 'g-.', 'LineWidth', lw);
xline(1,'k:', 'LineWidth',1.2);
xlabel('\Omega'); ylabel('|S_{11}| (dB)');
title(sprintf('LP N=%d — |S_{11}| (dB)', N));
xlim([0 3]); ylim([-80 0]);
legend('Butterworth','Chebyshev 0.1 dB','Chebyshev 0.01 dB','Location','SouthEast');

%% ------------------------------------------------
% 1.A)3) — |S21| (dB) Chebyshev 0.1 dB para N=3,4,5
% ------------------------------------------------
Nvals = [3 4 5]; epsC = eps1;
S21dB_C = zeros(numel(Nvals), numel(Omega));
for k = 1:numel(Nvals)
    Hk = S21_cheby(Nvals(k), Omega, epsC);
    S21dB_C(k,:) = 20*log10(abs(Hk));
end

figure('Name','A1.3 — |S21| Cheb 0.1 dB','Color','w'); hold on; grid on; box on;
plot(Omega, S21dB_C(1,:), 'b-' , 'LineWidth', lw);
plot(Omega, S21dB_C(2,:), 'r--', 'LineWidth', lw);
plot(Omega, S21dB_C(3,:), 'g-.', 'LineWidth', lw);
xline(1,'k:', 'LineWidth',1.2);
xlabel('\Omega'); ylabel('|S_{21}| (dB)'); title('Chebyshev 0.1 dB — N = 3, 4, 5');
xlim([0 3]); ylim([yaxisDown yaxisUp]);
legend('N=3','N=4','N=5','Location','SouthWest');

% Zoom PB
maskPB = Omega <= 1;
figure('Name','A1.3 — |S21| PB','Color','w'); hold on; grid on; box on;
plot(Omega(maskPB), S21dB_C(1,maskPB), 'b-' , 'LineWidth', lw);
plot(Omega(maskPB), S21dB_C(2,maskPB), 'r--', 'LineWidth', lw);
plot(Omega(maskPB), S21dB_C(3,maskPB), 'g-.', 'LineWidth', lw);
yline(-Rp_dB_1,'k:','-Rp=0.1 dB'); xline(1,'k:','HandleVisibility','off');
xlabel('\Omega'); ylabel('|S_{21}| (dB)'); title('Chebyshev 0.1 dB — Zoom PB');
xlim([0 1]); yminPB = min(S21dB_C(:,maskPB),[],'all'); ylim([min(-0.5,yminPB)-0.02, 0]);
legend('N=3','N=4','N=5','Location','SouthWest');

%% ------------------------------------------------
% 1.A)4) — |S11| (dB) Chebyshev 0.1 dB para N=3,4,5
% ------------------------------------------------
S11dB_all = zeros(numel(Nvals), numel(Omega));
for k = 1:numel(Nvals)
    Hk = S21_cheby(Nvals(k), Omega, epsC);
    S11_2_k = max(0, 1 - abs(Hk).^2);
    S11dB_all(k,:) = 10*log10(max(S11_2_k, realmin));
end

figure('Name','A1.4 — |S11| Cheb 0.1 dB','Color','w'); hold on; grid on; box on;
plot(Omega, S11dB_all(1,:), 'b-' , 'LineWidth', lw);
plot(Omega, S11dB_all(2,:), 'r--', 'LineWidth', lw);
plot(Omega, S11dB_all(3,:), 'g-.', 'LineWidth', lw);
xline(1,'k:', 'LineWidth',1.2);
xlabel('\Omega'); ylabel('|S_{11}| (dB)'); title('|S_{11}| (dB) — Chebyshev 0.1 dB (N=3,4,5)');
xlim([0 3]); ylim([-80 0]); legend('N=3','N=4','N=5','Location','SouthEast');

%% ------------------------------------------------
% 1.A)5) — S11, S21 (dB) y tau_g para Butterworth, Chebyshev 0.1 dB y Bessel (N=5)
% ------------------------------------------------
N = 5; Rp_dB = 0.1;

% --- gi (usa tus funciones; si no existen, avisa) ---
assert(exist('butter_gi','file')==2, 'Falta butter_gi(N). Usa tu función o pídeme incluirla.');
assert(exist('cheb_gi_equalripple','file')==2, 'Falta cheb_gi_equalripple(N,Rp_dB).');
assert(exist('bessel_gi_pozar','file')==2, 'Falta bessel_gi_pozar(N).');

g_bw = butter_gi(N);
g_ch = cheb_gi_equalripple(N, Rp_dB);
g_be = bessel_gi_pozar(N);     % normalización a retardo (Pozar)

% Evaluación con tu evaluador “ladder_from_g” (entre g0 y gN+1)
assert(exist('ladder_from_g','file')==2, 'Falta ladder_from_g(g,Omega,g0,gN1).');
[S11_bw, S21_bw, tau_bw] = ladder_from_g(g_bw, Omega, g_bw(1), g_bw(end));
[S11_ch, S21_ch, tau_ch] = ladder_from_g(g_ch, Omega, g_ch(1), g_ch(end));
[S11_be, S21_be, tau_be] = ladder_from_g(g_be, Omega, g_be(1), g_be(end));

% |S21| (dB)
figure('Name','A1.5 — |S21| (dB) N=5','Color','w'); hold on; grid on; box on;
plot(Omega, 20*log10(max(abs(S21_bw),realmin)), 'LineWidth',lw);
plot(Omega, 20*log10(max(abs(S21_ch),realmin)), 'LineWidth',lw);
plot(Omega, 20*log10(max(abs(S21_be),realmin)), 'LineWidth',lw);
xline(1,'k:'); ylim([-80 1]); xlim([0 3]);
xlabel('\Omega'); ylabel('|S_{21}| (dB)');
legend('Butterworth','Chebyshev 0.1 dB','Bessel','Location','SouthWest');
title('Comparativa |S_{21}| (dB) – N=5');

% |S11| (dB)
figure('Name','A1.5 — |S11| (dB) N=5','Color','w'); hold on; grid on; box on;
plot(Omega, 20*log10(max(abs(S11_bw),realmin)), 'LineWidth',lw);
plot(Omega, 20*log10(max(abs(S11_ch),realmin)), 'LineWidth',lw);
plot(Omega, 20*log10(max(abs(S11_be),realmin)), 'LineWidth',lw);
xline(1,'k:'); ylim([-80 1]); xlim([0 3]);
xlabel('\Omega'); ylabel('|S_{11}| (dB)');
legend('Butterworth','Chebyshev 0.1 dB','Bessel','Location','SouthEast');
title('Comparativa |S_{11}| (dB) – N=5');

% tau_g
figure('Name','A1.5 — tau_g N=5','Color','w'); hold on; grid on; box on;
plot(Omega, tau_bw, 'LineWidth',lw);
plot(Omega, tau_ch, 'LineWidth',lw);
plot(Omega, tau_be, 'LineWidth',lw);
xline(1,'k:'); xlim([0 3]);
xlabel('\Omega'); ylabel('\tau_g (s)');
legend('Butterworth','Chebyshev 0.1 dB','Bessel','Location','NorthEast');
title('Comparativa \tau_g – N=5');

%% ------------------------------------------------
% 1.A)6) — Paso Alto Chebyshev N=5, Rp=0.1 dB, fc=1.8 GHz, ZS=ZL=50 Ω
% ------------------------------------------------
N = 5; Rp_dB = 0.1; Z0 = 50; fc = 1.8e9;
w   = 2*pi*linspace(0.1e9, 5e9, 3001); f = w/(2*pi);

% gi Chebyshev LP
g = cheb_gi_equalripple(N, Rp_dB);

% LP->HP (serie C; shunt L) y evaluación ABCD→S
[S11_hp, S21_hp, tau_hp] = ladder_HP_seriesC_shuntL_from_g(g, Z0, 2*pi*fc, w);

% Plots
figure('Name','A1.6 — |S21| HP','Color','w'); plot(f/1e9, 20*log10(max(abs(S21_hp),realmin)),'LineWidth',lw);
grid on; box on; xlim([f(1) f(end)]/1e9); ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{21}| (dB)');
title('HP Chebyshev N=5, 0.1 dB'); xline(fc/1e9,'k--','f_c');

figure('Name','A1.6 — |S11| HP','Color','w'); plot(f/1e9, 20*log10(max(abs(S11_hp),realmin)),'LineWidth',lw);
grid on; box on; xlim([f(1) f(end)]/1e9); ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{11}| (dB)');
title('HP Chebyshev N=5, 0.1 dB'); xline(fc/1e9,'k--','f_c');

figure('Name','A1.6 — tau_g HP','Color','w'); plot(f/1e9, tau_hp,'LineWidth',lw); grid on; box on;
xlabel('f (GHz)'); ylabel('\tau_g (s)'); title('HP Chebyshev N=5, 0.1 dB'); xline(fc/1e9,'k--','f_c');

%% ------------------------------------------------
% 1.A)7) — LP->BP Chebyshev N=5, Rp=0.1 dB, Z0=50 Ω, f0 & FBW paramétricos
% ------------------------------------------------
N = 5; Rp_dB = 0.1; Z0 = 50; f0 = 1.8e9; w0 = 2*pi*f0; FBW = 0.15;
g = cheb_gi_equalripple(N, Rp_dB);

% LP->BP: k impar -> SERIE; k par -> SHUNT  (entre Z01=Z02=Z0)
[Ls_ser, Cs_ser, Lp_par, Cp_par] = lp2bp_sections_from_g(g, Z0, w0, FBW);
f = linspace(0.3*f0, 3*f0, 3001); w = 2*pi*f;
[S11_bp, S21_bp, S22_bp, S12_bp, tau_bp] = ladder_BP_from_sections(Ls_ser, Cs_ser, Lp_par, Cp_par, Z0, Z0, w);

% Plots
figure('Name','A1.7 — |S21| BP','Color','w'); plot(f/1e9, 20*log10(max(abs(S21_bp),realmin)),'LineWidth',lw);
grid on; box on; xlim([f(1) f(end)]/1e9); ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{21}| (dB)');
title(sprintf('BP Chebyshev N=%d, Rp=%.1f dB, f0=%.3f GHz, FBW=%.0f%%', N, Rp_dB, f0/1e9, 100*FBW));
xline(f0/1e9,'k--','f_0'); xline(f0*(1-FBW/2)/1e9,'k:'); xline(f0*(1+FBW/2)/1e9,'k:');

figure('Name','A1.7 — |S11| BP','Color','w'); plot(f/1e9, 20*log10(max(abs(S11_bp),realmin)),'LineWidth',lw);
grid on; box on; xlim([f(1) f(end)]/1e9); ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{11}| (dB)');
title('BP Chebyshev — Adaptación'); xline(f0/1e9,'k--','f_0'); xline(f0*(1-FBW/2)/1e9,'k:'); xline(f0*(1+FBW/2)/1e9,'k:');

figure('Name','A1.7 — \tau_g BP','Color','w'); plot(f/1e9, tau_bp,'LineWidth',lw);
grid on; box on; xlim([f(1) f(end)]/1e9); xlabel('f (GHz)'); ylabel('\tau_g (s)');
title('\tau_g — BP Chebyshev'); xline(f0/1e9,'k--','f_0'); xline(f0*(1-FBW/2)/1e9,'k:'); xline(f0*(1+FBW/2)/1e9,'k:');

%% ===================== helpers locales A =====================
function T = chebT_scalar(N, x)
    if x >= -1 && x <= 1
        T = cos(N*acos(x));
    elseif x > 1
        T = cosh(N*acosh(x));
    else
        T = ((-1)^N) * cosh(N*acosh(-x));
    end
end

function [S11,S21,tau_g] = ladder_HP_seriesC_shuntL_from_g(g, Z0, wc, w)
% Construye HP desde prototipo LP (ladder empieza en SERIE):
%  k impar LP -> serie L  → HP -> serie C   : Ck = 1/(gk*Z0*wc)
%  k par   LP -> shunt C  → HP -> shunt L   : Lk = Z0/(gk*wc)
    N = numel(g)-2;
    Cser = []; Lsh = [];
    for k=1:N
        gk = g(k+1);
        if mod(k,2)==1,  Lsh(end+1)  = Z0/(gk*wc);
        else,            Cser(end+1) = 1/(gk*Z0*wc);
        end
    end
    [S11,S21,tau_g] = ladder_HP_seriesC_shuntL(Cser, Lsh, Z0, Z0, w);
end

function [Ls_ser, Cs_ser, Lp_par, Cp_par] = lp2bp_sections_from_g(g, Z0, w0, FBW)
% Ladder LP empieza en SERIE (k impar serie; par shunt) → BP secciones
    N = numel(g)-2;
    Ls_ser=[]; Cs_ser=[]; Lp_par=[]; Cp_par=[];
    for k=1:N
        gk = g(k+1);
        if mod(k,2)==1
            Lp_par(end+1) = (Z0*FBW)/(w0*gk);
            Cp_par(end+1) =  gk/(Z0*w0*FBW);
        else
            Ls_ser(end+1) = (Z0/w0)*(gk/FBW);
            Cs_ser(end+1) = (FBW)/(Z0*w0*gk);
        end
    end
end