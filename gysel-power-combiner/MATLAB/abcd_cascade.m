function Tout = abcd_cascade(varargin)
%ABCD_CASCADE  Cascada de varios 2x2xN (mismo N) por la izquierda->derecha.
%   Uso: Tout = abcd_cascade(T1,T2,T3,...)
Tout = varargin{1};
for k = 2:numel(varargin)
    A = Tout;  B = varargin{k};
    N = size(A,3);
    T = zeros(2,2,N);
    for n = 1:N
        T(:,:,n) = A(:,:,n) * B(:,:,n);
    end
    Tout = T;
end
end