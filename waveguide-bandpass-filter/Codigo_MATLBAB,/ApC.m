%% Diseño Filtro Paso Banda

%% Inicializacion
clear all ; close all ; clc ;
j = sqrt(-1) ; % unidad imaginaria
c0=299792458; %velocidad de la luz en el vacío

% Selección de parámetros del filtro
N_orden = 4 ; % Orden del filtro N
fo_GHz = sqrt(9.8*10.2) ; % Frecuencia central en GHz
bw_MHz = 400 ; % Ancho de banda en MHz
Z0_Ohm = 50 ; %  Nivel de impedancia del sistema en Ohmios   
Qres = 1000000 ; % factor de calidad de los resonadores 
LAr_dB =0.04; % Selección del parámetro de rizado de Chebychev en transmisión en dB

% parámetros derivados
Deltabwfrac = ( bw_MHz * 1e-3 ) / fo_GHz ; % ancho de banda relativo tambien llamado fraccional (sin unidades) en tanto por uno
wo_radGHz = 2 * pi * fo_GHz ; % pulsación central en rad*GHz
Lr_dB=-10*log10(1.0-10.^(-LAr_dB/10.0)) ; % Rizado de Chebychev en reflexión en dB

% Datos para el barrido y representacion (estos datos no afectan el diseño, solo las graficas de respuestas)
npuntos_rep = 4001 ;   % Numero de puntos de frecuencia para el barrido y representar en las graficas
factorrep_inicial = 5  ;   % factor (sin dimensiones) para elegir la frecuencia inicial de barrido (en numero de veces del ancho de banda del filtro)
factorrep_final = 5  ;   % factor (sin dimensiones) para elegir la frecuencia final de barrido (en numero de veces del ancho de banda del filtro)
f_GHz_inicial = fo_GHz - factorrep_inicial * bw_MHz * 1e-3 ;    % Frecuencia inicial (GHz) del barrido
f_GHz_final = fo_GHz + factorrep_final * bw_MHz * 1e-3 ;        % Frecuencia final   (GHz) del barrido
f_GHz = linspace( f_GHz_inicial , f_GHz_final , npuntos_rep ) ; % vector de frecuencias para el barrido, en GHz

lw = 2 ; % linewidth lineas
yaxisUp = 0 ; % ylim alto del axis de parámtros S en dB
yaxisDown = -60 ; % ylim bajo del axis de parámtros S en dB

%% Valores circuitales del prototipo paso bajo

% Calculo g_0,...,g_{N+1} para respuesta Chevychev
g0 = 1 ; % valor de fuente
g = zeros( 1 , N_orden + 1 ) ; % init valores 1 a N del filtro, y carga: N + 1

% parametros auxiliares en el calculo de los parámetros g
beta=log(coth(LAr_dB/17.37));
gamma_1permm=sinh(beta/2/N_orden);
m=1:N_orden;
a=sin( (2*m-1)*pi/(2*N_orden) );
b=gamma_1permm^2 +(sin(m*pi/N_orden)).^2;

% valores g de los elementos del filtro
g(1)=2*a(1)/gamma_1permm;
for m=2:N_orden
   g(m)=4*a(m-1)*a(m)/b(m-1)/g(m-1);
end

% valor de la carga gN+1
if mod(N_orden,2) % impar
    g(N_orden+1)=1;
else  %par
    g(N_orden+1)=(coth(beta/4))^2;
end

%% Prototipo paso banda

prototipo =0; % Elije el prototipo a usar: 0 -> comienzo ramapa paralelo; 1 -> comienzo rama serie.
% Prototipo B (comienzo en rama serie, despues rama parelelo, depsues eerie, etc.)
if prototipo==1
    % fuente y carga
    Rg_Ohm = Z0_Ohm/g0 ;
    if mod(N_orden,2) % impar
        RL_Ohm = Z0_Ohm / g(N_orden+1) ;
    else
        RL_Ohm = g(N_orden+1) * Z0_Ohm ;
    end

    % elementos filtro
    L_nH = zeros( 1 , N_orden ) ;
    C_nF = zeros( 1 , N_orden ) ;
    RserieOhm_Q = zeros( 1 , N_orden ) ;
    GparaleloSie_Q = zeros( 1 , N_orden ) ;

    m = 1 : 2 : N_orden ; % ramas serie 
    L_nH(m) = g(m) ./ ( wo_radGHz * Deltabwfrac ) * Z0_Ohm ;  %L (nH) serie rama serie
    C_nF(m) = Deltabwfrac ./ ( wo_radGHz * g(m) ) / Z0_Ohm ;  %C (nF) serie rama serie
    RserieOhm_Q = sqrt( L_nH ./ C_nF ) ./ Qres ; % resistencia en Ohms de pérdidas (indeseada, pero siempre aparece, y se suele especificar indirectamente a través del Q)

    m = 2 : 2 : N_orden ; % ramas paralelo
    L_nH(m) = Deltabwfrac ./ ( wo_radGHz * g(m) ) * Z0_Ohm ;  %L (nH) paralelo rama paralelo
    C_nF(m) = g(m) ./ ( wo_radGHz * Deltabwfrac ) / Z0_Ohm ;  %C (nF) paralelo rama paralelo
    GparaleloSie_Q = sqrt( C_nF ./ L_nH ) ./ Qres ; %  conductnacia en siemens de pérdidas (indeseada, pero siempre aparece, y se suele especificar indirectamente a través del Q)

else
    % fuente y carga
    Rg_Ohm = g0 * Z0_Ohm ;
    if mod(N_orden,2) % impar
        RL_Ohm = Z0_Ohm * g(N_orden+1) ;
    else
        RL_Ohm = Z0_Ohm/g(N_orden+1) ;
    end

    % elementos filtro
    L_nH = zeros( 1 , N_orden ) ;
    C_nF = zeros( 1 , N_orden ) ;
    RserieOhm_Q = zeros( 1 , N_orden ) ;
    GparaleloSie_Q = zeros( 1 , N_orden ) ;

    m = 1 : 2 : N_orden ; % ramas paralelo
    L_nH(m) = Deltabwfrac ./ ( wo_radGHz * g(m) ) * Z0_Ohm ;  %L (nH) paralelo rama paralelo
    C_nF(m) = g(m) ./ ( wo_radGHz * Deltabwfrac ) / Z0_Ohm ;  %C (nF) paralelo rama paralelo
    GparaleloSie_Q = sqrt( C_nF ./ L_nH ) ./ Qres ; %  conductnacia en siemens de pérdidas (indeseada, pero siempre aparece, y se suele especificar indirectamente a través del Q)

    m = 2 : 2 : N_orden ; % ramas serie 
    L_nH(m) = g(m) ./ ( wo_radGHz * Deltabwfrac ) * Z0_Ohm ;  %L (nH) serie rama serie
    C_nF(m) = Deltabwfrac ./ ( wo_radGHz * g(m) ) / Z0_Ohm ;  %C (nF) serie rama serie
    RserieOhm_Q = sqrt( L_nH ./ C_nF ) ./ Qres ; % resistencia en Ohms de pérdidas (indeseada, pero siempre aparece, y se suele especificar indirectamente a través del Q)
 
end


%% Respuesta en frecuencia del filtro con elementos concentrados

% Calculo parámetros S sobre Z01,Z02
Z01 = Rg_Ohm ;
Z02 = RL_Ohm ;

if prototipo==1
    
    for k=1:npuntos_rep
        w_radGHz = 2*pi*f_GHz(k) ; % en rad * GHz
    
        % Inicializacion a matriz unidad
        Ttotal = eye(2) ;
        % buche para cada resonador
        for m=1:N_orden
            if mod(m,2) % impar
                zs = RserieOhm_Q(m) + j * w_radGHz * L_nH(m) + 1./( j * w_radGHz * C_nF(m) ) ; % ohmios
                Tres =[  1    zs ;  0   1 ] ; % matriz ABCD impedancia en rama serie: resonador serie 
            else 
                yp = GparaleloSie_Q(m) + j * w_radGHz * C_nF(m) + 1./( j * w_radGHz * L_nH(m) ) ; % siemens
                Tres =[  1    0 ;  yp  1 ] ; % matriz ABCD admitancia en rama parelelo: resonador paralelo 
            end
            % matriz ABCD del circuito desde la fuente a la rama actual #m
            Ttotal = Ttotal * Tres ;
        end
        
        % Paso de ABCD a parámetros S (B ohmios, C siemens), ver Pozar, Tabla 4.2, p. 192, resultados generalizados a Z01 y Z02 no necesariamente iguales
        At = Ttotal(1,1) ; Bt = Ttotal(1,2) ;
        Ct = Ttotal(2,1) ; Dt = Ttotal(2,2) ;
        denom1=At+Bt/Z02+Ct*Z01+Dt*Z01/Z02;
        s21_con(k) = 2*sqrt(Z01/Z02)/denom1;
        s11_con(k) = (At+Bt/Z02-Ct*Z01-Dt*Z01/Z02)/denom1;  
        denom2=Dt+Bt/Z01+Ct*Z02+At*Z02/Z01;
        s22_con(k)=(Dt+Bt/Z01-Ct*Z02-At*Z02/Z01)/denom2;
        s12_con(k)=2*sqrt(Z02/Z01)*(At*Dt-Bt*Ct)/denom2;  
    end

else
    for k=1:npuntos_rep
        w_radGHz = 2*pi*f_GHz(k) ; % en rad * GHz
    
        % Inicializacion a matriz unidad
        Ttotal = eye(2) ;
        % buche para cada resonador
        for m=1:N_orden
            if mod(m,2) % impar
                yp = GparaleloSie_Q(m) + j * w_radGHz * C_nF(m) + 1./( j * w_radGHz * L_nH(m) ) ; % siemens
                Tres =[  1    0 ;  yp  1 ] ; % matriz ABCD admitancia en rama parelelo: resonador paralelo
            else 
                zs = RserieOhm_Q(m) + j * w_radGHz * L_nH(m) + 1./( j * w_radGHz * C_nF(m) ) ; % ohmios
                Tres =[  1    zs ;  0   1 ] ; % matriz ABCD impedancia en rama serie: resonador serie 
            end
            % matriz ABCD del circuito desde la fuente a la rama actual #m
            Ttotal = Ttotal * Tres ;
        end
        
        % Paso de ABCD a parámetros S (B ohmios, C siemens), ver Pozar, Tabla 4.2, p. 192, resultados generalizados a Z01 y Z02 no necesariamente iguales
        At = Ttotal(1,1) ; Bt = Ttotal(1,2) ;
        Ct = Ttotal(2,1) ; Dt = Ttotal(2,2) ;
        denom1=At+Bt/Z02+Ct*Z01+Dt*Z01/Z02;
        s21_con(k) = 2*sqrt(Z01/Z02)/denom1;
        s11_con(k) = (At+Bt/Z02-Ct*Z01-Dt*Z01/Z02)/denom1;  
        denom2=Dt+Bt/Z01+Ct*Z02+At*Z02/Z01;
        s22_con(k)=(Dt+Bt/Z01-Ct*Z02-At*Z02/Z01)/denom2;
        s12_con(k)=2*sqrt(Z02/Z01)*(At*Dt-Bt*Ct)/denom2;  
    end
end
% plot en dB
s21_dB_con=20*log10(abs(s21_con));
s11_dB_con=20*log10(abs(s11_con));

%% ================== Máscaras de especificación y chequeo ==================
% ---- Especificaciones (en Hz) ----
f1=9.8e9; f2=10.2e9;
fPB = [f1; f2];           % Hz
ILreq_dB = 0.1;
RLreq_dB = 18;
SB = [ 8.00e9  9.25e9  40;
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];

f   = f_GHz*1e9;          % Hz


% figure('Name','S21 & S11 con máscaras'); 
hold on; grid on; box on;
p21 = plot(f/1e9, s21_dB_con, 'r', 'LineWidth', lw);
p11 = plot(f/1e9, s11_dB_con, 'b', 'LineWidth', lw);

xlim([min(f) max(f)]/1e9);
ylim([yaxisDown yaxisUp]);
xlabel('f (GHz)'); ylabel('Magnitud (dB)');
title('|S_{21}| y |S_{11}| con máscaras');

yl = ylim;

% Patches (sin cambios relevantes)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
patch([f1 f2 f2 f1]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.4, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:');

for r = 1:size(SB,1)
    Areq = -SB(r,3);
    plot([SB(r,1) SB(r,2)]/1e9, [Areq Areq], 'r-', 'LineWidth', 2);
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, [yl(1) yl(1) Areq Areq], ...
          [1.0 0.8 0.8],'FaceAlpha',0.25,'EdgeColor','none');
end
legend([p21 p11],'|S_{21}|','|S_{11}|','Location','NE');


%% ====== Detalle |S21| (dB) en PB para Q = 100, 1000, 10000 ======
Q_list = [100 1000 10000];
colQ = {[0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.0000 0.4470 0.7410]}; % colores
f_Hz = f_GHz*1e9;

figure('Name','Detalle |S21| (dB) — Q=100/1000/10000','Color','w'); hold on; grid on; box on;

% --- Máscara de IL en PB: de 0 a -ILreq (solo para S21) ---
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:','HandleVisibility','off');
yline(-ILreq_dB,'k--','-IL req','LabelHorizontalAlignment','left');
% --- Trazas |S21| por Q ---
hS21 = gobjects(1,numel(Q_list));
for iq = 1:numel(Q_list)
    Qres_i = Q_list(iq);

    % Pérdidas equivalentes (no se tocan L_nH/C_nF)
    Rserie_Q = sqrt(L_nH ./ C_nF) ./ Qres_i;   % ohm
    Gpar_Q   = sqrt(C_nF ./ L_nH) ./ Qres_i;   % S

    Z01 = Rg_Ohm;  Z02 = RL_Ohm;
    s21 = zeros(1,numel(f_GHz));

    for k = 1:numel(f_GHz)
        w = 2*pi*f_GHz(k);
        Ttotal = eye(2);

        for m = 1:N_orden
            if prototipo==1
                if mod(m,2) % impar -> serie
                    zs  = Rserie_Q(m) + 1j*w*L_nH(m) + 1./(1j*w*C_nF(m));
                    Tres = [1 zs; 0 1];
                else        % par -> paralelo
                    yp  = Gpar_Q(m) + 1j*w*C_nF(m) + 1./(1j*w*L_nH(m));
                    Tres = [1 0; yp 1];
                end
            else
                if mod(m,2) % impar -> paralelo
                    yp  = Gpar_Q(m) + 1j*w*C_nF(m) + 1./(1j*w*L_nH(m));
                    Tres = [1 0; yp 1];
                else        % par -> serie
                    zs  = Rserie_Q(m) + 1j*w*L_nH(m) + 1./(1j*w*C_nF(m));
                    Tres = [1 zs; 0 1];
                end
            end
            Ttotal = Ttotal * Tres;
        end

        At=Ttotal(1,1); Bt=Ttotal(1,2); Ct=Ttotal(2,1); Dt=Ttotal(2,2);
        denom1 = At + Bt/Z02 + Ct*Z01 + Dt*Z01/Z02;
        s21(k) = 2*sqrt(Z01/Z02)/denom1;
    end

    s21_dB = 20*log10(abs(s21));
    hS21(iq) = plot(f_GHz, s21_dB, 'LineWidth', lw, 'Color', colQ{iq}, ...
                    'DisplayName', sprintf('Q = %d', Qres_i));
end

% --- Ejes y rótulos (mismos del detalle anterior) ---
xlim([9.7 10.3]);
ylim([-0.5 0]);                % equivalente a IL de 0…0.5 dB
xlabel('f (GHz)'); ylabel('|S_{21}|^2 (dB)');
title('Rizado |S_{21}|^2 — elementos concentrados con pérdidas (Q=100/1000/10000)');

legend(hS21, 'Location','SW');



%% Implementación del filtro con inversores y resonadores

Zc=1; %impedancia característica de los resonadores
alpha0=0;
beta0=2*pi*fo_GHz*1e9/c0;
d=pi/beta0;

% fuente y carga
RA_Ohm = Z0_Ohm ;
RB_Ohm = Z0_Ohm ;

% Parámetros del futuro resonador hecho en línea: todos de impedancia característica Z0 y n*lambda/2 ;
ordennreslin = 1 ; % orden del futuro resonador en línea
theta0lin_rad = ordennreslin * pi ;  % longitud eléctrica a la frecuencia fo_GHz del futuro resonador en línea
x0lin_Sie = Zc * theta0lin_rad / 2 * ones( 1 , N_orden ) ; % pendiente de todos los futuros resonadores en línea

% inversores del filtro
Kinv = zeros( 1 , N_orden + 1 ) ;

m = 1 ; 
Kinv(m) = sqrt( Deltabwfrac * (RA_Ohm) * x0lin_Sie( m ) ./ ( g0 .* g( m ) ) ) ;

m = 2 : 1 : N_orden ; 
Kinv(m) = Deltabwfrac * sqrt( x0lin_Sie( m - 1 ) .* x0lin_Sie( m ) ./ ( g( m - 1 ) .* g( m  ) ) ) ;

m = N_orden + 1 ; 
Kinv(m) = sqrt( Deltabwfrac * x0lin_Sie( m - 1 ) * (RB_Ohm) / ( g( m - 1 ) * g( m ) ) ) ;

% Calculo parámetros S sobre Z01,Z02
Z01 = RA_Ohm ;
Z02 = RB_Ohm ;
for k=1:npuntos_rep
    w_radGHz = 2*pi*f_GHz(k) ; % en rad * GHz
    fHz=f_GHz(k)*1e9;
    % Inicializacion bucle con primer inversor
    m = 0 ;
    Tinv = [ 0 j*Kinv(m+1) ; j/Kinv(m+1) 0 ] ;
    Ttotal = Tinv ;

    % buche para cada pareja resonador + inversor ideal (invariante en frecuencia)
    for m=1:N_orden
        beta = 2*pi*fHz/c0;          % rad/m
        gamma = alpha0 + j*beta;

       % resonador
       Tres =[  cosh(gamma*d)    Zc*sinh(gamma*d) ;  sinh(gamma*d)/Zc   cosh(gamma*d) ] ; % matriz ABCD resonador serie (linea lambda/2)

       % inversor
       Tinv = [ 0 j*Kinv(m+1) ; j/Kinv(m+1) 0 ] ; % matriz ABCD inversor ideal

       % ABCD desde la fuenta a la pareja
       Ttotal = Ttotal * Tres * Tinv ;
    end
    
    % Paso de ABCD a parámetros S (B ohmios, C siemens), ver Pozar, Tabla 4.2, p. 192, resultados generalizados a Z01 y Z02 no necesariamente iguales
    At = Ttotal(1,1) ; Bt = Ttotal(1,2) ;
    Ct = Ttotal(2,1) ; Dt = Ttotal(2,2) ;
    denom1=At+Bt/Z02+Ct*Z01+Dt*Z01/Z02;
    s21_inv(k) = 2*sqrt(Z01/Z02)/denom1;
    s11_inv(k) = (At+Bt/Z02-Ct*Z01-Dt*Z01/Z02)/denom1;    
    denom2=Dt+Bt/Z01+Ct*Z02+At*Z02/Z01;
    s22_inv(k)=(Dt+Bt/Z01-Ct*Z02-At*Z02/Z01)/denom2;
    s12_inv(k)=2*sqrt(Z02/Z01)*(At*Dt-Bt*Ct)/denom2;     
end

s21_dB_inv = 20*log10(abs(s21_inv));
s11_dB_inv = 20*log10(abs(s11_inv));


%% ================== Máscaras de especificación y chequeo ==================
% ---- Especificaciones (en Hz) ----
f1=9.8e9; f2=10.2e9;
fPB = [f1; f2];           % Hz
ILreq_dB = 0.1;
RLreq_dB = 20;
SB = [ 8.00e9  9.25e9  40;
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];

f   = f_GHz*1e9;          % Hz

figure('Name','S21 & S11 con máscaras'); hold on; grid on; box on;
p21 = plot(f/1e9, s21_dB_inv, 'r', 'LineWidth', lw);
p11 = plot(f/1e9, s11_dB_inv, 'b', 'LineWidth', lw);

xlim([min(f) max(f)]/1e9);
ylim([yaxisDown yaxisUp]);
xlabel('f (GHz)'); ylabel('Magnitud (dB)');
title('|S_{21}| y |S_{11}| con máscaras');

yl = ylim;

% Patches (sin cambios relevantes)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
patch([f1 f2 f2 f1]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.4, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:');

for r = 1:size(SB,1)
    Areq = -SB(r,3);
    plot([SB(r,1) SB(r,2)]/1e9, [Areq Areq], 'r-', 'LineWidth', 2);
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, [yl(1) yl(1) Areq Areq], ...
          [1.0 0.8 0.8],'FaceAlpha',0.25,'EdgeColor','none');
end
legend([p21 p11],'|S_{21}|','|S_{11}|','Location','NE');


%% ===== FIGURA ÚNICA: IL & RL (concentrados vs líneas+inversores) con máscaras =====

% Colores solicitados
col_IL = {[0.9290 0.6940 0.1250], 'r'};   % IL: dorado, rojo
col_RL = {[0.8500 0.3250 0.0980], 'b'};   % RL: rojo anaranjado, azul

figure('Name','IL & RL — concentrados vs líneas+inversores','Color','w');
hold on; grid on; box on;

% ---- Curvas ----
pIL_con = plot(f_GHz, s21_dB_con, '-',  'Color', col_IL{1}, 'LineWidth', lw); % IL conc (dorado)
pIL_inv = plot(f_GHz, s21_dB_inv, '-',  'Color', col_IL{2}, 'LineWidth', lw); % IL líneas (rojo)
pRL_con = plot(f_GHz, s11_dB_con, '-', 'Color', col_RL{1}, 'LineWidth', lw); % RL conc (rojo anaranjado)
pRL_inv = plot(f_GHz, s11_dB_inv, '-', 'Color', col_RL{2}, 'LineWidth', lw); % RL líneas (azul)

xlabel('f (GHz)'); ylabel('dB');
title('|S_{21}|^2 y |S_{11}|^2 — concentrados vs líneas+inversores');

% Ejes
xlim([min(f_GHz) max(f_GHz)]);    % o fija p.ej.: xlim([9 12])
% yMax = max([ IL_con_dB(:); RL_con_dB(:); IL_inv_dB(:); RL_inv_dB(:); ...
%              ILreq_dB+5; RLreq_dB+5; SB(:,3)+5 ]);
ylim([-60 0]); 
yl = ylim;

% ==== Máscaras (coherentes con IL/RL positivos) ====
% PB: |S21| >= -ILreq (zona válida entre 0 y -ILreq)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
% PB: |S11| <= -RLreq (zona válida por debajo de -RLreq)
patch([f1 f2 f2 f1]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.4, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:');

% Stopbands: IL >= Areq (umbral y parche por encima)
for r = 1:size(SB,1)
    Areq_dB = -SB(r,3);                           % negativo (p. ej., -40)
    plot([SB(r,1) SB(r,2)]/1e9, [Areq_dB Areq_dB], 'r-', 'LineWidth', 2);
    % Máscara desde 0 hasta Areq_dB (no hasta -inf)
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, ...
          [0 0 Areq_dB Areq_dB], [1.0 0.8 0.8], ...
          'FaceAlpha',0.25, 'EdgeColor','none');
end


% Leyenda
legend([pIL_con pIL_inv pRL_con pRL_inv], ...
       {'|S_{21}|^2 (concentrados)','|S_{21}|^2 (líneas+inv.)','|S_{11}|^2 (concentrados)','|S_{11}|^2 (líneas+inv.)'}, ...
       'Location','NE');

%% Implementación del filtro con inversores y resonadores con pérdidas

% Parámetros del futuro resonador hecho en línea: todos de impedancia característica Z0 y n*lambda/2 ;
ordennreslin = 1 ; % orden del futuro resonador en línea
theta0lin_rad = ordennreslin * pi ;  % longitud eléctrica a la frecuencia fo_GHz del futuro resonador en línea
x0lin_Sie = Zc * theta0lin_rad / 2 * ones( 1 , N_orden ) ; % pendiente de todos los futuros resonadores en línea

Zc=1; %impedancia característica de los resonadores
beta0=2*pi*fo_GHz*1e9/c0;
d=pi/beta0;
alpha0 = theta0lin_rad/(2*Qres*d);

% fuente y carga
RA_Ohm = Z0_Ohm ;
RB_Ohm = Z0_Ohm ;

% inversores del filtro
Kinv = zeros( 1 , N_orden + 1 ) ;

m = 1 ; 
Kinv(m) = sqrt( Deltabwfrac * (RA_Ohm) * x0lin_Sie( m ) ./ ( g0 .* g( m ) ) ) ;

m = 2 : 1 : N_orden ; 
Kinv(m) = Deltabwfrac * sqrt( x0lin_Sie( m - 1 ) .* x0lin_Sie( m ) ./ ( g( m - 1 ) .* g( m  ) ) ) ;

m = N_orden + 1 ; 
Kinv(m) = sqrt( Deltabwfrac * x0lin_Sie( m - 1 ) * (RB_Ohm) / ( g( m - 1 ) * g( m ) ) ) ;

% Calculo parámetros S sobre Z01,Z02
Z01 = RA_Ohm ;
Z02 = RB_Ohm ;
for k=1:npuntos_rep
    w_radGHz = 2*pi*f_GHz(k) ; % en rad * GHz
    fHz=f_GHz(k)*1e9;
    % Inicializacion bucle con primer inversor
    m = 0 ;
    Tinv = [ 0 j*Kinv(m+1) ; j/Kinv(m+1) 0 ] ;
    Ttotal = Tinv ;

    % buche para cada pareja resonador + inversor ideal (invariante en frecuencia)
    for m=1:N_orden
        beta = 2*pi*fHz/c0;          % rad/m
        gamma = alpha0 + j*beta;

       % resonador
       Tres =[  cosh(gamma*d)    Zc*sinh(gamma*d) ;  sinh(gamma*d)/Zc   cosh(gamma*d) ] ; % matriz ABCD resonador serie (linea lambda/2)

       % inversor
       Tinv = [ 0 j*Kinv(m+1) ; j/Kinv(m+1) 0 ] ; % matriz ABCD inversor ideal

       % ABCD desde la fuenta a la pareja
       Ttotal = Ttotal * Tres * Tinv ;
    end
    
    % Paso de ABCD a parámetros S (B ohmios, C siemens), ver Pozar, Tabla 4.2, p. 192, resultados generalizados a Z01 y Z02 no necesariamente iguales
    At = Ttotal(1,1) ; Bt = Ttotal(1,2) ;
    Ct = Ttotal(2,1) ; Dt = Ttotal(2,2) ;
    denom1=At+Bt/Z02+Ct*Z01+Dt*Z01/Z02;
    s21_inv(k) = 2*sqrt(Z01/Z02)/denom1;
    s11_inv(k) = (At+Bt/Z02-Ct*Z01-Dt*Z01/Z02)/denom1;    
    denom2=Dt+Bt/Z01+Ct*Z02+At*Z02/Z01;
    s22_inv(k)=(Dt+Bt/Z01-Ct*Z02-At*Z02/Z01)/denom2;
    s12_inv(k)=2*sqrt(Z02/Z01)*(At*Dt-Bt*Ct)/denom2;     
end

s21_dB_inv_loss = 20*log10(abs(s21_inv));
s11_dB_inv_loss = 20*log10(abs(s11_inv));

%% ==== Comparativa en LÍNEAS+INVERSORES con pérdidas: Q = 100, 1000, 10000 ====
Q_list = [100 1000 10000];

% Colores para las tres curvas (consistentes con tu paleta)
colQ = {[0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.0000 0.4470 0.7410]}; % naranja, dorado, azul

% Ventanas de chequeo
f_Hz = f_GHz*1e9;
inBand = (f_Hz >= f1) & (f_Hz <= f2);
inSB1  = (f_Hz >= SB(1,1)) & (f_Hz <= SB(1,2));
inSB2  = (f_Hz >= SB(2,1)) & (f_Hz <= SB(2,2));
inSB3  = (f_Hz >= SB(3,1)) & (f_Hz <= SB(3,2));

% Almacenamos PASS/FAIL (se evalúan si quieres más abajo)
pass_IL = false(size(Q_list));
pass_RL = false(size(Q_list));
pass_SB = false(size(Q_list));

% ===================== FIGURA DE DETALLE |S21| (dB) =====================
figure('Name','Detalle |S21| — Líneas+Inversores con pérdidas (Q=100/1000/10000)','Color','w');
hold on; grid on; box on;

% Máscara de especificación en PB: de 0 a -ILreq (coherente con dB negativos)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
yline(-ILreq_dB,'k--','-IL req','LabelHorizontalAlignment','left');
xline([f1 f2]/1e9,'k:','HandleVisibility','off');

hQ = gobjects(1,numel(Q_list));
Z01 = RA_Ohm;  Z02 = RB_Ohm;

for iq = 1:numel(Q_list)
    Qres_i = Q_list(iq);

    % Atenuación por pérdidas de la línea equivalente al Q dado (Np/m):
    % alpha0 = theta0lin_rad/(2*Q*d)   (constante con f)
    alpha0_i = theta0lin_rad/(2*Qres_i*d);

    % Barrido S-params con este Q
    s21_i = zeros(1, numel(f_GHz));
    s11_i = zeros(1, numel(f_GHz));

    for k = 1:numel(f_GHz)
        fHz = f_GHz(k)*1e9;
        beta = 2*pi*fHz/c0;                 % rad/m
        gamma = alpha0_i + 1j*beta;         % constante de propagación

        % ABCD total: inversor inicial + (línea λ/2 con pérdidas + inversor) x N_orden
        Ttotal = [0 1j*Kinv(1); 1j/Kinv(1) 0];  % primer inversor
        for m = 1:N_orden
            Tres = [ cosh(gamma*d)        Zc*sinh(gamma*d) ; ...
                     (1/Zc)*sinh(gamma*d) cosh(gamma*d)    ];
            Tinv = [0 1j*Kinv(m+1); 1j/Kinv(m+1) 0];
            Ttotal = Ttotal * Tres * Tinv;
        end

        % ABCD -> S (Z01,Z02)
        At=Ttotal(1,1); Bt=Ttotal(1,2); Ct=Ttotal(2,1); Dt=Ttotal(2,2);
        denom1 = At + Bt/Z02 + Ct*Z01 + Dt*Z01/Z02;
        s21_i(k) = 2*sqrt(Z01/Z02)/denom1;
        s11_i(k) = (At+Bt/Z02 - Ct*Z01 - Dt*Z01/Z02)/denom1;
    end

    % |S21| en dB (negativo)
    s21_i_dB = 20*log10(abs(s21_i));

    % Traza |S21| y leyenda con Q
    hQ(iq) = plot(f_GHz, s21_i_dB, 'LineWidth', lw, 'Color', colQ{iq}, ...
                  'DisplayName', sprintf('Q = %d', Qres_i));

    % (Opcional) Evaluaciones PASS/FAIL si las quieres usar luego:
    % IL en PB -> requisito: |S21| >= -ILreq_dB  <=>  s21_dB >= -ILreq_dB
    pass_IL(iq) = all( s21_i_dB(inBand) >= -ILreq_dB );

    % RL en PB -> requisito: RL >= RLreq_dB  <=>  -20log10|S11| >= RLreq_dB
    RL_i = max(0, -20*log10(abs(s11_i)));
    pass_RL(iq) = all( RL_i(inBand) >= RLreq_dB );

    % Stopbands -> requisito: |S21| <= -Areq_dB
    pass_SB1 = all( s21_i_dB(inSB1) <= -SB(1,3) );
    pass_SB2 = all( s21_i_dB(inSB2) <= -SB(2,3) );
    pass_SB3 = all( s21_i_dB(inSB3) <= -SB(3,3) );
    pass_SB(iq) = pass_SB1 & pass_SB2 & pass_SB3;
end

% Ejes de detalle pedidos
xlim([9.7 10.3]);
ylim([-0.5 0]);                  % equivalente a IL de 0..0.5 dB
xlabel('f (GHz)'); ylabel('|S_{21}|^2 (dB)');
title('Rizado |S_{21}|^2 — Líneas+Inversores con pérdidas (Q=100/1000/10000)');
legend(hQ, 'Location','SW');




%% ================== Máscaras de especificación y chequeo ==================
% ---- Especificaciones (en Hz) ----
f1=9.8e9; f2=10.2e9;
fPB = [f1; f2];           % Hz
ILreq_dB = 0.1;
RLreq_dB = 20;
SB = [ 8.00e9  9.25e9  40;
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];

f   = f_GHz*1e9;          % Hz

figure('Name','S21 & S11 con máscaras'); hold on; grid on; box on;
p21 = plot(f/1e9, s21_dB_inv_loss, 'r', 'LineWidth', lw);
p11 = plot(f/1e9, s11_dB_inv_loss, 'b', 'LineWidth', lw);

xlim([min(f) max(f)]/1e9);
ylim([yaxisDown yaxisUp]);
xlabel('f (GHz)'); ylabel('Magnitud (dB)');
title('|S_{21}| y |S_{11}| con máscaras');

yl = ylim;

% Patches (sin cambios relevantes)
patch([f1 f2 f2 f1]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');
patch([f1 f2 f2 f1]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.4, 'EdgeColor','none');
xline([f1 f2]/1e9,'k:');

for r = 1:size(SB,1)
    Areq = -SB(r,3);
    plot([SB(r,1) SB(r,2)]/1e9, [Areq Areq], 'r-', 'LineWidth', 2);
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, [yl(1) yl(1) Areq Areq], ...
          [1.0 0.8 0.8],'FaceAlpha',0.25,'EdgeColor','none');
end
legend([p21 p11],'|S_{21}|','|S_{11}|','Location','NE');


%% ====================== DRIVER: barrer Q y graficar (12) y (14) ======================
Qlist = [100 1000 10000];
f = f_GHz*1e9;                          % Hz
fwin = [9.7e9 10.3e9];                  % ventana de detalle
ILreq_dB = 0.1;

% ---- (12) Elementos concentrados con pérdidas por Q ----
figure('Name','(12) IL S21 — Concentrados vs Q'); hold on; grid on; box on;
leg = strings(1,numel(Qlist));
minIL_con = zeros(1,numel(Qlist));
for iq = 1:numel(Qlist)
    [S21dB_con_Q, minIL_con(iq)] = run_lumped_Q( ...
        Qlist(iq), N_orden, g0, g, prototipo, ...
        Z0_Ohm, Deltabwfrac, wo_radGHz, f_GHz);
    plot(f/1e9, S21dB_con_Q, 'LineWidth', 2);
    leg(iq) = sprintf('Q=%d (IL_min=%.3f dB)', Qlist(iq), minIL_con(iq));
end
xlim(fwin/1e9); ylim([-0.5 0]);
xlabel('f (GHz)'); ylabel('|S_{21}| (dB)');
title('(12) Concentrados: detalle pérdidas de inserción (9.7–10.3 GHz)');
yline(-ILreq_dB,'k--','IL req'); legend(leg,'Location','SouthWest');

% ---- (14) Líneas λ/2 + K con pérdidas por Q ----
figure('Name','(14) IL S21 — Líneas λ/2 vs Q'); hold on; grid on; box on;
leg = strings(1,numel(Qlist));
minIL_line = zeros(1,numel(Qlist));
for iq = 1:numel(Qlist)
    [S21dB_lin_Q, minIL_line(iq)] = run_lines_Q( ...
        Qlist(iq), N_orden, g0, g, Z0_Ohm, ...
        Deltabwfrac, fo_GHz, f_GHz);
    plot(f/1e9, S21dB_lin_Q, 'LineWidth', 2);
    leg(iq) = sprintf('Q=%d (IL_min=%.3f dB)', Qlist(iq), minIL_line(iq));
end
xlim(fwin/1e9); ylim([-0.5 0]);
xlabel('f (GHz)'); ylabel('|S_{21}| (dB)');
title('(14) Líneas λ/2 + K: detalle pérdidas de inserción (9.7–10.3 GHz)');
yline(-ILreq_dB,'k--','IL req'); legend(leg,'Location','SouthWest');






%% ====================== FUNCIONES LOCALES (compactas) ======================

function [S21dB, ILmin] = run_lumped_Q(Qres, N_orden, g0, g, prototipo, Z0, Deltabwfrac, wo, f_GHz)
    % ---------- Síntesis (idéntica a la tuya) ----------
    % Fuente/carga (no se usan aquí para ABCD->S, pero las dejamos coherentes)
    if prototipo==1
        Rg = Z0/g0;
        if mod(N_orden,2), RL = Z0/g(N_orden+1); else, RL = Z0*g(N_orden+1); end
    else
        Rg = g0*Z0;
        if mod(N_orden,2), RL = Z0*g(N_orden+1); else, RL = Z0/g(N_orden+1); end
    end

    % Elementos
    Ls = zeros(1,N_orden);  Cs = zeros(1,N_orden);  % <— nombres no conflictivos
    Rser = zeros(1,N_orden); Gpar = zeros(1,N_orden);

    if prototipo==1
        m = 1:2:N_orden;  Ls(m) = g(m)./(wo*Deltabwfrac)*Z0;  Cs(m) = Deltabwfrac./(wo*g(m))/Z0;   Rser = sqrt(Ls./Cs)./Qres;
        m = 2:2:N_orden;  Ls(m) = Deltabwfrac./(wo*g(m))*Z0;  Cs(m) = g(m)./(wo*Deltabwfrac)/Z0;  Gpar = sqrt(Cs./Ls)./Qres;
    else
        m = 1:2:N_orden;  Ls(m) = Deltabwfrac./(wo*g(m))*Z0;  Cs(m) = g(m)./(wo*Deltabwfrac)/Z0;  Gpar = sqrt(Cs./Ls)./Qres;
        m = 2:2:N_orden;  Ls(m) = g(m)./(wo*Deltabwfrac)*Z0;  Cs(m) = Deltabwfrac./(wo*g(m))/Z0;   Rser = sqrt(Ls./Cs)./Qres;
    end

    % ---------- Barrido ----------
    Z01 = Rg; Z02 = RL;  npts = numel(f_GHz);
    S21 = zeros(1,npts);

    for k = 1:npts
        w = 2*pi*f_GHz(k);
        T = eye(2);

        for m = 1:N_orden
            % Serie si: (proto==1 & m impar)  o  (proto==0 & m par)
            isSeries = (prototipo==1 && mod(m,2)==1) || (prototipo==0 && mod(m,2)==0);

            if isSeries
                zs   = Rser(m) + 1j*w*Ls(m) + 1./(1j*w*Cs(m));
                Tres = [1 zs; 0 1];
            else
                yp   = Gpar(m) + 1j*w*Cs(m) + 1./(1j*w*Ls(m));
                Tres = [1 0; yp 1];
            end

            T = T*Tres;
        end

        % ¡OJO!: no pisar Cs/Ls. Renombro ABCD:
        At = T(1,1); Bt = T(1,2); Ct = T(2,1); Dt = T(2,2);
        den = At + Bt/Z02 + Ct*Z01 + Dt*Z01/Z02;
        S21(k) = 2*sqrt(Z01/Z02)/den;
    end

    S21dB = 20*log10(abs(S21));
    f = f_GHz*1e9; mask = (f>=9.7e9)&(f<=10.3e9);
    ILmin = -max(S21dB(mask));
end


function [S21dB, ILmin] = run_lines_Q(Qres, N_orden, g0, g, Z0, Deltabwfrac, fo_GHz, f_GHz)
    % Implementación líneas λ/2 + inversores con pérdidas por Q
    Zc = 1;                                  % normalizada
    theta0 = pi;                             % λ/2 a f0
    x0 = Zc*theta0/2*ones(1,N_orden);
    % Inversores (idéntico a tu código):
    K = zeros(1, N_orden+1);
    K(1) = sqrt(Deltabwfrac*(Z0)*x0(1)/(g0*g(1)));
    for m=2:N_orden, K(m) = Deltabwfrac*sqrt(x0(m-1)*x0(m)/(g(m-1)*g(m))); end
    K(N_orden+1) = sqrt(Deltabwfrac*x0(N_orden)*Z0/(g(N_orden)*g(N_orden+1)));
    % Geometría λ/2 y pérdidas a partir de Q:
    c0 = 299792458;                           % m/s (no toco tu 'c' global)
    beta0 = 2*pi*(fo_GHz*1e9)/c0;             % rad/m
    d = pi/beta0;                             % m
    alpha0 = beta0/(2*Qres);                  % Np/m @ f0
    alpha_fun = @(fHz) alpha0;                % constante (puedes cambiar a sqrt(f) si quieres)
    % Barrido ABCD:
    Z01 = Z0; Z02 = Z0;  npts=numel(f_GHz);
    S21 = zeros(1,npts);
    for k=1:npts
        fHz = f_GHz(k)*1e9;
        beta = 2*pi*fHz/c0;
        alpha = alpha_fun(fHz);
        gamma = alpha + 1j*beta;
        T = [0 1j*K(1); 1j/K(1) 0];           % primer inversor
        for m=1:N_orden
            ch = cosh(gamma*d); sh = sinh(gamma*d);
            Tline = [ch, Zc*sh; sh/Zc, ch];
            Tinv  = [0 1j*K(m+1); 1j/K(m+1) 0];
            T = T*Tline*Tinv;
        end
        A=T(1,1); B=T(1,2); C=T(2,1); D=T(2,2);
        den = A + B/Z02 + C*Z01 + D*Z01/Z02;
        S21(k) = 2*sqrt(Z01/Z02)/den;
    end
    S21dB = 20*log10(abs(S21));
    f = f_GHz*1e9; mask = (f>=9.7e9)&(f<=10.3e9);
    ILmin = -max(S21dB(mask));
end

function out = tern(cond)
    if cond, out = 'PASS'; else, out = 'FAIL'; end
end




