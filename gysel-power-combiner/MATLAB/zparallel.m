function Zp = zparallel(Z1, Z2)
%ZPARALLEL  Paralelo de dos impedancias con tratamiento de 0 e Inf.
%   Zp = ZPARALLEL(Z1, Z2) devuelve la impedancia equivalente del paralelo
%   de Z1 y Z2. Soporta escalares o arrays del mismo tamaño (o compatibles
%   por expansión implícita). Maneja correctamente:
%     - Z = 0      (cortocircuito)  -> domina: paralelo = 0
%     - Z = Inf    (circuito abierto)-> paralelo = la otra impedancia
%     - Z = Inf // Inf               -> Inf
%     - Z = 0   // Inf               -> 0
%   Mantiene NaN solo cuando no hay un caso dominante físico.
%
%   Ejemplos:
%     zparallel(50, 50)         % 25
%     zparallel(0, 100)         % 0
%     zparallel(Inf, 100)       % 100
%     zparallel(Inf, Inf)       % Inf
%     zparallel(0, Inf)         % 0
%     f = linspace(1,10,5); Z1 = 50+1j*2*pi*f; Z2 = Inf;
%     Zp = zparallel(Z1, Z2);   % devuelve Z1 (vectorizado)
%
%   Autor: CAFR Pro

    % Convertimos a admitancias de forma segura (evita 0/0 y NaN innecesarios)
    Y1 = invZ_safe(Z1);   % 1/Z1 con convenciones: 1/0 = Inf, 1/Inf = 0
    Y2 = invZ_safe(Z2);

    Yp = Y1 + Y2;         % paralelo en admitancia
    Zp = invY_safe(Yp);   % vuelve a impedancia: Z = 1/Y con 1/0 = Inf, 1/Inf = 0
end