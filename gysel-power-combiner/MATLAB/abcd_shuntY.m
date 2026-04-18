function T = abcd_shuntY(Y)
% ABCD de una admitancia shunt Y (Y puede ser escalar o vector 1xN).
% Devuelve T de tamaño 2x2xN.
Y = reshape(Y,1,1,[]);         % -> 1x1xN
N = size(Y,3);
T = zeros(2,2,N);
T(1,1,:) = 1;
T(2,2,:) = 1;
T(2,1,:) = Y;                  % asignación por la 3ª dim
end
