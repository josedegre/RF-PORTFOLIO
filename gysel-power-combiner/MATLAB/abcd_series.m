function T = abcd_series(Z)
% ABCD de una impedancia serie Z (escalar o vector 1xN).
Z = reshape(Z,1,1,[]);
N = size(Z,3);
T = zeros(2,2,N);
T(1,1,:) = 1;
T(2,2,:) = 1;
T(1,2,:) = Z;
end
