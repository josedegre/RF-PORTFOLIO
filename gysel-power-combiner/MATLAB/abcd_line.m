function T = abcd_line(Zc, theta)
%ABCD_LINE  Matriz ABCD de una linea lossless (Zc, theta).
%   Zc: escalar, theta: escalar o vector. Devuelve 2x2xN.
ct = cos(theta); st = sin(theta);
T = zeros(2,2,numel(theta));
T(1,1,:) = ct;
T(1,2,:) = 1j*Zc.*st;
T(2,1,:) = 1j*st./Zc;
T(2,2,:) = ct;
end