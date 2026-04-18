%% Inicializacion
clear all ; close all ; clc ;
j = sqrt(-1) ; % unidad imaginaria
c0=299792458; %velocidad de la luz en el vacío

% Selección de parámetros del filtro
N_orden = 4 ; % Orden del filtro N
fo_GHz = sqrt(9.8*10.2) ; % Frecuencia central en GHz
bw_MHz = 400 ; % Ancho de banda en MHz
Z0_Ohm = 50 ; %  Nivel de impedancia del sistema en Ohmios   
Qres = 10000 ; % factor de calidad de los resonadores 
LAr_dB =0.04; % Selección del parámetro de rizado de Chebychev en transmisión en dB

% parámetros derivados
Deltabwfrac = ( bw_MHz * 1e-3 ) / fo_GHz; % ancho de banda relativo tambien llamado fraccional (sin unidades) en tanto por uno
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

s21_dB_inv_13 = 20*log10(abs(s21_inv));
s11_dB_inv_13 = 20*log10(abs(s11_inv));
IL_dB_13 = -20*log10(abs(s21_inv));   % Insertion Loss
RL_dB_13 = -20*log10(abs(s11_inv));   % Return Loss


%% =========== APARTADO D: IMPLEMENTACIÓN EN GUIA ========================
%Implementación del filtro con inversores y resonadores en guia (15)
% --- Geometría WR75 y utilidades TE10 ---
a_WR75 = 19.05e-3;                 % m
b_WR75=9.525e-3;                   % m
t_iris=1.5e-3;                     % m


eta0 = 376.730313668;

fcTE101 = c0/(2*a_WR75);                % Hz
beta_TE101 = @(fHz) (2*pi*fHz/c0).*sqrt(1-((fcTE101./fHz).^2));            % rad/m
Z_TE101    = @(fHz) eta0./sqrt(1-(fcTE101./fHz).^2);                     % ohm

% --- Frecuencias clave (Hz)
f1 = 9.8e9; f2 = 10.2e9; f0 = sqrt(f1*f2);

% --- Parámetros de guía a f0 y Δ′ ---
beta0 = beta_TE101(f0);
Delta_p = (beta_TE101(f2)-beta_TE101(f1))/beta0;       % Δ′ pedido
Zc_g0 = 1;                                   % Z_TE en f0
q=1;
theta0 = pi*q;                                         % λg/2 a f0
Zc=1;                                            %impedancia característica de los resonadores
x0 = Zc*theta0/2 * ones(1, N_orden);              % pendiente resonador
d=theta0/beta0;
alpha=theta0/(2*Qres*d);

lambda_0 = c0/f0;
lambda_g = lambda_0./sqrt(1-(fcTE101./f0).^2);
% Long = lambda_g/2;

% d_WR75=pi/sqrt((2*pi*f0/c0)^(2)-(pi/a_WR75)^2);

% fuente y carga
RA_Ohm = 1 ;
RB_Ohm = 1 ;


% Parámetros del futuro resonador hecho en línea: todos de impedancia característica Z0 y n*lambda/2 ;
Kinv = zeros( 1 , N_orden + 1 ) ;

m = 1 ; 
Kinv(m) = sqrt( Delta_p * (RA_Ohm) * x0( m ) ./ ( g0 .* g( m ) ) ) ;

m = 2 : 1 : N_orden ; 
Kinv(m) = Delta_p * sqrt( x0( m - 1 ) .* x0( m ) ./ ( g( m - 1 ) .* g( m ) ) ) ;

m = N_orden + 1 ; 
Kinv(m) = sqrt( Delta_p * x0( m - 1 ) * (RB_Ohm) / ( g( m - 1 ) * g( m ) ) ) ;


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
   
   % bucle para cada pareja resonador + inversor ideal (invariante en frecuencia)
   for m=1:N_orden
       beta = beta_TE101(fHz);          % rad/m
       gamma = alpha + j*beta;
     
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

s21_dB_inv_15 = 20*log10(abs(s21_inv)); 
s11_dB_inv_15 = 20*log10(abs(s11_inv));
IL_dB_15 = -20*log10(abs(s21_inv));   % Insertion Loss
RL_dB_15 = -20*log10(abs(s11_inv));   % Return Loss
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

figure('Name','S21 & S11 con máscaras'); hold on; grid on; box on;
p21 = plot(f/1e9, s21_dB_inv_15, 'r', 'LineWidth', lw);
p11 = plot(f/1e9, s11_dB_inv_15, 'b', 'LineWidth', lw);

xlim([min(f) max(f)]/1e9);
ylim([yaxisDown yaxisUp]);
xlabel('f (GHz)'); ylabel('Magnitud (dB)');
title('15 |S_{21}| y |S_{11}| con máscaras');

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


%% ================== Máscaras de especificación y chequeo ==================
% ---- Especificaciones (en Hz) ----
f1=9.8e9; f2=10.2e9;
fPB = [f1; f2];           % Hz
ILreq_dB = 0.1;           % máx. pérdida de inserción en PB (dB)
RLreq_dB = 18;            % mín. return loss en PB (dB)
SB = [ 8.00e9  9.25e9  40;   % mín. atenuación (dB) en stopbands
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];

f   = f_GHz*1e9;          % Hz


figure('Name','IL & RL con máscaras'); hold on; grid on; box on;
pIL = plot(f/1e9, s21_dB_inv_15, 'r', 'LineWidth', lw);
pRL = plot(f/1e9, s11_dB_inv_15, 'b', 'LineWidth', lw);
pIL_13 = plot(f/1e9, s21_dB_inv_13, 'Color',[0.9290 0.6940 0.1250], 'LineWidth', lw);
pRL_13 = plot(f/1e9, s11_dB_inv_13, 'Color',[0.8500 0.3250 0.0980], 'LineWidth', lw);

xlim([min(f) max(f)]/1e9);
xlabel('f (GHz)'); ylabel('dB');
title('Comparativa: Ap.13 (TEM) vs Ap.15 (TE_{101})');

% Ajuste de ejes para visualizar bandas (0 ... máximo de interés)
yMax = 60;
ylim([-60 0]);
yl = ylim;

% ==== Parches de especificación ====
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
legend([pIL pRL pIL_13 pRL_13],'|S_{21}|^2 Ap. 15 (TE_{101})','|S_{11}|^2 Ap. 15 (TE_{101})','|S_{21}|^2 Ap. 13 (TEM)','|S_{11}|^2 Ap. 13 (TEM)','Location','NE');

%% === Iris width synthesis from ideal inverters (WR-75) ===
% Requisitos: calculaMM(vfrec_GHz, va_mm, vd_mm, b0_mm)
a_mm=a_WR75*1e3;
b_mm=b_WR75*1e3;
t_mm=t_iris*1e3;

K_target_norm = Kinv(:).';    % 1 x (N_orden+1)

% ----- Tabla K/Zc vs anchura w -----
vw_mm = linspace(5, 15, 5000);   % barrido de anchuras factibles
Nw = numel(vw_mm);
vK_norm = nan(1,Nw);
vtheta  = nan(1,Nw);

for ii = 1:Nw
    w = vw_mm(ii);
    va_mm = [a_mm, w, a_mm];        % perfil a-w-a
    vd_mm = [0,    t_mm, 0];        % solo el iris (espesor t)
    [vS11, ~, ~] = calculaMM(fo_GHz, va_mm, vd_mm, b_mm);
    S11c = vS11;                                        % complejo
    vK_norm(ii) = sqrt( (1-abs(S11c)) / (1+abs(S11c)) );
    vtheta(ii)  = -angle(S11c)/2 + pi/2;               % rad
end

% ----- Interpolación para cada inversor -----
w_mm = nan(size(K_target_norm));
theta_m = nan(size(K_target_norm));
for m = 1:numel(K_target_norm)
    Km = K_target_norm(m);
    % chequeo de rango
    if Km < min(vK_norm) || Km > max(vK_norm)
        warning('K_target_norm(%d)=%.4f fuera de la tabla [%.4f, %.4f]. Ajusta vw_mm.',m, Km, min(vK_norm), max(vK_norm));       
    end
    w_mm(m)     = interp1(vK_norm, vw_mm, Km, 'pchip','extrap');
    theta_m(m)  = interp1(vK_norm, vtheta, Km, 'pchip','extrap');
end

% ----- Longitudes físicas de cavidad (entre irises) -----
factor_correcion=0.013; 
Lcav_m  = (pi - (theta_m(1:end-1) + theta_m(2:end))+factor_correcion) / beta0;  % [m]
Lcav_mm = 1e3 * Lcav_m;                                        % [mm]

% ----- Reporte rápido -----
% --- Tabla de irises (N+1 filas) ---
T_irises = table( (1:N_orden+1).', K_target_norm(:), w_mm(:), theta_m(:), ...
    'VariableNames', {'IrisIdx','Knorm','w_mm','theta_rad'});

% --- Tabla de cavidades (N filas) ---
theta_sum = theta_m(1:end-1) + theta_m(2:end);   % θ_m + θ_{m+1}
T_cav = table( (1:N_orden).', Lcav_mm(:), theta_sum(:), ...
    'VariableNames', {'CavIdx','Lcav_mm','theta_sum_rad'});

disp('=== Irises ==='); disp(T_irises);
disp('=== Cavidades ==='); disp(T_cav);

%% ====== Construcción del perfil (va_mm, vd_mm) y simulación ======
% Datos físicos (mm) ya definidos:
% a_mm, b_mm, t_mm;   % WR-75
% Además necesitas un margen de referencia en los extremos:
lref_mm = 20;                 % mm (igual que tu ejemplo)

% Frecuencias de simulación (GHz)
vfrec_GHz = linspace(8, 12, 401);    % ajusta al rango que quieras


% --- Vector de anchuras (va_mm): a - w1 - a - w2 - ... - a - w_{N+1} - a ---
va_mm = zeros(1, 2*(N_orden +1) + 1);
va_mm(1:2:end) = a_mm;              % posiciones impares: a
va_mm(2:2:end-1) = w_mm;            % posiciones pares: w_i

% --- Vector de longitudes (vd_mm): lref - t - Lcav1 - t - Lcav2 - ... - t - LcavN - t - lref ---
vd_mm = zeros(1, 2*(N_orden+1) + 1);
vd_mm(1) = lref_mm;
vd_mm(2:2:end-1) = t_mm;            % todos los irises con espesor t
vd_mm(3:2:end-2) = Lcav_mm;         % cavidades
vd_mm(end) = lref_mm;

% --- Dibuja perfil y simula ---
pintaPerfil(va_mm, vd_mm);

[vS11, vS21, vS22] = calculaMM(vfrec_GHz, va_mm, vd_mm, b_mm);

% --- Representación S-params + MÁSCARAS (todo en GHz) ---
figure('Name','S21 & S11 con máscaras'); hold on; grid on; box on;

% Curvas
p11 = plot(vfrec_GHz, 20*log10(abs(vS11)), 'b', 'LineWidth', 2);
p21 = plot(vfrec_GHz, 20*log10(abs(vS21)), 'r--', 'LineWidth', 2);

% Ejes y títulos
xlim([min(vfrec_GHz) max(vfrec_GHz)]);
xlabel('Frecuencia (GHz)'); ylabel('Magnitud (dB)');
title('Filtro en guía: perfil sintetizado (irises + cavidades con corrección de fase)');

% ================== Máscaras de especificación ==================
% --- Banda de paso (PB) y requisitos ---
f1 = 9.8; f2 = 10.2;         % GHz
ILreq_dB = 0.1;              % Inserción máxima permitida en PB
RLreq_dB = 18;               % Return Loss mínimo en PB

% --- Bandas de rechazo (SB): [f_ini f_fin Aten_min_dB] en GHz ---
SB = [  8.00   9.25   40;
       11.00  11.50   30;
       11.50  12.00   40 ];

% Limites verticales para parches
yl = ylim;

% Parches de PB:
% 1) Región de |S21| (por encima de -ILreq) -> parche verde claro en 0 a -ILreq
patch([f1 f2 f2 f1], [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none','HandleVisibility','off');

% 2) Región de |S11| (por debajo de -RLreq) -> parche azul claro desde -RLreq hasta el fondo
patch([f1 f2 f2 f1], [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.35, 'EdgeColor','none','HandleVisibility','off');

% Líneas verticales de PB
xline([f1 f2],'k:','HandleVisibility','off');

% Líneas y parches de SB
for r = 1:size(SB,1)
    Areq = -SB(r,3); % Atenuación mínima requerida (valor negativo en dB)
    % Línea del umbral en SB para |S21|
    plot([SB(r,1) SB(r,2)], [Areq Areq], 'r-', 'LineWidth', 2, 'HandleVisibility','off');
    % Parche rojizo por debajo del umbral (zona "permitida" de |S21| en SB)
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)], [yl(1) yl(1) Areq Areq], ...
          [1.0 0.8 0.8], 'FaceAlpha',0.25, 'EdgeColor','none','HandleVisibility','off');
end

%% ========= Añadir respuesta de CST (.s2p) y comparar en un único plot =========
% --- Ruta del Touchstone exportado por CST ---
file_cst = 'DiseñoBPF1.s2p';  % 

Sobj = sparameters(file_cst);           % maneja unidades y formato automáticamente
f_cst_Hz = Sobj.Frequencies(:);         % Hz
S_cst    = Sobj.Parameters;             % Nx2x2 complejo
% Extrae S11 y S21
S11_cst = squeeze(S_cst(1,1,:));
S21_cst = squeeze(S_cst(2,1,:));

% --- Interpolación de CST a eje f_GHz ---
f_cst_GHz = f_cst_Hz * 1e-9;
S11_cst_dB = 20*log10(abs(S11_cst));
S21_cst_dB = 20*log10(abs(S21_cst));
% % interp1 con extrap lineal para cubrir todo f_GHz si hace falta
% s11_dB_cst = interp1(f_cst_GHz, S11_cst_dB, f_GHz, 'pchip','extrap');
% s21_dB_cst = interp1(f_cst_GHz, S21_cst_dB, f_GHz, 'pchip','extrap');

% -------------------- PLOT ÚNICO con MÁSCARAS --------------------
f1=9.8e9; f2=10.2e9;                     % Hz
fPB = [f1; f2];
ILreq_dB = 0.1;                           % máx pérdida en PB
RLreq_dB = 18;                            % mín RL en PB
SB = [ 8.00e9  9.25e9  40;
      11.0e9 11.50e9  30;
      11.5e9 12.00e9  40 ];
f_Hz = f_GHz*1e9;

fig = figure('Name','Comparativa: calculaMM vs CST vs Concentrados','Color','w');
hold on; grid on;
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


% calculaMM
pmm21=plot(vfrec_GHz, 20*log10(abs(vS21)), '-', 'Color',[0.9290 0.6940 0.1250], 'LineWidth', lw, 'DisplayName','|S_{21}|^2 calculaMM');
pmm11=plot(vfrec_GHz, 20*log10(abs(vS11)), '-', 'Color',[0.8500 0.3250 0.0980], 'LineWidth', lw, 'DisplayName','|S_{11}|^2 calculaMM');

% CST (usa f_cst_GHz directamente; NO vuelvas a tocar xlim/ylim)
pcst21=plot(f_cst_GHz, S21_cst_dB, '-', 'Color',[0 0.447 0.741], 'LineWidth', lw+0.5, 'DisplayName','|S_{21}|^2 CST');
pcst11=plot(f_cst_GHz, S11_cst_dB, '-', 'Color',[0.301 0.745 0.933], 'LineWidth', lw, 'DisplayName','|S_{11}|^2 CST');

% Concentrados
pcon21= plot(f_GHz, s21_dB_con, '--', 'Color',[0.466 0.674 0.188], 'LineWidth', lw, 'DisplayName','|S_{21}|^2 Concentrados');
pcon11=plot(f_GHz, s11_dB_con, '--', 'Color',[0.494 0.184 0.556], 'LineWidth', lw, 'DisplayName','|S_{11}|^2 Concentrados');

% Ejes y leyenda
xlabel('f (GHz)'); ylabel('dB');
title('|S_{21}|^2 y |S_{11}|^2 con máscaras — Comparativa N=3 vs N=4');
% ylim([-60 0]);
% xlim([f_GHz(1) f_GHz(end)]);
ylim([-0.5 0]);
xlim([9.7 10.3]);
legend([pmm21 pmm11 pcst21 pcst11 pcon21 pcon11], 'Location','NE');

%% ================== COMPARATIVA: CST (Ag/Al) vs Concentrados (Q=10000) ==================

% ---------- Entradas (edita rutas/nombres) ----------
file_ag = 'DiseñoBPF_plata.s2p';     % CST con metal plata
file_al = 'DiseñoBPF_alum.s2p';  % CST con metal aluminio

% ---------- Especificaciones / máscaras ----------
PB = [9.8e9 10.2e9];        % Passband en Hz
ILreq_dB = 0.1;             % máx pérdida en PB (S21)
RLreq_dB = 18;              % mín RL en PB   (S11)
SB = [ 8.00e9  9.25e9  40;  % [fini  fend  Aten_dB] (opcional; edítalo si no aplica)
       11.0e9 11.50e9  30;
       11.5e9 12.00e9  40 ];

% ---------- Leer CST: PLATA ----------
Sag = sparameters(file_ag);
f_ag_GHz = Sag.Frequencies(:)*1e-9;
P_ag      = Sag.Parameters;              % 2x2xN
S11_ag_dB = 20*log10(abs(squeeze(P_ag(1,1,:))));
S21_ag_dB = 20*log10(abs(squeeze(P_ag(2,1,:))));

% ---------- Leer CST: ALUMINIO ----------
Sal = sparameters(file_al);
f_al_GHz = Sal.Frequencies(:)*1e-9;
P_al      = Sal.Parameters;
S11_al_dB = 20*log10(abs(squeeze(P_al(1,1,:))));
S21_al_dB = 20*log10(abs(squeeze(P_al(2,1,:))));

% ---------- Concentrados desde WORKSPACE ----------
assert(exist('f_GHz','var')==1 && exist('s11_con','var')==1 && exist('s21_con','var')==1, ...
  ['Faltan variables de concentrados en workspace: f_GHz_con, S11_con, S21_con. ', ...
   'Debes crearlas antes de ejecutar.']);

f_con_GHz  = f_GHz(:);
S11_con_dB = 20*log10(abs(s11_con(:)));
S21_con_dB = 20*log10(abs(s21_con(:)));

% ---------- Parámetros de estilo ----------
lw = 1.8;

% ========================= FIGURA 1: 8–12 GHz, -60..0 dB =========================
fig1 = figure('Name','Global 8–12 GHz','Color','w'); hold on; grid on; box on;

% Máscaras en banda (se dibujan una sola vez)
ylim([-60 0]); yl = ylim; xlim([8 12]);
% PB (S21 >= -ILreq)
patch([PB(1) PB(2) PB(2) PB(1)]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.20, 'EdgeColor','none');
% PB (S11 <= -RLreq)
patch([PB(1) PB(2) PB(2) PB(1)]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.35, 'EdgeColor','none');
xline(PB/1e9,'k:');

% Stopbands (opcional)
for r = 1:size(SB,1)
    Areq_dB = -SB(r,3);
    plot([SB(r,1) SB(r,2)]/1e9, [Areq_dB Areq_dB], 'r-', 'LineWidth', 1.2);
    patch([SB(r,1) SB(r,2) SB(r,2) SB(r,1)]/1e9, [0 0 Areq_dB Areq_dB], [1.0 0.8 0.8], ...
          'FaceAlpha',0.20, 'EdgeColor','none');
end

% Curvas |S21| y |S11|
p_ag21 = plot(f_ag_GHz, S21_ag_dB, '-',  'Color',[0 0.447 0.741], 'LineWidth', lw+0.4, 'DisplayName','|S_{21}|^2 CST Plata');
p_ag11 = plot(f_ag_GHz, S11_ag_dB, '-',  'Color',[0.301 0.745 0.933], 'LineWidth', lw,     'DisplayName','|S_{11}|^2 CST Plata');

p_al21 = plot(f_al_GHz, S21_al_dB, '-',  'Color',[0.494 0.184 0.556], 'LineWidth', lw+0.4, 'DisplayName','|S_{21}|^2 CST Al');
p_al11 = plot(f_al_GHz, S11_al_dB, '-',  'Color',[0.635 0.078 0.184], 'LineWidth', lw,     'DisplayName','|S_{11}|^2 CST Al');

p_co21 = plot(f_con_GHz, S21_con_dB, '--','Color',[0.466 0.674 0.188], 'LineWidth', lw,     'DisplayName','|S_{21}|^2 Concentrados Q=10000');
p_co11 = plot(f_con_GHz, S11_con_dB, '--','Color',[0.850 0.325 0.098], 'LineWidth', lw,     'DisplayName','|S_{11}|^2 Concentrados Q=10000');

xlabel('f (GHz)'); ylabel('dB');
title('|S_{21}|^2 y |S_{11}|^2 — 8–12 GHz');
legend([p_ag21 p_ag11 p_al21 p_al11 p_co21 p_co11],'Location','SouthWest');

% ======================= FIGURA 2: ZOOM 9.7–10.3 GHz, -0.5..0 dB =======================
fig2 = figure('Name','Zoom 9.7–10.3 GHz','Color','w'); hold on; grid on; box on;

ylim([-0.5 0]); xlim([9.7 10.3]); yl = ylim;
% PB masks (idénticas)
patch([PB(1) PB(2) PB(2) PB(1)]/1e9, [0 0 -ILreq_dB -ILreq_dB], [0.8 1.0 0.8], ...
      'FaceAlpha',0.25, 'EdgeColor','none');                 % S21
patch([PB(1) PB(2) PB(2) PB(1)]/1e9, [-RLreq_dB -RLreq_dB yl(1) yl(1)], [0.85 0.9 1.0], ...
      'FaceAlpha',0.40, 'EdgeColor','none');                 % S11
xline(PB/1e9,'k:');

% Curvas de detalle
agz2=plot(f_ag_GHz, S21_ag_dB, '-',  'Color',[0 0.447 0.741], 'LineWidth', lw+0.6, 'DisplayName','|S_{21}|^2 CST Plata');
agz1=plot(f_ag_GHz, S11_ag_dB, '-',  'Color',[0.301 0.745 0.933], 'LineWidth', lw,    'DisplayName','|S_{11}|^2 CST Plata');

alz2=plot(f_al_GHz, S21_al_dB, '-',  'Color',[0.494 0.184 0.556], 'LineWidth', lw+0.6, 'DisplayName','|S_{21}|^2 CST Al');
alz1=plot(f_al_GHz, S11_al_dB, '-',  'Color',[0.635 0.078 0.184], 'LineWidth', lw,     'DisplayName','|S_{11}|^2 CST Al');

conz2=plot(f_con_GHz, S21_con_dB, '--','Color',[0.466 0.674 0.188], 'LineWidth', lw, 'DisplayName','|S_{21}|^2 Concentrados Q=10000');
conz1= plot(f_con_GHz, S11_con_dB, '--','Color',[0.850 0.325 0.098], 'LineWidth', lw, 'DisplayName','|S_{11}|^2 Concentrados Q=10000');

xlabel('f (GHz)'); ylabel('dB');
title('|S_{21}|^2 y |S_{11}|^2 — Zoom 9.7–10.3 GHz');
legend([agz2 agz1 alz2 alz1 conz2 conz1],'Location','SouthWest');


%% ---------- Función auxiliar para Q equivalente ----------
% Q_equiv := f0 / BW_3dB, midiendo BW entre puntos donde |S21| cae 3 dB
qfun = @(f_GHz, S21_dB) deal( ...
    findQ3dB(f_GHz(:), S21_dB(:)) ...
);

% ---------- Calcular Q para CST Plata y Aluminio (en la ventana 9.7–10.3 GHz) ----------
[f0_Ag, Q_Ag] = qfun(f_ag_GHz, S21_ag_dB);
[f0_Al, Q_Al] = qfun(f_al_GHz, S21_al_dB);

% ---------- Mostrar Q estimados en consola ----------
fprintf('Q-equivalente (método BW_{3dB} sobre |S21|):\n');
fprintf('  Plata   : f0 = %.6f GHz,  Q = %.1f\n', f0_Ag, Q_Ag);
fprintf('  Aluminio: f0 = %.6f GHz,  Q = %.1f\n', f0_Al, Q_Al);

% ====== Funciones locales ======
function [f0_GHz, Q] = findQ3dB(f_GHz, S21_dB)
    % Busca pico en S21 en [fmin fmax] (ya pasaste rango recortado arriba con xlim)
    % y calcula Q = f0 / BW_3dB con interpolación lineal a -3 dB desde el pico.
    % Robusto ante malla irregular.
    [pk_dB, idx0] = max(S21_dB);
    f0_GHz = f_GHz(idx0);
    lvl3 = pk_dB - 3;

    % Lado izquierdo (descender en frecuencia)
    iL = idx0; 
    while iL>1 && S21_dB(iL) > lvl3, iL = iL-1; end
    if iL==1
        fL = NaN;
    else
        fL = interp1(S21_dB([iL iL+1]), f_GHz([iL iL+1]), lvl3, 'linear','extrap');
    end

    % Lado derecho (subir en frecuencia)
    iR = idx0;
    N = numel(S21_dB);
    while iR<N && S21_dB(iR) > lvl3, iR = iR+1; end
    if iR==N
        fR = NaN;
    else
        fR = interp1(S21_dB([iR-1 iR]), f_GHz([iR-1 iR]), lvl3, 'linear','extrap');
    end

    if any(isnan([fL,fR])) || fR<=fL
        Q = NaN;  % fuera de rango útil
    else
        BW_GHz = (fR - fL);
        Q = f0_GHz / BW_GHz;
    end
end

