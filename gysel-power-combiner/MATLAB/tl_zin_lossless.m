function Zin = tl_zin_lossless(Z0, ZL, theta)
%TL_ZIN_LOSSLESS  Zin de una línea lossless con carga arbitraria.
%   Zin = TL_ZIN_LOSSLESS(Z0, ZL, THETA) calcula
%       Zin = Z0 * (ZL + j*Z0*tan(THETA)) / (Z0 + j*ZL*tan(THETA))
%   con manejo estable para ZL = Inf (usa la forma -j*Z0*cot(THETA))
%   y para ZL = 0 (usa j*Z0*tan(THETA)).
%
%   ENTRADAS:
%     Z0    : escalar (ohm)
%     ZL    : escalar o array compatible (ohm)
%     THETA : escalar o array compatible (radianes, = beta*ell)
%
%   SALIDA:
%     Zin   : del tamaño compatible de ZL y THETA (ohm)
%
%   EJEMPLOS:
%     Z0=50; th=linspace(0,2*pi,1001);
%     Zin1 = tl_zin_lossless(Z0, 30+1i*20, th);
%     Zin2 = tl_zin_lossless(Z0, Inf, th);   % abierto
%     Zin3 = tl_zin_lossless(Z0, 0, th);     % corto
%
%   Nota: requiere MATLAB con expansión implícita (R2016b+).

j = 1i;

% Máscaras de casos especiales
mask_open  = isinf(ZL);
mask_short = (ZL==0);

% Inicializa salida con tamaño compatible
Zin = zeros(size(theta)+size(ZL)-1);
% Para compatibilidad con tamaños, usamos operaciones directas
t = tan(theta);

% Abierto: Zin = -j*Z0*cot(theta)
Zin_open  = -j*Z0 .* (1 ./ t);

% Corto:   Zin =  j*Z0*tan(theta)
Zin_short =  j*Z0 .* t;

% General
num = ZL + j*Z0.*t;
den = Z0 + j*ZL.*t;
Zin_gen = Z0 .* (num ./ den);

% Ensambla según máscaras (soporta arrays)
Zin = Zin_gen;
if ~isscalar(ZL)
    Zin(mask_open)  = Zin_open(mask_open);
    Zin(mask_short) = Zin_short(mask_short);
else
    if mask_open,  Zin = Zin_open;  end
    if mask_short, Zin = Zin_short; end
end
end