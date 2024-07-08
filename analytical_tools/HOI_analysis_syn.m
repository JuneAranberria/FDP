% Este código analiza cuantos multiplets de cada tipo hay en cada estado, cuanto se
% repiten y en cuales. Este es el código final porque analiza
% todos los tamaños de multipletes y los guarda con el nombre adecuado.
% Este código además guarda la media de la o-info global de los multiplets
% obtenidos
%En el caso de los transition states, da la opción de guardar el valor de cada transición.

% Temporizador
tic;

%A)
%DIR_DATA = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\SLEEPING\';
%B)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\ANES\';
%C)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\AWAKE_C\';
%D)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\AWAKE_D\';
%PROPOFOL
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\ANES_PROPOFOL\';
%E)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\SLEEP_TRANS\';
%F)
DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_15\HOI_analysis_windows\ANES_TRANS\';

% Direccion para guardar los resultados
DIR_OUT = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\MULTIPLET_ANALYSIS\';
% Coger todos los archivos .mat
archivos = dir(fullfile(DIR_DATA, '*.mat'));

for multiplet = 3:7
    %results = struct('combinacion', {}, 'frecuencia', zeros(1, 0), 'matrices', {}, 'suma_valores', [], 'media_valores', []);
    %------PARA TRANS------
    results = struct('combinacion', {}, 'frecuencia', zeros(1, 0), 'matrices', {}, 'suma_valores', [], 'media_valores', [], 'segment_values', [], 'segment_values_2dec', []);
    %------PARA TRANS------
    % Obtener los datos de cada archivo
    for i = 1:length(archivos)
        % Nombre de los archivos
        nombre_archivo = fullfile(DIR_DATA, archivos(i).name);
        if startsWith(archivos(i).name, 'Otot')

            % Cargar datos
            data = load(nombre_archivo);
            data = data.Otot;

            data_mult = data(multiplet).index_var_syn;
            % Guardar los valores de la o-info de cada multiplet
            valores_mult = data(multiplet).sorted_syn;
            
            if ~isempty(data_mult)
                % Asegurar que las combinaciones no se repiten en una misma serie temporal
                [unique_comb, ia] = unique(data_mult, 'rows', 'stable');
                unique_values = valores_mult(ia);

                % Ir contando las apariencias de cada combinacion
                for j = 1:size(unique_comb, 1)
                    actual_comb = unique_comb(j, :);
                    actual_value = unique_values(j);

                    % Ha aparecido antes la combinacion?
                    idx = find(strcmp({results.combinacion}, num2str(actual_comb)));

                    % NO --> añadirla al final
                    if isempty(idx)
                        results(end + 1).combinacion = num2str(actual_comb);
                        results(end).frecuencia = 1;
                        results(end).matrices = i;
                        results(end).suma_valores = actual_value;
                        %------PARA TRANS------
                        results(end).segment_values = zeros(1, 2); % Inicializar con ceros
                        results(end).segment_values(i) = actual_value; % Asignar el valor en la posición correcta
                        results(end).segment_values_2dec = zeros(1, 2); % Inicializar con ceros                        
                        results(end).segment_values_2dec(i) = round(actual_value, 2); % Asignar el valor redondeado a 2 decimales en la posición correcta
%                         results(end).segment_values_2dec = strings(1, 2);
%                         results(end).segment_values_2dec(i) = sprintf('%.2f', actual_value); % Asignar el valor redondeado a 2 decimales en la posición correcta                        
                        %results(end).segment_values = actual_value; 
                        %------PARA TRANS------
                    else
                        % SI --> actualizar frecuencia, suma de valores y la lista de matrices
                        results(idx).frecuencia = results(idx).frecuencia + 1;
                        results(idx).matrices(end + 1) = i;
                        results(idx).suma_valores = results(idx).suma_valores + actual_value;
                        %------PARA TRANS------
                        results(idx).segment_values(i) = actual_value; % Actualizar el valor en la posición correcta
                        results(idx).segment_values_2dec(i) = round(actual_value, 2); % Actualizar el valor redondeado a 2 decimales en la posición correcta
                        
                        %results(idx).segment_values_2dec(i) = sprintf('%.2f', actual_value); % Actualizar el valor redondeado a 2 decimales en la posición correcta                        
%                         if results(idx).frecuencia == 2
%                             results(idx).segment_values = [results(idx).segment_values actual_value];
%                         end
                        %------PARA TRANS------
                    end
                end
            end
        end
    end

    % Calcular la media de los valores para cada combinacion
    for k = 1:length(results)
        results(k).media_valores = results(k).suma_valores / results(k).frecuencia;
    end
    
    % Para que no guarde archivos sin resultaods
    if ~isempty(results)
        % Ordenar de combinaciones con mayor aparicion a menor
        [~, sortedIdx] = sort([results.frecuencia], 'descend');
        resultsSorted = results(sortedIdx);

        % Guardar los resultados al final de procesar todos los archivos para este multiplet
        %A)
        %results_nombre = ['Sleeping_comb_', num2str(multiplet), '_regiones.mat'];
        %B)
        %results_nombre=['Anes_comb_', num2str(multiplet), '_regiones.mat'];
        %C)
        %results_nombre=['AwakeC_comb_', num2str(multiplet), '_regiones.mat'];
        %D)
        %results_nombre=['AwakeD_comb_', num2str(multiplet), '_regiones.mat'];
        %PROPOFOL
        %results_nombre=['AnesProp_comb_',num2str(multiplet), '_regiones.mat'];
        %E)
        %results_nombre=['SleepTrans_comb_', num2str(multiplet), '_regiones_values.mat'];
        %F)
        results_nombre=['AnesTrans_comb_', num2str(multiplet), '_regiones_values.mat'];

        dir_results_nombre = fullfile(DIR_OUT, results_nombre);
        save(dir_results_nombre, 'resultsSorted');
    end

end

% Fin del temporizador
tiempo_total = toc;
disp(['The code spent ', num2str(tiempo_total), ' seconds running.']);