%Este código calcula la O-información local de cada task en cada rango, de
%los multiplets que aparecen en todos los rangos y realiza el análisis de
%la distribución nula. Guarda los gráficos, la data y los indices donde la
%o-informacion local es significante.

%Temporizador
tic;

%Directorio para llamar a la funcion
DIR_FUNC='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\MARINAZZO CODES\local_O_information_general-main\';
%hoi_function = fullfile(DIR_FUNC, 'hoi_exhaustive_loop_zerolag_all.m');
% Cargar la función directamente (sin usar fullfile)
hoi_function = @deltaOI_Local;


%Directorio de datos
%A)
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\SLEEPING\Sleeping_data\';
%B)
DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_28\Results_window\ANES\Anes_data\';
%C)
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\AWAKE_C\AwakeC_data\';
%D)
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\AWAKE_D\AwakeD_data\';
%B*)PROPOFOL
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\ANES_PROPOFOL\Anes_propofol_data\';
%E)
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\SLEEP_TRANS\SleepTrans_Data\';
%F)
%DIR_DATA='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\Results_window\ANES_TRANS\AnesTrans_Data\';

%Directorio donde guardar los resultados
%A)
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\SLEEPING\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\SLEEPING\FIGURES\';
%B)
DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_28\local_analysis_null_red_3\ANES\';
DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_28\local_analysis_null_red_3\ANES\FIGURES\';
%C)
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\AWAKE_C\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\AWAKE_C\FIGURES\';
%D)
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\AWAKE_D\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\AWAKE_D\FIGURES\';
%B*)PROPOFOL
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\ANES_PROPOFOL\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\ANES_PROPOFOL\FIGURES\';
%E)
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\SLEEP_TRANS\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\SLEEP_TRANS\FIGURES\';
%F)
% DIR_OUT='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\ANES_TRANS\';
% DIR_OUT_FIG='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_15\local_analysis_null_red_3\ANES_TRANS\FIGURES\';

%Directorio del analisis de multiplets, para hacer la selección de regiones
DIR_MULT_ANALYSIS='C:\Users\jaranber\OneDrive - UGent\Desktop\2024_05_28\HOI_analysis_windows\MULTIPLET_ANALYSIS\REDUNDANCIES\';

%Analisis multiplets de tercer orden
%A)
% state='Sleeping';
% total=851; %Rangos totales de cada estado
%B)
state='Anes';
total=116;
%C)
% state='AwakeC';
% total=197;
%D)
% state='AwakeD';
% total=192;
%B*) Anes propofol
% state='AnesProp';
% total=106;
%E)
% state='SleepTrans';
%F)
% state='AnesTrans';

mult_analysis_name=fullfile(DIR_MULT_ANALYSIS, strcat(state, '_comb_3_regiones_red.mat'));
data_analysis=load(mult_analysis_name);
data_analysis=data_analysis.resultsSorted;

%Obtener solo las combinaciones que aparecen en el 90% de los segmentos
umbral=ceil(0.9*total);
idx_90=find([data_analysis.frecuencia]>=umbral);
comb_90={data_analysis(idx_90).combinacion};

%Para los trans
% idx_90=find([data_analysis.frecuencia]>=0);
% comb_90={data_analysis(idx_90).combinacion};


%Obtener solo las combinaciones que aparecen en todos los segmentos
%(frecuencia=20)
% idx_f20 = find([data_analysis.frecuencia]==20);
% comb_f20={data_analysis(idx_f20).combinacion};

%Cuando son los transition
% matrices=data_analysis(:).matrices;
% idx_IN = find([data_analysis.matrices]==1);
% comb_IN={data_analysis(idx_IN).combinacion};
%Para analizar en el trans todos y hacer l acomparación:
% idx_f20 = find([data_analysis.frecuencia]>0);
% comb_f20={data_analysis(idx_f20).combinacion};

% Coger todos los archivos .mat
archivos = dir(fullfile(DIR_DATA, '*.mat'));
% Obtener los datos de cada archivo --> todos los rangos
%Para los transition
%for i = 1:length(archivos)
%Para los no-transition que quiero coger 75
%for i = 1:75
for i = 1:75
    close all
    %Nombre de los archivos
    nombre_archivo = fullfile(DIR_DATA, archivos(i).name);

    % Cargar datos
    data = load(nombre_archivo);
    data=data.reduced_data_matrix;
    
    %Dentro de cada rango hay que analizar todas las distintas
    %combinaciones de multiplets
    [x num_comb]=size(comb_90);
    
    %Para pintar todos las combinaciones con el mismo eje
    maxY=0;
    minY=0;
    
    %Numero de veces que hago shuffle
    num_shuffles = 100; 
    
    %Para almacenar la local o-infor de cada combinacion
    data_o_info_region=zeros(800, num_comb);    
    %Para almacenar los indices significativos de cada combinacion
    significant_idx=cell(1,num_comb);
    

    %Interactuamos por cada combinacion con frecuencia de 20, para realizar
    %los calculos
    %comb=1:num_comb
    for comb=1:num_comb
        comb_actual = str2num(comb_90{comb});
        data_comb=data(:,comb_actual);    
        
        
        %------NULL DISTRIBUTION ANALYSIS----------------------------------      
        %Hacer el shuffle y calcular la o-información local 100 veces
        null_d_o = zeros(length(data_comb), num_shuffles);
        null_d_o_calculations=zeros(800,3);
        
        %Dimensión añadida para las variables
        %null_d_o = zeros(length(data_comb), 3, num_shuffles);
        
        for shuffle_idx=1:num_shuffles
            shuffled_data = data_comb(randperm(size(data_comb,1)), :); % Shuffle de los datos
            [~, ~, null_d_o_calculations] = deltaOI_Local(shuffled_data, 'continous'); % Calcular OI local

            null_d_o(:,shuffle_idx)=null_d_o_calculations(:,1);%Guardar la local o-info de cada shuffle
        end        
   
        
        %Percentiles de 5 y 95 de la null distribution
        null_d_o_percentiles = prctile(null_d_o, [5, 95], 2);
                
        %Comparación con la local o-info real
        %Aplicar funcion de O-info local a la combinación actual REAL
        [d_tc, d_dtc, d_o] = deltaOI_Local(data_comb,'continous');
        data_o_info_region(:,comb)=d_o(:,1);
        %Comparación de la local o-info real con los percentiles
        significant_idx{comb} = find(data_o_info_region(:,comb) > null_d_o_percentiles(:,2) | data_o_info_region(:,comb) < null_d_o_percentiles(:,1));

        % Crear variable gorde con una segunda columna de ceros
        %Cambio: Inicializar gorde con una segunda columna de ceros
        gorde = zeros(size(d_o, 1), 2); 
        gorde(:, 1) = d_o(:, 1);

        % Poner 1 en los índices significativos en la segunda columna
        %Cambio: Marcar índices significativos en la segunda columna
        gorde(significant_idx{comb}, 2) = 1; 

        % Guardar resultados significativos y plotear
        %Aquí ploteo sin guardar, porque es para establecer el mismo ylim
        %para todos los plots
%         if ~isempty(significant_idx{comb})
%             % Plotear solo si hay resultados significativos
%             figure('Name', strcat('Significant Local O-information', 32, state, ' Combination ', num2str(comb_actual)))
%             plot(data_o_info_region(:,comb))
%             hold on
%             yline(0, 'r')
%             plot(significant_idx{comb}, data_o_info_region(significant_idx{comb}, comb), 'ro', 'MarkerSize', 10) % Puntos significativos en rojo
%             hold off
%             xlabel('Samples');
%             ylabel('Local O-information');
%             title(['Combinacion ' num2str(comb_actual)]);
% 
%             % Obtener el valor máximo del eje y de cada subplot
%             maxY_subplot = max(ylim);
%             minY_subplot = min(ylim);
% 
%             % Actualizar el valor máximo global
%             maxY = max(maxY, maxY_subplot);
%             minY = min(minY, minY_subplot);
% 
%             close
% 
%             % Guardar figuras --> Aquí no las guardo porque no están todas
%             % con el mismo eje
% %             nombre_fig_local=[state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual), '_significant.fig'];
% %             ruta_fig_local=fullfile(DIR_OUT_FIG, nombre_fig_local);
% %             saveas(gcf, ruta_fig_local);
%         end
        %------NULL DISTRIBUTION ANALYSIS----------------------------------
       
                
%         Para guardar los datos, peor como ya los tengo guardados en el de
%         sin null y estos todavia no se que hacer con ellos no los guardo
%         (está sin revisar ni actualizar)

%         d_tc_nombre=['d_tc_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual), '.mat'];
%         dir_d_tc_nombre=fullfile(DIR_OUT,d_tc_nombre);
%         save(dir_d_tc_nombre, 'd_tc')
% 
%         d_dtc_nombre=['d_dtc_', state, '_rango_',num2str(i),  '_regiones_', num2str(comb_actual), '.mat'];
%         dir_d_dtc_nombre=fullfile(DIR_OUT,d_dtc_nombre);
%         save(dir_d_dtc_nombre, 'd_dtc')
% 
%         d_o_nombre=['d_o_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual),'.mat'];
%         dir_d_o_nombre=fullfile(DIR_OUT,d_o_nombre);
%         save(dir_d_o_nombre, 'd_o')   
        
        d_o_nombre=['d_o_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual),'.mat'];
        dir_d_o_nombre=fullfile(DIR_OUT,d_o_nombre);
        %gorde=d_o(:,1);
        save(dir_d_o_nombre, 'gorde')   
        
%         significance_nombre=['d_o_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual),'_significance.mat'];
%         dir_significance_nombre=fullfile(DIR_OUT,significance_nombre);
%         gorde_significance=significant_idx{comb};
%         save(dir_significance_nombre, 'gorde_significance');
%         

    end
    

    
    
    %Ahiora ya ploteo para guardar, una vez he establecido el mismo ylijm
    %para todas las combinaciones del mismo rango
    % maxmin=max(abs(minY), abs(maxY));
    % %for comb=1:num_comb
    % for comb=1:num_comb
    % \
   
    %     comb_actual = str2num(comb_90{comb});
    %     data_comb=data(:,comb_actual);    
    % 
    %     figure('Name', strcat('Significant Local O-information', 32, state, ' Combination ', num2str(comb_actual)))
    %     plot(data_o_info_region(:,comb))
    %     hold on
    %     yline(0, 'r')
    %     plot(significant_idx{comb}, data_o_info_region(significant_idx{comb}, comb), 'ro', 'MarkerSize', 10) % Puntos significativos en rojo
    %     hold off
    %     xlabel('Samples');
    %     ylabel('Local O-information');
    %     title(['Combinacion ' num2str(comb_actual)]);
    %     ylim([-maxmin, maxmin]);
    % 
    %     %Guardar figuras
    %     nombre_fig_local=[state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual), '_significant.fig'];
    %     ruta_fig_local=fullfile(DIR_OUT_FIG, nombre_fig_local);
    %     saveas(gcf, ruta_fig_local);
    % 
    % 
    % 
    % end

    pause(1)
    disp(strcat('Segmento', num2str(i) , 'terminado'))
end

% Fin del temporizador
tiempo_total = toc;
disp(['The code spent ', num2str(tiempo_total), ' seconds running.']);