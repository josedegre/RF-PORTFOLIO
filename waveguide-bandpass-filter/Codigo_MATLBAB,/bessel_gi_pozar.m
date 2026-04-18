function g = bessel_gi_pozar(N)
% bessel_gi_pozar  Prot. LP Bessel (maximally-flat delay), g0..gN+1.
% Ladder empezando en SERIE, Z0=1, wc=1. Valores tabulados (N=1..10).
% Fuente: tablas docentes clásicas (coinciden con las usadas en manuales y cursos).
    switch N
        case 1,  g = [1, 2.0000, 1.0000];
        case 2,  g = [1, 1.5774, 0.4226, 1.0000];
        case 3,  g = [1, 1.2550, 0.5528, 0.1922, 1.0000];
        case 4,  g = [1, 1.0598, 0.5116, 0.3181, 0.1104, 1.0000];
        case 5,  g = [1, 0.9303, 0.4577, 0.3312, 0.2090, 0.0718, 1.0000];
        case 6,  g = [1, 0.8377, 0.4116, 0.3158, 0.2364, 0.1480, 0.0505, 1.0000];
        case 7,  g = [1, 0.7677, 0.3744, 0.2944, 0.2378, 0.1778, 0.1104, 0.0375, 1.0000];
        case 8,  g = [1, 0.7125, 0.3446, 0.2735, 0.2297, 0.1867, 0.1387, 0.0855, 0.0289, 1.0000];
        case 9,  g = [1, 0.6678, 0.3203, 0.2547, 0.2184, 0.1859, 0.1506, 0.1111, 0.0682, 0.0230, 1.0000];
        case 10, g = [1, 0.6305, 0.3002, 0.2384, 0.2066, 0.1808, 0.1539, 0.1240, 0.0911, 0.0557, 0.0187, 1.0000];
        otherwise
            error('N fuera de tabla (1..10).');
    end
end
