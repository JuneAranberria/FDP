%Este código calcula la O-información local de cada task en cada rango, de
%los multiplets que aparecen en todos los rangos

%Directorio para llamar a la funcion
DIR_FUNC='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\MARINAZZO CODES\local_O_information_general-main\';
%hoi_function = fullfile(DIR_FUNC, 'hoi_exhaustive_loop_zerolag_all.m');
% Cargar la función directamente (sin usar fullfile)
hoi_function = @deltaOI_Local;


%Directorio de datos
%A)
DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEPING\Sleeping_data\';
%B)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES\Anes_data\';
%C)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_C\AwakeC_data\';
%D)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_D\AwakeD_data';
%E)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEP_TRANS\SleepTrans_Data\';
%F)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES_TRANS\AnesTrans_Data\';

%Directorio donde guardar los resultados
%A)
DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\SLEEPING\';
DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\SLEEPING\FIGURES\';
%B)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\ANES\';
%DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\ANES\FIGURES\';
%C)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\AWAKE_C\';
%DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\AWAKE_C\FIGURES\';
%D)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\AWAKE_D\';
%DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\AWAKE_D\FIGURES\';
%E)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\SLEEP_TRANS\';
%DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\SLEEP_TRANS\FIGURES\';
%F)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\ANES_TRANS\';
%DIR_OUT_FIG='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_03_05\local_analysis\ANES_TRANS\FIGURES\';

%Directorio del analisis de multiplets, para hacer la selección de regiones
DIR_MULT_ANALYSIS='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_26\HOI_analysis\MULTIPLET ANALYSIS\';

%Analisis multiplets de tercer orden
%A)
state='Sleeping';
%B)
%state='Anes';
%C)
%state='AwakeC';
%D)
%state='AwakeD';
%E)
%state='SleepTrans';
%F)
%state='AnesTrans';

mult_analysis_name=fullfile(DIR_MULT_ANALYSIS, strcat(state, '_comb_3_regiones.mat'));
data_analysis=load(mult_analysis_name);
data_analysis=data_analysis.resultsSorted;

%Obtener solo las combinaciones que aparecene n todos los segmentos
%(frecuencia=20)
idx_f20 = find([data_analysis.frecuencia]==20);
comb_f20={data_analysis(idx_f20).combinacion};


% Coger todos los archivos .mat
archivos = dir(fullfile(DIR_DATA, '*.mat'));
% Obtener los datos de cada archivo --> todos los rangos
%for i = 1:length(archivos)
for i = 1:length(archivos)
    close all
    %Nombre de los archivos
    nombre_archivo = fullfile(DIR_DATA, archivos(i).name);

    % Cargar datos
    data = load(nombre_archivo);
    data=data.reduced_data_matrix;
    
    %Dentro de cada rango hay que analizar todas las distintas
    %combinaciones de multiplets
    [x num_comb]=size(comb_f20);
    
    %Para pintar todos las combinaciones con el mismo eje
    maxY=0;
    minY=0;

    %Interactuamos por cada combinacion con frecuencia de 20, para realizar
    %los calculos
    %comb=1:num_comb
    for comb=1:num_comb
        comb_actual = str2num(comb_f20{comb});
        data_comb=data(:,comb_actual);    
        
        %Aplicar funcion de O-info local a la combinación actual
        [d_tc, d_dtc, d_o] = deltaOI_Local(data_comb,'continous');
     
        d_tc_nombre=['d_tc_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual), '.mat'];
        dir_d_tc_nombre=fullfile(DIR_OUT,d_tc_nombre);
        save(dir_d_tc_nombre, 'd_tc')

        d_dtc_nombre=['d_dtc_', state, '_rango_',num2str(i),  '_regiones_', num2str(comb_actual), '.mat'];
        dir_d_dtc_nombre=fullfile(DIR_OUT,d_dtc_nombre);
        save(dir_d_dtc_nombre, 'd_dtc')

        d_o_nombre=['d_o_', state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual),'.mat'];
        dir_d_o_nombre=fullfile(DIR_OUT,d_o_nombre);
        save(dir_d_o_nombre, 'd_o')   
        
        %Plotear por combinaciones
        figure('Name', strcat('Local O-information', 32, state))
     

        data_o_info_region=d_o(:,1);
        plot(data_o_info_region)
        yline(0, 'r')      

        % Obtener el valor máximo del eje y de cada subplot
        maxY_subplot = max(ylim);
        minY_subplot = min(ylim);

        % Actualizar el valor máximo global
        maxY = max(maxY, maxY_subplot);
        minY = min(minY, minY_subplot);

        xlabel('Samples');    
        ylabel('Local O-information');
        %close(strcat('Local O-information', 32, state))
        close

        
    end
    maxmin=max(abs(minY), abs(maxY));
    for comb=1:num_comb
        comb_actual = str2num(comb_f20{comb});
        data_comb=data(:,comb_actual);    
        
        %Aplicar funcion de O-info local a la combinación actual
        [d_tc, d_dtc, d_o] = deltaOI_Local(data_comb,'continous');       
                %Plotear por combinaciones
        figure('Name', strcat('Local O-information', 32, state))     

        data_o_info_region=d_o(:,1);
        plot(data_o_info_region)
        yline(0, 'r')
        
        xlabel('Samples');    
        ylabel('Local O-information');
        title(['Combinacion ' num2str(comb_actual)]);
                    
        ylim([-maxmin, maxmin]);
        
        %Guardar figuras
        nombre_fig_local=[state, '_rango_',num2str(i), '_regiones_', num2str(comb_actual),'.fig'];
       
        ruta_fig_local=fullfile(DIR_OUT_FIG, nombre_fig_local);
        saveas(gcf, ruta_fig_local);

    end    
    pause(1)
    disp(strcat('Segmento', num2str(i) , 'terminado'))
end

