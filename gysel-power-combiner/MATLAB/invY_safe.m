function Z = invY_safe(Y)
    % 1/Y con tratamiento de 0, Inf y NaN
    Z = zeros(size(Y));
    finite_nonzero = isfinite(Y) & (Y ~= 0);
    Z(finite_nonzero) = 1 ./ Y(finite_nonzero);
    Z(Y == 0)   = Inf;   % 1/0 -> ∞ (admitancia nula => abierto)
    Z(isinf(Y)) = 0;     % 1/∞ -> 0  (admitancia infinita => corto)
    Z(isnan(Y)) = NaN;   % NaN se conserva
end