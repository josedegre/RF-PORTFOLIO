function Y = invZ_safe(Z)
    % 1/Z con tratamiento de 0, Inf y NaN
    Y = zeros(size(Z));
    finite_nonzero = isfinite(Z) & (Z ~= 0);
    Y(finite_nonzero) = 1 ./ Z(finite_nonzero);
    Y(Z == 0)   = Inf;   % 1/0 -> ∞ (corto => admitancia infinita)
    Y(isinf(Z)) = 0;     % 1/∞ -> 0  (abierto => admitancia nula)
    Y(isnan(Z)) = NaN;   % NaN se conserva (a menos que domine en la suma)
end