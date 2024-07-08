% Directorio del análisis de multiplets
DIR_MULT_ANALYSIS = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Appearance\';

% Directorio de salida
DIR_OUT = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\MultipletAnalysisPython\';

% Lista de estados y sus totales correspondientes
estados = {
    'AnesTransin';
    'AnesTransout';  % Rellenar con el valor correcto
    'SleepTransin';  % Rellenar con el valor correcto
    'SleepTransout'  % Rellenar con el valor correcto
    
};

for i = 1:size(estados, 1)
    state = estados{i, 1};
        

    % Nombre del archivo de análisis de multiplets
    %Cambiar por '_comb_3_regiones.mat' | '_comb_3_regiones_red.mat' | '_comb_4_regiones_red.mat'
    mult_analysis_name = fullfile(DIR_MULT_ANALYSIS, [state, '_comb_3_regiones.mat']);

    % Cargar los datos del archivo
    data_analysis = load(mult_analysis_name);
    data_analysis = data_analysis.resultsSorted;

    % Calcular umbral del 90%
    %umbral = ceil(0.9 * total);

    % Encontrar las combinaciones que aparecen en el 90% de los segmentos
    %idx_90 = find([data_analysis.frecuencia] >= umbral);
    comb_90 = {data_analysis.combinacion};

    % Nombre del archivo de salida
    %Cambiar por '_comb_3_regiones.mat' | '_comb_3_regiones_red.mat' | '_comb_4_regiones_red.mat'
    nombre = [state, '_comb_3_regiones.mat'];
    dir_nombre = fullfile(DIR_OUT, nombre);

    % Guardar los resultados
    save(dir_nombre, 'comb_90');
end
