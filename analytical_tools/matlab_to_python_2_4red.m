% Directorio del análisis de multiplets
DIR_MULT_ANALYSIS = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\MULTIPLET_ANALYSIS\REDUNDANCIES\';

% Directorio de salida
DIR_OUT = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\MultipletAnalysisPython\';

% Lista de estados y sus totales correspondientes
estados = {
    'Sleeping', 851;
    'Anes', 116;  % Rellenar con el valor correcto
    'AwakeC', 197;  % Rellenar con el valor correcto
    'AwakeD', 192;  % Rellenar con el valor correcto
    'AnesProp', 106
};

for i = 1:size(estados, 1)
    state = estados{i, 1};
    total = estados{i, 2};
    
    if total == 0
        continue;  % Saltar estados que no tienen total definido
    end

    % Nombre del archivo de análisis de multiplets
    mult_analysis_name = fullfile(DIR_MULT_ANALYSIS, [state, '_comb_4_regiones_red.mat']);

    % Cargar los datos del archivo
    data_analysis = load(mult_analysis_name);
    data_analysis = data_analysis.resultsSorted;

    % Calcular umbral del 90%
    umbral = ceil(0.9 * total);

    % Encontrar las combinaciones que aparecen en el 90% de los segmentos
    idx_90 = find([data_analysis.frecuencia] >= umbral);
    comb_90 = {data_analysis(idx_90).combinacion};

    % Nombre del archivo de salida
    nombre = [state, '_comb_4_regiones_90_red.mat'];
    dir_nombre = fullfile(DIR_OUT, nombre);

    % Guardar los resultados
    save(dir_nombre, 'comb_90');
end
