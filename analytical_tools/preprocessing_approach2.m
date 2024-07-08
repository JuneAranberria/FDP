%This code makes the preprocessing of the signals for each state, with a
%non-overlapping running windows of 4 seconds, excluding the initial and
%final minutes of every state to ensure the monkey's state was established
%and not in transition.
%I stopped plotting because MATLAB dies.

%Temporizador
tic;

duracion_intervalo = 4; % Duración del intervalo en segundos

%A)Datos de cuando esta dormido: la carpeta dormido session1
%DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';
% Definir los puntos de inicio y fin del intervalo deseado
% Session : 1
% time: 141.14 [s] : Sleeping-Start 
% time: 3667.67 [s] : Sleeping-End 
% time1=141.14;
% time2=3667.67;

%B)Datos de cuando esta anestesiado: la carpeta anestesiado session2
DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% Session : 2
% time: 916.72 [s] : Anesthetized-Start 
% time: 1502.23 [s] : Anesthetized-End  
time1=916.72;
time2=1502.23;

%C)Datos de cuando esta despierto la carpeta de dormido session2
%DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% Session : 2
% time: 57.96 [s] : AwakeEyesOpened-Start 
% time: 967.33 [s] : AwakeEyesOpened-End 
%time1=57.96;
%time2=967.33;

%D)Datos de cuando esta despierto la carpeta de anestesia session1
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';
% % Session : 1
% % time: 348.85 [s] : AwakeEyesOpened-Start 
% % time: 1236.97 [s] : AwakeEyesOpened-End 
% time1=348.85;
% time2=1236.97;

%PROPOFOL
% Session : 2
% time: 85.98 [s] : AnestheticInjection 
% time: 553.55 [s] : Anesthetized-Start 
% time: 1098.10 [s] : Anesthetized-End 
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\Propofol\20120730PF_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% time1=553.55;
% time2=1098.10;

% DESCOMENTAR ESTO PARA LOS CALCULOS DE A-D
%Eliminar los minutos de cambio de transición
inicio=ceil(time1)+60;
fin=floor(time2)-60;

% Calcular cuántos rangos de 4 segundos hay entre el inicio y el fin
num_rangos = floor((fin - inicio + 1) / duracion_intervalo);
% Ajustar el punto final para que el último rango termine exactamente en el fin
fin_ajustado = inicio + (num_rangos * duracion_intervalo) - 1;
% Calcular los puntos de inicio y fin para cada intervalo de 4 segundos
rangos = [inicio:duracion_intervalo:fin_ajustado; inicio+duracion_intervalo-1:duracion_intervalo:fin_ajustado];

%E) Datos del momento en el que se duerme y en el que se depierta
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';
% rangos=[139 3666;142 3669];

%F) Datos del momento en el que le afecta la anestesia
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% rangos=[915 1501; 918 1504];


num_rangos=length(rangos);

%Poner rango=1:num_rangos si estas calculando A-D
%Poner rango=1:2 si estas calculando E-F

%for rango=1:num_rangos
for rango=1:num_rangos
    
    %% 1. CREAR MATRIZ DE LOS CANALES COGIENDO SOLO 4 SEGUNDOS

    % Crear estructuras para almacenar los datos
    ECoGData = struct(); 
    %ECoGDataDS =struct();

    %Para el downsampling
    fs_original=1000;
    fs_downsampled=200;
    
    %Crear el array del tiempo?
    
    
    %--Coger 4 segundos de cada canal (128)--
    %for chanel=1:128
    for chanel=1:128
        
        %Cargar canal actual
        load(strcat(DIR, 'ECoG_ch', num2str(chanel), '.mat'));
        data=eval(strcat('ECoGData_ch', num2str(chanel)));
        %Definir el inicio el final de los datos que hay que extraer
        hasi=rangos(1,rango)*1000;
        amai=(rangos(2,rango)+1)*1000-1;
        %Obtener datos unicamente del rango de este canal
        data=data(hasi:amai);        
        %Guardar los 4 segundos de data en ECoGData canal correspondiente
        fieldname = ['ch' num2str(chanel)];
        ECoGData.(fieldname) = data; 
        %Eliminar las variables temporales del workspace
        clear(['ECoGData_ch' num2str(chanel)]);         
        
    end    
    %--Coger 4 segundos de cada canal (128)--
    
    
    %--Poner datos en forma de matriz--
    % Crear celda para almacenar los datos de cada canal
    channelsData = cell(1, 128);

    % Extraer datos de cada canal y almacenar en la celda
    for i = 1:128
        channelName = sprintf('ch%d', i);
        channelsData{i} = ECoGData.(channelName);
    end

    % Convertir la celda a una matriz
    dataMatrix = cat(1, channelsData{:});
    %--Poner datos en forma de matriz--

    %% 2. LIMPIEZA

    %--2.1.NOTCH FILTERING 50Hz--
    %Prameter definition
    fs=1000; %Sampling frequency -->fs_original berdina da
    f0=50; %Power line frequency to eliminate
    Q=30; %Quality factor --> Ns k ponerle, mira a ver si lo quieres cambiar
    w0=f0/(fs/2);
    bw=w0/Q;
    %Filter design
    [b, a]=iirnotch(w0,bw);
    %Apply the filter
    dataMatrixFiltered=filtfilt(b, a, dataMatrix);
    %--2.2.BAND-PASS FILTERING 1-40Hz--
    dataMatrixFiltered=bandpass(dataMatrixFiltered,[1 40],fs);

    %Esta linea siguiente la utilizo para comparar los resultados haciendo
    %notch+bandpass y haciendo solo bandpass
%     dataMatrixFiltered2=bandpass(dataMatrix,[1 40],fs);
%     igual=dataMatrixFiltered==dataMatrixFiltered2;    
    %Esto me ha servido para ver que hacer notch+bandpass y hacer solo bandpass
    %no es lo mismo --> pero la diferencia es muy pequeña

    %% 3.DOWNSAMPLING

    data_downsampled=zeros(128,800);
    for i = 1:128
        data_downsampled(i, :) = resample(dataMatrixFiltered(i, :), fs_downsampled, fs_original);
    end
    
    %% 4.AGRUPAR

    %Definir la información de los canales y los grupos
    % Num tot canales
    total_canales = 128;

    % Canales de cada grupo(region)
    canales_por_grupo = {[52:53,56:61,63:64], [23:26,14:15,5:6,105:106,34:37,45:48], [16:17,27:28,38:39,49:51,92:93,54:55,62], [94:95,107:108,7:10,18:19,29:32,40:43,125:128], [121:124,1:4, 11:13,20:22,44,33 ], [65:71,80:83,96:98], [72:73,84:87,99:100,109:110], [74:79,88:91,101:104,111:120]};

    % GRUPOS-REGIONES:
    % Grupo1=MP, Grupo2=LP, Grupo3=PM, Grupo4=MS, Grupo5=PC, Grupo6=TC,
    % Grupo7=HV, Grupo8=LV

    % Num grupos
    num_grupos = numel(canales_por_grupo);


    %% 4.2.PRINCIPAL COMPONENT ANALYSIS (PCA)

    % Crear estructura para almacenar los datos por grupo
    datos_por_grupo = struct();

    % Iterar sobre cada grupo y guardar en struct
    for grupo = 1:num_grupos
        % Canales de este grupo (numeros)
        canales_del_grupo = canales_por_grupo{grupo};

        % Seleccionar datos de los canales de este grupo
        datos_del_grupo = data_downsampled(canales_del_grupo, :);    

        % Guardar los datos por grupo en la estructura de resultados
        nombre_del_grupo = sprintf('Grupo%d', grupo);
        datos_por_grupo.(nombre_del_grupo) = datos_del_grupo;
    end
    
    %% Loop sobre todos los grupos de la forma más sencilla

    %Inicializar variables para guardar tanto en struct como en matriz
    data_principal_component_space=struct();
    explained_groups=struct();
    reduced_data=struct();
    reduced_data_matrix=zeros(800, 8);

    for grupo = 1:num_grupos
        nombre_del_grupo = sprintf('Grupo%d', grupo);
        %Coger los datos del grupo
        datos=transpose(datos_por_grupo.(nombre_del_grupo));
        %Calcular coeff y explained
        [coeff,~,~,~,explained] = pca(datos);
        %Guardar explained
        explained_groups.(nombre_del_grupo)=explained;

        % Multiplicar la data original con la primera columna de coeff (primer
        % componente principal) para obtener directamente la data reducida 
        datos_reduced = datos*coeff(:,1);

        reduced_data.(nombre_del_grupo)=datos_reduced;
        reduced_data_matrix(:,grupo)=datos_reduced;

    end    
    
    %HAY QUE DESCOMENTAR EL SAVE DE LA SITUACION QUE SE QUIERE GUARDAR
    %A)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\SLEEPING\Sleeping_data\';
%     nombre_data_results = ['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');
   %B)
    dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\Results_window\ANES\Anes_data\';
    nombre_data_results = ['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
    ruta_data_results=fullfile(dir_data, nombre_data_results);
    save(ruta_data_results, 'reduced_data_matrix');    
    
    %C)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\AWAKE_C\AwakeC_data\';
%     nombre_data_results = ['20120705SLPChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix'); 

    %D)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\AWAKE_D\AwakeD_data\';
%     nombre_data_results = ['20120719ANESChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');

    %PROPOFOL
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_08\Results_window\ANES_PROPOFOL\Anes_propofol_data\';
%     nombre_data_results = ['20120730ANESPROPChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');   
    
    %E)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\SLEEP_TRANS\SleepTrans_Data\';
%     nombre_data_results = ['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix'); 
    
    %F)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\ANES_TRANS\AnesTrans_Data\';
%     nombre_data_results = ['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work050702_windows_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');
%     
    %COMO SE GUARDA LA DATA EJEMPLO: 20120719ANESChibi_Session2_700_704_work012502_PCA_matrix.mat
    %Fecha de prueba + estado analizado --> 20120719ANES
    %Mono --> Chibi
    %Sesion --> Session2
    %Rango de tiempo analizado --> 700_704
    %Volumen de codigo utilizado --> work012502
    %Metodo utilizado para la agrupacion --> PCA
    %Formato en el que se guarda --> matrix
    
%     %A)
%     %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\SLEEPING\Sleeping_figures\';    
%     %B)
%     dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_07\Results_window\ANES\Anes_figures\';    
%     
%     %Plotear explained para ver cuanta ifnormación recoge el primer componente
%     %principal de cada grupo
%     figure('Name','Explained PCA')
%     for grupo = 1:num_grupos
%         nombre_del_grupo = sprintf('Grupo%d', grupo);
%         subplot(2,4,grupo)
%         pareto(explained_groups.(nombre_del_grupo))
%         titulo=sprintf('Region %d', grupo);
%         title(titulo)
%         xlabel('Principal Component')
%         ylabel('Variance explained (%)')
%        
%         %A)
%         nombre_fig_explained=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work050702_windows_EXPLAINED.fig'];
%         
%         ruta_fig_explained=fullfile(dir_fig, nombre_fig_explained);
%         saveas(gcf, ruta_fig_explained);
% 
%     end
%     
%     %% 5.PLOTEAR RESULTADOS DE LAS SEÑALES 
% 
%     %--Plots 8 señales, por region PCA--
%     figure('Name','ECoG signals by regions (PCA) same Y')
% 
%     % Inicializar variable para almacenar el valor máximo
%     maxY=1;
%     minY=1;
% 
%     for grupo = 1:8
% 
%         campo = ['Grupo' num2str(grupo)];
%         data = reduced_data.(campo);
%         [M, N] = size(data);
% 
%         subplot(4, 2, grupo);
%         plot(data);
% 
%         % Obtener el valor máximo del eje y de cada subplot
%         maxY_subplot = max(ylim);
%         minY_subplot = min(ylim);
% 
%         % Actualizar el valor máximo global
%         maxY = max(maxY, maxY_subplot);
%         minY = min(minY, minY_subplot);
% 
%         xlabel('Samples');    
%         ylabel('Amplitude (microvolts)');
%         title(['Region ' num2str(grupo)]);
%     end
% 
%     % Establecer los límites del eje y de todos los subgráficos
%     for grupo = 1:8
%         subplot(4, 2, grupo);
%         maxmin=max(abs(minY), abs(maxY));
%         ylim([-maxmin, maxmin]);
%     end
%     
%     %A)
%     nombre_fig_results=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work050702_windows_RESULTS.fig'];
%     
%     
%     ruta_fig_results=fullfile(dir_fig, nombre_fig_results);
%     saveas(gcf, ruta_fig_results);
%     %--Plots 8 señales por region PCA--
    disp(['Rango ', num2str(rango), ' de ', num2str(num_rangos)])
end

% Fin del temporizador
tiempo_total = toc;
disp(['The code spent ', num2str(tiempo_total), ' seconds running.']);