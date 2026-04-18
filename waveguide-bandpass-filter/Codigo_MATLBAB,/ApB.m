%% ================================================================
% B) INVERTERS (J/K) Y REALIZACIONES EN LÍNEA — BLOQUE COMPLETO
% B)8) HP con inversores
% B)9) BP con K-inverters (resonadores serie)
% B)10) Sustituir K por λ/4 (Zq = K) y comparar
% ================================================================
clear; clc; j = sqrt(-1);
lw = 1.8;

%% -------------------------
% B)8) Chebyshev HP N=5, Rp=0.1 dB, fc=1.8 GHz, ZS=ZL=50 Ω —
% -------------------------
N=5; Rp_dB=0.1; Z0=50; fc=1.8e9; wc=2*pi*fc; GA=1/Z0; GB=1/Z0;
g = cheb_gi_equalripple(N,Rp_dB);    % [g0..gN+1]

% 1) L0i (N celdas shunt). Impares: fijados por LP->HP; Pares: a elegir
L0 = zeros(1,N);
L0(1) = Z0/(wc*g(2));   % k=1 -> g2
L0(3) = Z0/(wc*g(4));   % k=3 -> g4
L0(5) = Z0/(wc*g(6));   % k=5 -> g6
% Elección simple para pares: media geométrica de vecinos (puedes fijar a gusto)
L0(2) = sqrt(L0(1)*L0(3));
L0(4) = sqrt(L0(3)*L0(5));

% 2) J's canónicos (tu figura)
J = zeros(1,N+1);
J(1)     = sqrt( GA/(wc*L0(1)*g(1)*g(2)) );
for i=2:N
    J(i) = (1/wc)*sqrt( 1/(L0(i-1)*L0(i)*g(i)*g(i+1)) );
end
J(N+1)   = sqrt( GB/(wc*L0(N)*g(N+1)*g(N+2)) );

% 3) Cálculo S(ω) — red: J1 - [L01] - J2 - [L02] - ... - JN+1
f = linspace(0.2*fc, 5*fc, 4001); w = 2*pi*f; Z01=Z0; Z02=Z0;
S11=zeros(size(w)); S21=S11; ph=S11;

for kf=1:numel(w)
    omg=w(kf); ABCD=eye(2);
    % J1
    ABCD = ABCD * [0 1j/J(1); 1j*J(1) 0];
    % Secuencia celdas shunt + J
    for n=1:N
        YL = -1j./(omg*L0(n));           % inductor shunt
        ABCD = ABCD * [1 0; YL 1];
        ABCD = ABCD * [0 1j/J(n+1); 1j*J(n+1) 0];
    end
    % ABCD -> S
    A=ABCD(1,1); B=ABCD(1,2); C=ABCD(2,1); D=ABCD(2,2);
    denom1 = A + B/Z02 + C*Z01 + D*(Z01/Z02);
    S21(kf) = 2*sqrt(Z01/Z02)/denom1;
    S11(kf) = (A + B/Z02 - C*Z01 - D*(Z01/Z02))/denom1;
    ph(kf)  = angle(S21(kf));
end
tau_g = -gradient(unwrap(ph), w);

% 4) Plots
figure; plot(f/1e9,20*log10(abs(S21)),'LineWidth',1.6); grid on; ylim([-80 1]);
xlabel('f (GHz)'); ylabel('|S_{21}| (dB)'); title('HP (shunt-first) con J canónicos');
xline(fc/1e9,'k--')
figure; plot(f/1e9,20*log10(max(abs(S11),realmin)),'LineWidth',1.6); grid on; ylim([-80 1]);
xlabel('f (GHz)'); ylabel('|S_{11}| (dB)');
figure; plot(f/1e9,tau_g,'LineWidth',1.6); grid on; xlabel('f (GHz)'); ylabel('\tau_g (s)');


%% -------------------------
% B)9) Chebyshev BP N=5, Rp=0.1 dB, f0=1.8 GHz, FBW=0.15 — K-inverters + resonadores SERIE
% -------------------------
% ---- Especificaciones
N=5; Rp_dB=0.1; Z0=50; f0=1.8e9; w0=2*pi*f0; FBW=0.15;
g = cheb_gi_equalripple(N,Rp_dB);       % [g0..gN+1], ladder comienza en SERIE
RA=Z0; RB=Z0;

% ---- Resonadores SERIE "elegidos arbitrariamente"
% Usamos el parámetro de pendiente x0i (Ω) igual para todos, típico de resonadores de línea.
x0 = (Z0*pi/2)*ones(1,N);               % puedes cambiar valores si quieres
Lser =  x0 / w0;                        % L_oi = x0i / w0
Cser = 1./(x0 * w0);                    % C_oi = 1/(x0i*w0)

% ---- Inversores IDEALES de IMPEDANCIA (K) (narrowband con FBW=Δ)
% Fórmulas análogas a las de J pero con R y x0 (coinciden con tu lámina).
K = zeros(1,N+1);
K(1)   = sqrt( FBW * RA * x0(1) / ( g(1)*g(2) ) );
for n=2:N
    K(n) = FBW * sqrt( x0(n-1)*x0(n) / ( g(n)*g(n+1) ) );
end
K(N+1) = sqrt( FBW * x0(N) * RB / ( g(N+1)*g(N+2) ) );

% ---- Barrido de frecuencia
f = linspace(0.3*f0, 3.0*f0, 3001);  w = 2*pi*f;
Z01=RA; Z02=RB;

S11=zeros(size(w)); S21=S11; S22=S11; S12=S11; ph=S11;

for kf=1:numel(w)
    omg = w(kf);
    Ttot = [0 1j*K(1); 1j*(1/K(1)) 0];   % K-inverter de entrada (ABCD)

    for m=1:N
        % Resonador SERIE: Z = jωL + 1/(jωC)
        Zs = 1j*omg*Lser(m) + 1./(1j*omg*Cser(m));
        Tser = [1 Zs; 0 1];
        Ttot = Ttot * Tser;

        % K-inverter entre celdas (el último se inserta abajo)
        if m < N
            Tinv = [0 1j*K(m+1); 1j*(1/K(m+1)) 0];
            Ttot = Ttot * Tinv;
        end
    end
    % K-inverter de salida
    Ttot = Ttot * [0 -1j*K(N+1); -1j*(1/K(N+1)) 0];

    % ---- ABCD -> S sobre Z01,Z02 (Pozar Tab. 4.2)
    A=Ttot(1,1); B=Ttot(1,2); C=Ttot(2,1); D=Ttot(2,2);
    denom1 = A + B/Z02 + C*Z01 + D*(Z01/Z02);
    S21(kf) = 2*sqrt(Z01/Z02)/denom1;
    S11(kf) = (A + B/Z02 - C*Z01 - D*(Z01/Z02))/denom1;
    denom2  = D + B/Z01 + C*Z02 + A*(Z02/Z01);
    S22(kf) = (D + B/Z01 - C*Z02 - A*(Z02/Z01))/denom2;
    S12(kf) = 2*sqrt(Z02/Z01)*(A*D - B*C)/denom2;

    ph(kf)  = angle(S21(kf));
end

tau_g = -gradient(unwrap(ph), w);       % s (dφ/dω)

% ---- Resultados y tablas
T_res = table((1:N).', Lser.', Cser.', 'VariableNames',{'n','L_series_H','C_series_F'});
T_inv = table((1:N+1).', K.', 'VariableNames',{'n','K_Ohm'});
disp('--- Resonadores serie ---'); disp(T_res);
disp('--- Inversores ideales K ---'); disp(T_inv);

% ---- Plots
figure('Name','9) |S21| (dB)'); plot(f/1e9,20*log10(abs(S21)),'LineWidth',1.8); grid on; ylim([-80 1]);
xlabel('f (GHz)'); ylabel('|S_{21}| (dB)'); title('9) BPF: resonadores serie + K ideales');
xline(f0/1e9,'k--'); xline(f0*(1-FBW/2)/1e9,'k:'); xline(f0*(1+FBW/2)/1e9,'k:');

figure('Name','9) |S11| (dB)'); plot(f/1e9,20*log10(max(abs(S11),realmin)),'LineWidth',1.8); grid on; ylim([-80 1]);
xlabel('f (GHz)'); ylabel('|S_{11}| (dB)'); title('9) BPF: |S_{11}|');

figure('Name','9) tau_g (ns)'); plot(f/1e9,1e9*tau_g,'LineWidth',1.8); grid on;
xlabel('f (GHz)'); ylabel('\tau_g (ns)'); title('9) Retardo de grupo');


%% -------------------------
% B)10) Sustituir K por tramos λ/4 (Zq = K) y comparar con ideal
% -------------------------
% ---- Especificaciones
N=5; Rp_dB=0.1; Z0=50; f0=1.8e9; w0=2*pi*f0; FBW=0.15;
g = cheb_gi_equalripple(N,Rp_dB);       % [g0..gN+1], ladder comienza en SERIE
RA=Z0; RB=Z0;

% ---- Resonadores SERIE "elegidos arbitrariamente"
% Usamos el parámetro de pendiente x0i (Ω) igual para todos, típico de resonadores de línea.
x0 = (Z0*pi/2)*ones(1,N);               % puedes cambiar valores si quieres
Lser =  x0 / w0;                        % L_oi = x0i / w0
Cser = 1./(x0 * w0);                    % C_oi = 1/(x0i*w0)

f = linspace(0.3*f0, 3.0*f0, 3001);  w = 2*pi*f;
Z01=Z0; Z02=Z0;

S11_qw=zeros(size(w)); S21_qw=S11_qw; S22_qw=S11_qw; S12_qw=S11_qw; ph_qw=S11_qw;

for kf=1:numel(w)
    omg = w(kf);
    theta = (pi/2)*(f(kf)/f0);                    % βℓ de la línea, λ/4 en f0
    % Línea λ/4 con Zq = K(1)
    Zq = K(1);
    Ttot = [cos(theta), 1j*Zq*sin(theta); 1j*(1/Zq)*sin(theta), cos(theta)];

    for m=1:N
        % Resonador serie
        Zs = 1j*omg*Lser(m) + 1./(1j*omg*Cser(m));
        Tser = [1 Zs; 0 1];
        Ttot = Ttot * Tser;

        if m < N
            Zq = K(m+1);
            Tline = [cos(theta), 1j*Zq*sin(theta); 1j*(1/Zq)*sin(theta), cos(theta)];
            Ttot = Ttot * Tline;
        end
    end
    % Línea λ/4 de salida (Zq = K(N+1))
    Zq = K(N+1);
    Ttot = Ttot * [cos(theta), 1j*Zq*sin(theta); 1j*(1/Zq)*sin(theta), cos(theta)];

    % ---- ABCD -> S
    A=Ttot(1,1); B=Ttot(1,2); C=Ttot(2,1); D=Ttot(2,2);
    denom1 = A + B/Z02 + C*Z01 + D*(Z01/Z02);
    S21_qw(kf) = 2*sqrt(Z01/Z02)/denom1;
    S11_qw(kf) = (A + B/Z02 - C*Z01 - D*(Z01/Z02))/denom1;
    denom2     = D + B/Z01 + C*Z02 + A*(Z02/Z01);
    S22_qw(kf) = (D + B/Z01 - C*Z02 - A*(Z02/Z01))/denom2;
    S12_qw(kf) = 2*sqrt(Z02/Z01)*(A*D - B*C)/denom2;

    ph_qw(kf)  = angle(S21_qw(kf));
end

tau_g_qw = -gradient(unwrap(ph_qw), w);   % s

% ---- Tabla de "componentes" de los inversores λ/4
T_qw = table((1:N+1).', K.', repmat(f0,N+1,1), repmat(pi/2,N+1,1), ...
    'VariableNames',{'n','Zq_Ohm','=','betaL_at_f0_rad'});
disp('--- Inversores realizados con líneas λ/4 ---'); disp(T_qw);

% ---- Plots y comparación con el ideal (apartado 9)
figure('Name','10) |S21| comparación'); hold on; grid on;
plot(f/1e9,20*log10(abs(S21_qw)),'LineWidth',1.8);
plot(f/1e9,20*log10(abs(S21)),'--','LineWidth',1.3);
ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{21}| (dB)');
title('10) BPF: K ideales vs λ/4'); legend('|S_{21}| λ/4','|S_{21}| ideal','Location','SouthWest');
xline(f0/1e9,'k--'); xline(f0*(1-FBW/2)/1e9,'k:'); xline(f0*(1+FBW/2)/1e9,'k:');

figure('Name','10) |S11| comparación'); hold on; grid on;
plot(f/1e9,20*log10(max(abs(S11_qw),realmin)),'LineWidth',1.8);
plot(f/1e9,20*log10(max(abs(S11),realmin)),'--','LineWidth',1.3);
ylim([-80 1]); xlabel('f (GHz)'); ylabel('|S_{11}| (dB)');
legend('|S_{11}| λ/4','|S_{11}| ideal','Location','SouthWest'); title('10) |S_{11}|');

figure('Name','10) tau_g (ns) comparación'); hold on; grid on;
plot(f/1e9,1e9*tau_g_qw,'LineWidth',1.8);
plot(f/1e9,1e9*tau_g,'--','LineWidth',1.3);
xlabel('f (GHz)'); ylabel('\tau_g (ns)'); title('10) Retardo de grupo'); legend('λ/4','ideal');


