clear,clc;
touch_filename = 'gysel_ads.s10p'; % <-- ajusta ruta si hace falta

%% ------------------------------------------------------------------------
% 1) Carga del Touchstone
% -------------------------------------------------------------------------
hasRF = (exist('sparameters','file')==2);
if hasRF
    Sobj = sparameters(touch_filename);     % RF Toolbox
    f     = Sobj.Frequencies(:);            % Hz
    Sfull = Sobj.Parameters;                % [N N K], N=10
else
    [f,Sfull] = read_snp_basic(touch_filename);  % fallback
end

[N,~,K] = size(Sfull);
assert(N==10, 'Se esperaba un archivo .s10p (N=10).');

% Subconjuntos según tu mapeo
idxG = 1:5;      % Gysel completo
idxE = 6:8;      % Se (even)
idxO = 9:10;     % So (odd)

Sg = Sfull(idxG, idxG, :);         % 5x5xK
Se = Sfull(idxE, idxE, :);         % 3x3xK
So = Sfull(idxO, idxO, :);         % 2x2xK

%% ------------------------------------------------------------------------
% 2) Métricas típicas del Gysel (ejemplo para puerto 1 como puerto de entrada)
% -------------------------------------------------------------------------
% Ajusta estos índices según tu topología (p.ej., 1 = input, 2-3 = salidas, 4-5 = resistivos)
pin   = 1;          % puerto de entrada
pout1 = 2;          % primer puerto de salida
pout2 = 3;          % segundo puerto de salida

S11 = squeeze(Sg(pin,pin,:));          % Return Loss
S21 = squeeze(Sg(pout1,pin,:));        % Hacia out1
S31 = squeeze(Sg(pout2,pin,:));        % Hacia out2
iso = squeeze(Sg(pout2,pout1,:));      % Aislamiento entre salidas (S32)

RL_dB   = -20*log10(abs(S11));         % Return Loss (dB)
IL1_dB  = -20*log10(abs(S21));         % Insertion "loss" a out1 (dB)
IL2_dB  = -20*log10(abs(S31));         % Insertion "loss" a out2 (dB)
ISO_dB  = -20*log10(abs(iso));         % Aislamiento (dB)

% Balance de potencia (idealmente |S21| ≈ |S31| para combinador/divisor 3 dB)
bal_dB = 20*log10(abs(S21)./max(abs(S31),eps));

%% ------------------------------------------------------------------------
% 3) Gráficas
% -------------------------------------------------------------------------
freq_GHz = f/1e9;

% --- Gysel (1-5): curvas típicas ---
figure('Name','Gysel (puertos 1–5) - Magnitud (dB)','Color','w');
tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
nexttile; plot(freq_GHz, RL_dB,'LineWidth',1.2); grid on;
xlabel('f (GHz)'); ylabel('RL (dB)'); title('|S_{11}| (Return Loss)');
nexttile; plot(freq_GHz, -IL1_dB,'LineWidth',1.2); grid on;
xlabel('f (GHz)'); ylabel('Gain (dB)'); title('|S_{21}| (→ out1)');
nexttile; plot(freq_GHz, -IL2_dB,'LineWidth',1.2); grid on;
xlabel('f (GHz)'); ylabel('Gain (dB)'); title('|S_{31}| (→ out2)');
nexttile; plot(freq_GHz, ISO_dB,'LineWidth',1.2); grid on;
xlabel('f (GHz)'); ylabel('Isolation (dB)'); title('Aislamiento entre salidas |S_{32}|');

% Fase de S21/S31 (útil para ver cuadratura/igualdad de fase)
figure('Name','Gysel (puertos 1–5) - Fase','Color','w');
plot(freq_GHz, unwrap(angle(S21))*180/pi, 'LineWidth',1.2); hold on;
plot(freq_GHz, unwrap(angle(S31))*180/pi, 'LineWidth',1.2);
grid on; xlabel('f (GHz)'); ylabel('Fase (°)');
legend('∠S_{21}','∠S_{31}','Location','best'); title('Fase hacia salidas');

% Balance de potencia
figure('Name','Gysel - Balance entre salidas','Color','w');
plot(freq_GHz, bal_dB,'LineWidth',1.2); grid on;
xlabel('f (GHz)'); ylabel('Δ|S| (dB)'); 
title('Desbalance |S_{21}| - |S_{31}| (dB, ideal≈0)');

% --- Mapas de calor para Se (6–8) y So (9–10) ---
plot_smatrix_heatmap(freq_GHz, Se, 'Se (puertos 6–8)');
plot_smatrix_heatmap(freq_GHz, So, 'So (puertos 9–10)');

% --- (Opcional) Smith de S11 del Gysel ---
if hasRF
    figure('Name','Smith | S_{11} del Gysel |','Color','w');
    smithplot(S11); title('S_{11} (puerto de entrada del Gysel)');
end

%% ------------------------------------------------------------------------
% 4) Resumen rápido en consola (valores al f0 ~ pico de |S21|)
% -------------------------------------------------------------------------
[~,kpk] = max(abs(S21));
f0 = f(kpk)/1e9;

fprintf('\n--- Resumen a f0 = %.4f GHz ---\n', f0);
fprintf('RL (S11)      : %.1f dB\n', RL_dB(kpk));
fprintf('Gain to out1  : %.2f dB (|S21|)\n', -IL1_dB(kpk));
fprintf('Gain to out2  : %.2f dB (|S31|)\n', -IL2_dB(kpk));
fprintf('Isolation     : %.1f dB (|S32|)\n', ISO_dB(kpk));
fprintf('Balance (dB)  : %.2f dB (|S21|-|S31|)\n', bal_dB(kpk));

% ================= Helper: heatmap de |S| =================
function plot_smatrix_heatmap(freq_GHz, Ssub, titleStr)
[n,~,K] = size(Ssub);
mag_dB = zeros(n*n, K);
labels  = strings(n*n,1);
idx=1;
for i=1:n
    for j=1:n
        mag_dB(idx,:) = 20*log10( squeeze( abs(Ssub(i,j,:)) ) + eps );
        labels(idx) = sprintf('S_{%d%d}', i, j);
        idx = idx+1;
    end
end
figure('Name',[titleStr ' - |S| dB (heatmap)'],'Color','w');
imagesc(freq_GHz, 1:(n*n), mag_dB); axis xy; colorbar;
xlabel('f (GHz)'); ylabel('Elemento S_{ij}');
yticks(1:(n*n)); yticklabels(labels);
title([titleStr '  |S_{ij}| (dB)']);
end

% ================= Helper: parser Touchstone simple =================
function [f,S] = read_snp_basic(fname)
% Parser mínimo para .sNp (formato RI/MA/DB soportado, R 50Ω)
fid = fopen(fname,'r'); assert(fid>0, 'No se puede abrir %s', fname);
cleanup = onCleanup(@() fclose(fid));

fmt = 'MA'; Rref = 50; N = [];  % valores por defecto
% lee cabecera
while true
    t = fgetl(fid);
    if ~ischar(t), error('Archivo vacío/incorrecto'); end
    t = strtrim(t);
    if isempty(t) || startsWith(t,'!'), continue; end
    if startsWith(lower(t),'#')
        % ejemplo: # GHZ S MA R 50
        toks = split(strtrim(t));
        % busca formato, Rref y N
        if any(strcmpi(toks,'MA')), fmt='MA'; end
        if any(strcmpi(toks,'DB')), fmt='DB'; end
        if any(strcmpi(toks,'RI')), fmt='RI'; end
        ir = find(strcmpi(toks,'R'),1);
        if ~isempty(ir) && numel(toks)>ir, Rref = str2double(toks{ir+1}); end %#ok<NASGU>
        % N viene del sufijo del archivo .sNp
        [~,name,ext] = fileparts(fname);
        ext = lower(ext);
        if startsWith(ext,'.s'), N = str2double(ext(3:end)); end
        break;
    end
end
assert(~isempty(N) && ~isnan(N),'No se pudo inferir N de la extensión .sNp');

% carga numérica
dat = [];
while true
    t = fgetl(fid);
    if ~ischar(t), break; end
    t = strtrim(t);
    if isempty(t) || startsWith(t,'!'), continue; end
    nums = sscanf(t,'%f').';
    if isempty(nums), continue; end
    dat = [dat; nums]; %#ok<AGROW>
end
% Cada fila: f seguido de pares (a,b) por cada Sij en orden fila rápida i=1..N, j=1..N
pairsPerRow = N*N;
valsPerRow  = 1 + 2*pairsPerRow;
assert(mod(size(dat,2),valsPerRow)==0 || size(dat,2)==valsPerRow, ...
    'Formato de columnas inesperado.');
% Asegura columnas = valsPerRow
if size(dat,2) > valsPerRow
    dat = dat(:,1:valsPerRow);
elseif size(dat,2) < valsPerRow
    error('Fila Touchstone incompleta.');
end

f = dat(:,1);               % frecuencia (asume unidades como en cabecera, típicamente Hz/GHz)
% Heurística rápida: si max(f)<1e6, probablemente viene en GHz -> convertir a Hz
if max(f) < 1e6, f = f*1e9; end

S = zeros(N,N,size(dat,1));
for k=1:size(dat,1)
    xy = dat(k,2:end);
    comp = zeros(N,N);
    idx=1;
    for i=1:N
        for j=1:N
            a = xy(2*idx-1); b = xy(2*idx); idx=idx+1;
            switch upper(fmt)
                case 'MA', comp(i,j) = a * exp(1j*deg2rad(b)); % mag, ang°
                case 'DB', comp(i,j) = 10^(a/20) * exp(1j*deg2rad(b)); % dB, ang°
                case 'RI', comp(i,j) = a + 1j*b; % real, imag
            end
        end
    end
    S(:,:,k) = comp;
end
end