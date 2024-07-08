%Este codigo calcula los multiplets de cada rango dentro de cada
%task.Empleando la data preprocesada con el window de 4 segundos.


%Temporizador
tic;

%Directorio para llamar a la funcion
DIR_FUNC='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\MARINAZZO CODES\HOI-main\';
%hoi_function = fullfile(DIR_FUNC, 'hoi_exhaustive_loop_zerolag_all.m');
% Cargar la función directamente (sin usar fullfile)
hoi_function = @hoi_exhaustive_loop_zerolag_all;
%Directorio de datos
%A)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\SLEEPING\Sleeping_data\';
%B)
DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Results_window\ANES\Anes_data\';
%C)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\AWAKE_C\AwakeC_data\';
%D)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\AWAKE_D\AwakeD_data\';
%PROPOFOL
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\ANES_PROPOFOL\Anes_propofol_data\';
%E)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\SLEEP_TRANS\SleepTrans_Data\';
%F)
%DIR_DATA='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\ANES_TRANS\AnesTrans_Data\';
%Directorio donde guardar los resultados
%A)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\SLEEPING\';
%B)
DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\HOI_analysis_windows\ANES\';
%C)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\AWAKE_C\';
%D)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\AWAKE_D\';
%PROPOFOL
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\ANES_PROPOFOL\';
%E)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\SLEEP_TRANS\';
%F)
%DIR_OUT='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\HOI_analysis_windows\ANES_TRANS\';

% Coger todos los archivos .mat
archivos = dir(fullfile(DIR_DATA, '*.mat'));
% Obtener los datos de cada archivo
%for i = 1:length(archivos)
for i = 1:length(archivos)
    %Nombre de los archivos
    nombre_archivo = fullfile(DIR_DATA, archivos(i).name);

    % Cargar datos
    data = load(nombre_archivo);
    data=data.reduced_data_matrix;
    
    %Aplicar funcion
    [Otot, O_val_size_tot] = hoi_function(data, 8, 1);
    
    Otot_nombre=['Otot', archivos(i).name, '.mat'];
    dir_Otot_nombre=fullfile(DIR_OUT,Otot_nombre);
    save(dir_Otot_nombre, 'Otot')
    
    Oval_nombre=['Oval', archivos(i).name, '.mat'];
    dir_Oval_nombre=fullfile(DIR_OUT,Oval_nombre);
    save(dir_Oval_nombre, 'O_val_size_tot')


end

%[Otot, O_val_size_tot] = hoi_function(ts, maxsize, biascorrection, groups)

% Fin del temporizador
tiempo_total = toc;
disp(['The code spent ', num2str(tiempo_total), ' seconds running.']);