function [S11,S21,tau_g] = ladder_HP_seriesC_shuntL(Cs, Lp, Z01, Z02, w)
% Ladder HP: primer elemento SHUNT (inductor), luego SERIE (condensador), alternando.
% Lp:   vector de inductancias shunt (longitud = ceil(N/2))
% Cs:   vector de capacidades serie  (longitud = floor(N/2))
% Z01, Z02: impedancias de referencia (Ohm)
% w:    vector de pulsaciones
    N = numel(Lp) + numel(Cs);
    S11 = zeros(size(w)); S21=S11; S22=S11; S12=S11; ph=S11;

    for ii=1:numel(w)
        omg = w(ii);  ABCD = eye(2);  ip=1; ic=1;
        for k=1:N
            if mod(k,2)==1      % SHUNT L primero
                Ys = 1./(1j*omg*Lp(ip)); ip = ip+1;
                ABCD = ABCD * [1 0; Ys 1];
            else                % SERIE C después
                Zs = 1./(1j*omg*Cs(ic)); ic = ic+1;
                ABCD = ABCD * [1 Zs; 0 1];
            end
        end
        A=ABCD(1,1); B=ABCD(1,2); C=ABCD(2,1); D=ABCD(2,2);

        % ABCD -> S con Z01 != Z02
        denom1 = A + B/Z02 + C*Z01 + D*(Z01/Z02);
        denom2 = D + B/Z01 + C*Z02 + A*(Z02/Z01);
        r12    = sqrt(Z01/Z02); r21 = 1/r12;

        S21(ii) = 2*r12 / denom1;
        S11(ii) = (A + B/Z02 - C*Z01 - D*(Z01/Z02)) / denom1;

        S22(ii) = (D + B/Z01 - C*Z02 - A*(Z02/Z01)) / denom2;
        S12(ii) = 2*r21 * (A*D - B*C) / denom2;

        ph(ii)  = angle(S21(ii));
    end
    tau_g = -gradient(unwrap(ph), w);   % s (derivada respecto a ω)
end