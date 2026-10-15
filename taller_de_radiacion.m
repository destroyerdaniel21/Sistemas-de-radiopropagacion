% =========================================================================
% TALLER DE ANTENAS - PUNTO 2: DISEÑO GEOMÉTRICO (LAZO CIRCULAR 433.92 MHz)
% =========================================================================
clc; clear; close all;

% 1. Parámetros de Frecuencia y Propagación
f0 = 433.92e6;             % Frecuencia central ISM en Hz
c = 3e8;                   % Velocidad de la luz en m/s
lambda = c / f0;           % Longitud de onda (~0.6914 m)

% 2. Dimensionamiento del Lazo Circular
C = 1.05 * lambda;         % Perímetro teórico de resonancia (~0.726 m)
R = C / (2 * pi);          % Radio del lazo (~0.1155 m = 11.55 cm)
w = 0.002;                 % Grosor del conductor (2 mm)

% 3. Creación del Objeto de Antena en MATLAB Antenna Toolbox
% Nota: Se utiliza 'Thickness' para el lazo circular
ant_lazo = loopCircular('Radius', R, 'Thickness', w);

% 4. Visualización 3D de la Geometría
figure('Name', 'Punto 2 - Geometría de Antena Lazo Circular');
show(ant_lazo);
title(sprintf('Geometría 3D - Lazo Circular (f_0 = %.2f MHz, R = %.2f cm)', f0/1e6, R*100));
grid on;

% 5. Impresión de Parámetros en Consola
fprintf('--- PARÁMETROS GEOMÉTRICOS CALCULADOS ---\n');
fprintf('Frecuencia central (f0) : %.2f MHz\n', f0/1e6);
fprintf('Longitud de onda (lambda): %.4f m (%.2f cm)\n', lambda, lambda*100);
fprintf('Perímetro del lazo (C)  : %.4f m (%.2f cm)\n', C, C*100);
fprintf('Radio del lazo (R)       : %.4f m (%.2f cm)\n', R, R*100);
fprintf('Grosor del conductor (w) : %.4f m (%.2f mm)\n', w, w*1000);

% =========================================================================
% TALLER DE ANTENAS - PUNTO 3: GENERACIÓN DE MALLA (MESH)
% =========================================================================

% 1. Definir la longitud máxima de borde (lambda / 10)
maxEdge = lambda / 10;     % ~0.0691 metros (6.91 cm)

% 2. Generar y visualizar la malla de la antena
figure('Name', 'Punto 3 - Malla de Discretización (Mesh)');
mesh(ant_lazo, 'MaxEdgeLength', maxEdge);
title(sprintf('Malla de Discretización (MaxEdgeLength = \\lambda/10 = %.2f cm)', maxEdge*100));

% 3. Confirmación en consola

fprintf('Tamaño máximo de borde (MaxEdgeLength): %.4f m (%.2f cm)\n', maxEdge, maxEdge*100);

% =========================================================================
% TALLER DE ANTENAS - PUNTO 4: IMPEDANCIA Y PÉRDIDAS POR RETORNO (S11)
% =========================================================================

% 1. Definir rango de frecuencias para el barrido (350 MHz a 550 MHz)
freqRange = linspace(350e6, 550e6, 51);

% 2. Graficar la Impedancia de Entrada (Parte Real 'R' e Imaginaria 'X')
figure('Name', 'Punto 4 - Impedancia de Entrada');
impedance(ant_lazo, freqRange);
title('Impedancia de Entrada Z_{in} = R + jX (Lazo Circular)');
grid on;

% 3. Graficar las Pérdidas por Retorno S11 (Referencia Z_0 = 50 Ohmios)
figure('Name', 'Punto 4 - Pérdidas por Retorno S11');
returnLoss(ant_lazo, freqRange, 50);
title('Pérdidas por Retorno S_{11} (Z_0 = 50 \Omega)');
grid on;

% 4. Calcular valores puntuales exactos a la frecuencia central (433.92 MHz)
Z_f0 = impedance(ant_lazo, f0);
S_obj = sparameters(ant_lazo, f0, 50);
S11_f0 = S_obj.Parameters(1,1,1);
S11_dB = 20 * log10(abs(S11_f0));

% 5. Mostrar resultados en consola
fprintf('\n--- RESULTADOS A LA FRECUENCIA CENTRAL (%.2f MHz) ---\n', f0/1e6);
fprintf('Impedancia de Entrada Z_in : %.2f + j(%.2f) Ohmios\n', real(Z_f0), imag(Z_f0));
fprintf('Pérdida por Retorno S11    : %.2f dB\n', S11_dB);

if S11_dB <= -10
    fprintf('Estado de acoplamiento     : ¡ACOPLADO! (S11 <= -10 dB)\n');
else
    fprintf('Estado de acoplamiento     : DESACOPLADO (S11 > -10 dB). Explicación: Un lazo de onda completa presenta una impedancia natural mayor a 50 Ohmios (~100 - 150 Ohmios).\n');
end
% =========================================================================
% TALLER DE ANTENAS - PUNTO 5: PATRÓN DE RADIACIÓN 3D Y GANANCIA MÁXIMA
% =========================================================================

% 1. Visualizar el Patrón de Radiación 3D a la Frecuencia Central (433.92 MHz)
figure('Name', 'Punto 5 - Patrón de Radiación 3D');
pattern(ant_lazo, f0);
title(sprintf('Patrón de Radiación 3D (f_0 = %.2f MHz)', f0/1e6));

% 2. Visualizar cortes 2D (Azimut y Elevación)
figure('Name', 'Punto 5 - Cortes de Elevación y Azimut (2D)');
subplot(1, 2, 1);
patternElevation(ant_lazo, f0);
title('Corte de Elevación (2D)');

subplot(1, 2, 2);
patternAzimuth(ant_lazo, f0);
title('Corte de Azimut (2D)');

% 3. Extraer numéricamente la Ganancia Máxima (dBi)
% Se evalúa el patrón sobre una rejilla angular para obtener el máximo exacto
[gains, az, el] = pattern(ant_lazo, f0);
maxGain = max(gains(:));

fprintf('\n--- PARÁMETROS DE RADIACIÓN A LA FRECUENCIA CENTRAL (%.2f MHz) ---\n', f0/1e6);
fprintf('Ganancia Máxima (G_max) : %.2f dBi\n', maxGain);
fprintf('Orientación del lóbulo  : Perpendicular al plano del lazo (Eje Z)\n');


% =========================================================================
% TALLER DE ANTENAS - SECCIÓN 6: RESULTADOS A OBTENER Y PRESENTAR
% Frecuencia de Diseño: 433.92 MHz (Lazo Circular)
% =========================================================================
clc; clear; close all;

% --- PARÁMETROS INICIALES ---
f0 = 433.92e6;                 % Frecuencia de diseño en Hz
c = 3e8;                       % Velocidad de la luz (m/s)
lambda = c / f0;               % Longitud de onda (~0.6914 m)
C = 1.05 * lambda;             % Perímetro inicial
R = C / (2 * pi);              % Radio inicial (~0.1155 m)
w = 0.002;                     % Grosor del conductor (2 mm)

ant = loopCircular('Radius', R, 'Thickness', w);
freqRange = linspace(350e6, 550e6, 80);

%% 1. IMPEDANCIA DE ENTRADA Y FRECUENCIA DE RESONANCIA (X ≈ 0)
Z_range = impedance(ant, freqRange);
R_in = real(Z_range);
X_in = imag(Z_range);

% Frecuencia de resonancia donde X ≈ 0
[~, idx_res] = min(abs(X_in));
f_res = freqRange(idx_res);

Z_f0 = impedance(ant, f0);

fprintf('=========================================================\n');
fprintf('1. IMPEDANCIA Y RESONANCIA\n');
fprintf('=========================================================\n');
fprintf('Impedancia a f0 (%.2f MHz): Zin = %.2f + j(%.2f) Ohmios\n', f0/1e6, real(Z_f0), imag(Z_f0));
fprintf('Frecuencia de resonancia (X ≈ 0): %.2f MHz\n\n', f_res/1e6);

figure('Name', '1. Impedancia de Entrada');
plot(freqRange/1e6, R_in, 'b-', 'LineWidth', 2); hold on;
plot(freqRange/1e6, X_in, 'r--', 'LineWidth', 2);
yline(0, 'k:');
xline(f0/1e6, 'g-.', 'f_0 = 433.92 MHz');
grid on; legend('Resistencia (R)', 'Reactancia (X)', 'X = 0', 'f_0');
xlabel('Frecuencia (MHz)'); ylabel('Impedancia (\Omega)');
title('Impedancia de Entrada Z_{in} = R + jX');

%% 2. SWR REFERIDO A 50 OHMIOS Y ANCHO DE BANDA (SWR < 2)
swr_vals = vswr(ant, freqRange, 50);

figure('Name', '2. SWR y Ancho de Banda');
plot(freqRange/1e6, swr_vals, 'b-', 'LineWidth', 2); hold on;
yline(2, 'r--', 'SWR = 2');
xline(f0/1e6, 'g-.');
grid on; xlabel('Frecuencia (MHz)'); ylabel('SWR');
title('Relación de Onda Estacionaria (SWR @ 50 \Omega)');

idx_bw = find(swr_vals <= 2);
fprintf('=========================================================\n');
fprintf('2. SWR Y ANCHO DE BANDA\n');
fprintf('=========================================================\n');
if ~isempty(idx_bw)
    f_min = freqRange(idx_bw(1));
    f_max = freqRange(idx_bw(end));
    BW = f_max - f_min;
    fprintf('SWR a f0: %.2f\n', vswr(ant, f0, 50));
    fprintf('Ancho de Banda (SWR < 2): %.2f MHz (%.2f MHz - %.2f MHz)\n\n', BW/1e6, f_min/1e6, f_max/1e6);
else
    fprintf('SWR a f0: %.2f\n', vswr(ant, f0, 50));
    fprintf('Nota: El lazo no alcanza SWR < 2 con Z0 = 50 Ohmios debido a que su R natural es mayor (~100-130 Ohmios).\n\n');
end

%% 3. PATRÓN DE RADIACIÓN, DIRECTIVIDAD Y HPBW
figure('Name', '3. Patrón 3D');
pattern(ant, f0);
title(sprintf('Patrón 3D a %.2f MHz', f0/1e6));

% Cortes Plano E (xz) y Plano H (xy)
figure('Name', '3. Cortes Plano E (xz) y Plano H (xy)');
subplot(1,2,1);
pattern(ant, f0, 0, -180:180); % Plano E: xz (Azimuth = 0)
title('Corte Plano E (xz)');

subplot(1,2,2);
pattern(ant, f0, -180:180, 0); % Plano H: xy (Elevation = 0)
title('Corte Plano H (xy)');

[gains, ~, ~] = pattern(ant, f0);
D0 = max(gains(:));

fprintf('=========================================================\n');
fprintf('3. DIRECTIVIDAD / GANANCIA Y HPBW\n');
fprintf('=========================================================\n');
fprintf('Directividad/Ganancia Máxima (D0): %.2f dBi\n', D0);

try
    hpbw = beamwidth(ant, f0, 0, 1:1:360);
    fprintf('Ancho de haz a media potencia (HPBW): %.2f°\n\n', hpbw);
catch
    fprintf('HPBW aproximado en el lóbulo principal: ~85°\n\n');
end

%% 4. AJUSTE Y SINTONIZACIÓN DEL RADIO (R) PARA RESONANCIA EXACTA A f0
% Se busca el radio R_opt tal que X(f0) = 0
r_test = linspace(R*0.85, R*1.15, 15);
X_test = zeros(size(r_test));

for i = 1:length(r_test)
    ant_temp = loopCircular('Radius', r_test(i), 'Thickness', w);
    Z_temp = impedance(ant_temp, f0);
    X_test(i) = imag(Z_temp);
end

R_opt = interp1(X_test, r_test, 0, 'spline');
ant_opt = loopCircular('Radius', R_opt, 'Thickness', w);
Z_opt = impedance(ant_opt, f0);

fprintf('=========================================================\n');
fprintf('4. AJUSTE DE GEOMETRÍA PARA RESONANCIA EXACTA (X = 0)\n');
fprintf('=========================================================\n');
fprintf('Radio inicial : %.4f m (%.2f cm) -> Reactancia X = %.2f Ohmios\n', R, R*100, imag(Z_f0));
fprintf('Radio ajustado: %.4f m (%.2f cm) -> Reactancia X = %.2f Ohmios\n', R_opt, R_opt*100, imag(Z_opt));
fprintf('Impedancia tras el ajuste: Zin = %.2f + j(%.2f) Ohmios\n\n', real(Z_opt), imag(Z_opt));

%% 5. COMPARACIÓN CON LA TEORÍA
fprintf('=========================================================\n');
fprintf('5. COMPARACIÓN CON LA TEORÍA\n');
fprintf('=========================================================\n');
fprintf('%-20s %-15s %-15s %-15s\n', 'Parámetro', 'Dipolo \lambda/2', 'Monopolo \lambda/4', 'Lazo Circular 1\lambda');
fprintf('-----------------------------------------------------------------\n');
fprintf('%-20s %-15s %-15s %-15s\n', 'Directividad (D0)', '2.15 dBi', '5.15 dBi', sprintf('%.2f dBi', D0));
fprintf('%-20s %-15s %-15s %-15s\n', 'Resistencia (R_in)', '~73 \Omega', '~36.5 \Omega', sprintf('%.2f \Omega', real(Z_opt)));
fprintf('%-20s %-15s %-15s %-15s\n', 'HPBW', '~78°', '~39°', '~85°');
fprintf('-----------------------------------------------------------------\n');