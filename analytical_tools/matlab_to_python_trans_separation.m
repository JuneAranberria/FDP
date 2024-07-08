% Este código calcula la aparición de cada región en los multiplets sinergísticos/redundantes
% para diferentes estados y grafica los resultados en una matriz de subplots.

% Directorio del análisis de multiplets, para hacer la selección de regiones
DIR_MULT_ANALYSIS = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\MULTIPLET_ANALYSIS\';
% Directorio del análisis de multiplets, para hacer la selección de regiones redundancias
DIR_MULT_ANALYSIS_RED = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\MULTIPLET_ANALYSIS\REDUNDANCIES\';

DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Appearance\';
% Lista de estados y sus respectivos totales
states = {'SleepTrans', 'AnesTrans'};

for k = 1:length(states)
    state = states{k};
    
    % Obtener datos triplets sinergísticos
    mult_analysis_name = fullfile(DIR_MULT_ANALYSIS, strcat(state, '_comb_3_regiones.mat'));
    data_analysis = load(mult_analysis_name);
    data_analysis = data_analysis.resultsSorted;

    % Obtener datos triplets redundantes
    mult_analysis_name_3red = fullfile(DIR_MULT_ANALYSIS_RED, strcat(state, '_comb_3_regiones_red.mat'));
    data_analysis_3red = load(mult_analysis_name_3red);
    data_analysis_3red = data_analysis_3red.resultsSorted;

    % Obtener datos cuadruplets redundantes
    mult_analysis_name_4red = fullfile(DIR_MULT_ANALYSIS_RED, strcat(state, '_comb_4_regiones_red.mat'));
    data_analysis_4red = load(mult_analysis_name_4red);
    data_analysis_4red = data_analysis_4red.resultsSorted;
    
    % Encontrar los índices de las combinaciones que contienen 1 y 2
    idx_3syn_in = find(arrayfun(@(x) any(x.matrices == 1), data_analysis));
    idx_3syn_out = find(arrayfun(@(x) any(x.matrices == 2), data_analysis));
    idx_3red_in = find(arrayfun(@(x) any(x.matrices == 1), data_analysis_3red));
    idx_3red_out = find(arrayfun(@(x) any(x.matrices == 2), data_analysis_3red));
    idx_4red_in = find(arrayfun(@(x) any(x.matrices == 1), data_analysis_4red));
    idx_4red_out = find(arrayfun(@(x) any(x.matrices == 2), data_analysis_4red));
    
    data_analysis_in = data_analysis(idx_3syn_in);
    data_analysis_out = data_analysis(idx_3syn_out);
    data_analysis_3red_in = data_analysis_3red(idx_3red_in);
    data_analysis_3red_out = data_analysis_3red(idx_3red_out);
    data_analysis_4red_in = data_analysis_4red(idx_4red_in);
    data_analysis_4red_out = data_analysis_4red(idx_4red_out);
    
    % Crear una estructura temporal con el campo 'resultsSorted'
    results_in = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(1)), data_analysis_in));
    results_out = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(2)), data_analysis_out));
    results_3red_in = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(1)), data_analysis_3red_in));
    results_3red_out = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(2)), data_analysis_3red_out));
    results_4red_in = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(1)), data_analysis_4red_in));
    results_4red_out = struct('resultsSorted', arrayfun(@(x) setfield(x, 'segment_values', x.segment_values(2)), data_analysis_4red_out));
    
    % Crear una estructura temporal con el campo 'resultsSorted'
%     results_in = struct('resultsSorted', data_analysis_in);
%     results_out = struct('resultsSorted', data_analysis_out);
%     results_3red_in = struct('resultsSorted', data_analysis_3red_in);
%     results_3red_out = struct('resultsSorted', data_analysis_3red_out);
%     results_4red_in = struct('resultsSorted', data_analysis_4red_in);
%     results_4red_out = struct('resultsSorted', data_analysis_4red_out);
    
    % Guardar las estructuras temporales en archivos .mat
    data_analysis_in_results = fullfile(DIR_OUT, strcat(state, 'in_comb_3_regiones.mat'));
    data_analysis_out_results = fullfile(DIR_OUT, strcat(state, 'out_comb_3_regiones.mat'));
    data_analysis_3red_in_results = fullfile(DIR_OUT, strcat(state, 'in_comb_3_regiones_red.mat'));
    data_analysis_3red_out_results = fullfile(DIR_OUT, strcat(state, 'out_comb_3_regiones_red.mat'));
    data_analysis_4red_in_results = fullfile(DIR_OUT, strcat(state, 'in_comb_4_regiones_red.mat'));
    data_analysis_4red_out_results = fullfile(DIR_OUT, strcat(state, 'out_comb_4_regiones_red.mat'));
    
    save(data_analysis_in_results, '-struct', 'results_in');
    save(data_analysis_out_results, '-struct', 'results_out');
    save(data_analysis_3red_in_results, '-struct', 'results_3red_in');
    save(data_analysis_3red_out_results, '-struct', 'results_3red_out');
    save(data_analysis_4red_in_results, '-struct', 'results_4red_in');
    save(data_analysis_4red_out_results, '-struct', 'results_4red_out');
end
