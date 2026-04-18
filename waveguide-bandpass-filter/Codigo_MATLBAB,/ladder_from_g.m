function [S11, S21, tau_g] = ladder_from_g(g, Omega,Z01,Z02)
    % Prototipo LP normalizado (Zref=1, wc=1), ladder EMPIEZA EN SHUNT.
% k impar -> shunt C = g_k ;  k par -> serie L = g_k
% Z01, Z02: impedancias de referencia de los puertos (Ohm).
%
% Devuelve S11,S21,S22,S12 y retardo de grupo tau_g (normalizado a 1/wc).

    arguments
        g (1,:) double
        Omega (1,:) double
        Z01 (1,1) double {mustBePositive} = 1
        Z02 (1,1) double {mustBePositive} = 1
    end

    N = length(g) - 2;             % nº de elementos reactivos
    S11 = zeros(size(Omega)); 
    S21 = S11; S22 = S11; S12 = S11; 
    ph  = S11;

    for i = 1:numel(Omega)
        Om = Omega(i);
        ABCD = eye(2);

        for k = 1:N
            gk = g(k+1);
            if mod(k,2)==1
                % k impar: shunt C_lp = gk  -> Ys = j*Ω*C = j*Ω*gk
                Ys = 1j*Om*gk;
                ABCD = ABCD * [1 0; Ys 1];
            else
                % k par: serie L_lp = gk   -> Zs = j*Ω*L = j*Ω*gk
                Zs = 1j*Om*gk;
                ABCD = ABCD * [1 Zs; 0 1];
            end
        end

        A = ABCD(1,1); B = ABCD(1,2); C = ABCD(2,1); D = ABCD(2,2);

        % Conversión ABCD -> S con Z01 != Z02
        denom1  = A + B/Z02 + C*Z01 + D*(Z01/Z02);
        denom2  = D + B/Z01 + C*Z02 + A*(Z02/Z01);
        root12  = sqrt(Z01/Z02); 
        root21  = 1/root12;

        S21(i) = 2*root12 / denom1;
        S11(i) = (A + B/Z02 - C*Z01 - D*(Z01/Z02)) / denom1;

        S22(i) = (D + B/Z01 - C*Z02 - A*(Z02/Z01)) / denom2;
        S12(i) = 2*root21 * (A*D - B*C) / denom2;

        ph(i)  = angle(S21(i));
    end

    tau_g = -gradient(unwrap(ph), Omega);  % (1/ωc) si Ω = ω/ωc
end
