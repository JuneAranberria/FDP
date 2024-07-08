% Temporizador
tic;

% Directorio principal
DIR_PRINCIPAL = 'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\local_analysis_null_gaussian\';

DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\local_analysis_null_gaussian\LOCAL_PERCENTAGES\';

% Lista de carpetas a analizar
carpetas = {'ANES_PROPOFOL', 'ANES', 'AWAKE_C', 'AWAKE_D', 'SLEEPING'};

% Patrones de nombres de archivos
patrones = {'d_o_AnesProp_rango_%d_regiones_%d  %d  %d.mat', ...
            'd_o_Anes_rango_%d_regiones_%d  %d  %d.mat', ...
            'd_o_AwakeC_rango_%d_regiones_%d  %d  %d.mat', ...
            'd_o_AwakeD_rango_%d_regiones_%d  %d  %d.mat', ...
            'd_o_Sleeping_rango_%d_regiones_%d  %d  %d.mat'};
SignificantPercentages = struct('multiplet', [], 'syn_percentage', [], 'red_percentage', []);

% Analizar cada carpeta
for k = 1:numel(carpetas)
    DIR_DATA = fullfile(DIR_PRINCIPAL, carpetas{k});
    patron = patrones{k};
    
    % Lista de todos los archivos en la carpeta
    archivos = dir(fullfile(DIR_DATA, '*_regiones_*.mat'));
    
    % Extraer los multiplets de los nombres de los archivos
    multipletsSet = containers.Map();
    for i = 1:length(archivos)
        nombreArchivo = archivos(i).name;
        % Extraer los números al final del nombre del archivo
        partes = regexp(nombreArchivo, '\d+', 'match');
        multiplet = str2double(partes(end-2:end));
        % Almacenar el multiplet en el set
        multipletsSet(join(string(multiplet), ' ')) = true;
    end
    
    % Convertir las llaves del Map en un array de multiplets
    multipletsKeys = keys(multipletsSet);
    numMultiplets = length(multipletsKeys);
    
    % Convertir las llaves de cadenas de texto a arrays numéricos de multiplets
    multiplets = cellfun(@(x) str2double(split(x)), multipletsKeys, 'UniformOutput', false);
    
    SignificantPercentages.multiplet=multiplets;
    
    % Crear una estructura para almacenar la correspondencia entre índices y multiplets
%     multipletIndices = struct();
%     for i = 1:numMultiplets
%         multipletIndices.(strjoin(num2str(multiplets{i}), '_')) = i;
%     end
%     
    % Número de rangos (75)
    numRangos = 75;
    
    % Inicializar una matriz para almacenar los resultados
    % Dimensiones: [rango, tipo_significativo (positivo/negativo), multiplet]
    resultados = zeros(numRangos, 2, numMultiplets);
    
    % Analizar cada multiplet
    for i = 1:numMultiplets
        multiplet = multiplets{i};
        
        % Analizar cada rango para el multiplet actual
        for j = 1:numRangos
            % Construye el patrón de nombre de archivo para el rango y multiplet actual
            archivoPatron = sprintf(patron, j, multiplet);
            
            % Obtén la lista de archivos que coinciden con el patrón
            archivosMultiplet = dir(fullfile(DIR_DATA, archivoPatron));
            
            % Si se encontró al menos un archivo, procesarlo
            if ~isempty(archivosMultiplet)
                % Cargar el primer archivo encontrado
                nombreArchivo = fullfile(DIR_DATA, archivosMultiplet(1).name);
                datos = load(nombreArchivo);
                gorde = datos.gorde;
                
                % Contar los valores significativos positivos y negativos
                valoresSignificativos = gorde(gorde(:, 2) == 1, 1);
                numPositivos = sum(valoresSignificativos > 0);
                numNegativos = sum(valoresSignificativos < 0);
                
                % Almacenar los resultados
                resultados(j, 1, i) = numPositivos/800*100;
                resultados(j, 2, i) = numNegativos/800*100;
            end
        end
    end
    
    SignificantPercentages.red_percentage=resultados(:,1, :);
    SignificantPercentages.syn_percentage=resultados(:,2, :);
    
    
    %Guardar
    name=['resultados_' carpetas{k}];
    dir_name=fullfile(DIR_OUT,name);
    save(dir_name, 'resultados')
    
    name_struct=['SignificantPercentages_' carpetas{k}];
    dir_name_struct=fullfile(DIR_OUT,name_struct);
    save(dir_name_struct, 'SignificantPercentages')    
   
end

% Fin del temporizador
tiempo_total = toc;
disp(['The code spent ', num2str(tiempo_total), ' seconds running.']);