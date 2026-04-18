function [S11,S21,S22,S12,tau_g] = ladder_BP_from_sections( ...
        Ls_series, Cs_series, Lp_shunt, Cp_shunt, Z01, Z02, w)
% Primer elemento: SHUNT (resonador paralelo), luego SERIE, alternando.
    nS = numel(Ls_series); 
    nP = numel(Lp_shunt); 
    N  = nS + nP;

    S11 = zeros(size(w)); S21 = S11; S22 = S11; S12 = S11; ph = S11;

    for ii = 1:numel(w)
        omg = w(ii); ABCD = eye(2); is = 1; ip = 1;

        for k = 1:N
            if mod(k,2)==1
                % SHUNT (paralelo): Yp = 1/(jωLp) + jωCp
                Yp = 1./(1j*omg*Lp_shunt(ip)) + 1j*omg*Cp_shunt(ip);
                ip = ip + 1;
                ABCD = ABCD * [1 0; Yp 1];
            else
                % SERIE (serie): Zs = jωLs + 1/(jωCs)
                Zs = 1j*omg*Ls_series(is) + 1./(1j*omg*Cs_series(is));
                is = is + 1;
                ABCD = ABCD * [1 Zs; 0 1];
            end
        end

        A = ABCD(1,1); B = ABCD(1,2); C = ABCD(2,1); D = ABCD(2,2);

        denom1 = A + B/Z02 + C*Z01 + D*(Z01/Z02);
        denom2 = D + B/Z01 + C*Z02 + A*(Z02/Z01);
        r12    = sqrt(Z01/Z02); r21 = 1/r12;

        S21(ii)= 2*r12 / denom1;
        S11(ii)= (A + B/Z02 - C*Z01 - D*(Z01/Z02)) / denom1;

        S22(ii)= (D + B/Z01 - C*Z02 - A*(Z02/Z01)) / denom2;
        S12(ii)= 2*r21*(A*D - B*C) / denom2;

        ph(ii) = angle(S21(ii));
    end
    tau_g = -gradient(unwrap(ph), w);   % s (derivada respecto a ω)
end
