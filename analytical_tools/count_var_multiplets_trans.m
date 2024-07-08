% Este código calcula la aparición de cada región en los multiplets sinergísticos/redundantes
% para diferentes estados y grafica los resultados en una matriz de subplots.
%ESTE ES EL BUENO

% Directorio del análisis de multiplets, para hacer la selección de regiones
DIR_MULT_ANALYSIS = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Appearance\';
% Directorio del análisis de multiplets, para hacer la selección de regiones redundancias
DIR_MULT_ANALYSIS_RED = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Appearance\';

% Lista de estados y sus respectivos totales
states = {'SleepTransin', 'SleepTransout', 'AnesTransin', 'AnesTransout'};

% Número de variables
num_variables = 8;

% Crear el gráfico con subplots organizados horizontalmente
figure;
sgtitle('Variable Appereance Analysis');

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

    % Obtener solo las combinaciones que aparecen en el 90% de los segmentos
%     umbral = ceil(0.9 * total);
%     idx_3syn = find([data_analysis.frecuencia] >= umbral);
%     idx_3red = find([data_analysis_3red.frecuencia] >= umbral);
%     idx_4red = find([data_analysis_4red.frecuencia] >= umbral);

    comb_3syn = {data_analysis.combinacion};
    comb_3red = {data_analysis_3red.combinacion};
    comb_4red = {data_analysis_4red.combinacion};

    % Inicializar un vector para contar las apariciones de cada variable
    count_appearances_3syn = zeros(1, num_variables);
    count_appearances_3red = zeros(1, num_variables);
    count_appearances_4red = zeros(1, num_variables);

    % Recorrer cada triplet en la celda y contar las apariciones de cada variable
    for i = 1:length(comb_3syn)
        multiplet = str2num(comb_3syn{i}); %#ok<ST2NM>
        for j = 1:length(multiplet)
            variable = multiplet(j);
            count_appearances_3syn(variable) = count_appearances_3syn(variable) + 1;
        end
    end

    for i = 1:length(comb_3red)
        multiplet = str2num(comb_3red{i}); %#ok<ST2NM>
        for j = 1:length(multiplet)
            variable = multiplet(j);
            count_appearances_3red(variable) = count_appearances_3red(variable) + 1;
        end
    end

    for i = 1:length(comb_4red)
        multiplet = str2num(comb_4red{i}); %#ok<ST2NM>
        for j = 1:length(multiplet)
            variable = multiplet(j);
            count_appearances_4red(variable) = count_appearances_4red(variable) + 1;
        end
    end

    % Crear subplots para cada estado
    row_offset = (k - 1) * 3;

    % Primer subplot para count_appearances_3syn
    subplot(length(states), 3, row_offset + 1);
    bar(count_appearances_3syn);
    title(['SYN TRIP ', state]);
    xlabel('Region');
    ylabel('Appearance');
    xticks(1:num_variables);
    %set(gca, 'XTickLabel', {'MP(1)', 'LP(2)', 'PM(3)', 'MS(4)', 'PC(5)', 'TC(6)', 'HV(7)', 'LC(8)'}); % Cambiar etiquetas del eje x
    ylim([0, length(comb_3syn)]); % Establecer límite del eje y
    text(0.5, length(comb_3syn), num2str(length(comb_3syn)), 'Color', 'r', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom'); % Número encima de la línea

    % Segundo subplot para count_appearances_3red
    subplot(length(states), 3, row_offset + 2);
    bar(count_appearances_3red);
    title(['RED TRIP ', state]);
    xlabel('Region');
    ylabel('Appearance');
    xticks(1:num_variables);
    %set(gca, 'XTickLabel', {'MP(1)', 'LP(2)', 'PM(3)', 'MS(4)', 'PC(5)', 'TC(6)', 'HV(7)', 'LC(8)'}); % Cambiar etiquetas del eje x
    ylim([0, length(comb_3red)]); % Establecer límite del eje y
    text(0.5, length(comb_3red), num2str(length(comb_3red)), 'Color', 'r', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom'); % Número encima de la línea


    % Tercer subplot para count_appearances_4red
    subplot(length(states), 3, row_offset + 3);
    bar(count_appearances_4red);
    title(['RED QUAD ', state]);
    xlabel('Region');
    ylabel('Appearance');
    xticks(1:num_variables);
    %set(gca, 'XTickLabel', {'MP(1)', 'LP(2)', 'PM(3)', 'MS(4)', 'PC(5)', 'TC(6)', 'HV(7)', 'LC(8)'}); % Cambiar etiquetas del eje x
    ylim([0, length(comb_4red)]); % Establecer límite del eje y
    text(0.5, length(comb_4red), num2str(length(comb_4red)), 'Color', 'r', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom'); % Número encima de la línea

end