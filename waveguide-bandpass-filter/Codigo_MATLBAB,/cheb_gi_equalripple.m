function g = cheb_gi_equalripple(N_orden, Rp_dB)
% g_i del prototipo LP Chebyshev (equal-ripple) a partir del rizo en dB.
% Estilo y fórmulas como en tu “apartado de referencia”.
% Ladder empezando en SERIE (g1 = L, g2 = C, ...), Z0 = 1, wc = 1.
%
% ENTRADAS:
%   N_orden : orden del filtro (N)
%   Rp_dB   : rizado en transmisión (dB)  ← (alias de LAr_dB en tu código)
%
% SALIDA:
%   g : vector [g0, g1, ..., gN, gN+1]
%
    LAr_dB = Rp_dB;

    % --- g0 y preasignación  ---
    g0 = 1;                                % valor de fuente
    g  = zeros(1, N_orden + 1);            % g1..gN y gN+1 (carga)

    % --- Parámetros auxiliares ---
    beta           = log( coth(LAr_dB/17.37) );
    gamma_1permm   = sinh( beta/(2*N_orden) );
    m              = 1:N_orden;
    a              = sin( (2*m-1)*pi/(2*N_orden) );
    b              = gamma_1permm^2 + (sin(m*pi/N_orden)).^2;

    % --- Valores g de los elementos del filtro ---
    g(1) = 2*a(1)/gamma_1permm;            % g1
    for m = 2:N_orden
        g(m) = 4*a(m-1)*a(m) / ( b(m-1) * g(m-1) );
    end

    % --- Valor de la carga g_{N+1} ---
    if mod(N_orden,2) % impar
        g(N_orden+1) = 1;
    else              % par
        g(N_orden+1) = (coth(beta/4))^2;
    end

    % --- Anteponer g0 para devolver [g0..gN+1] ---
    g = [g0, g];
end
