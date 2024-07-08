%Este codigo realiza el preprocesado de los datos. 4 tasks, 20 rangos de 4
%segundos y 2 tasks que son las transiciones de estado.

%En este código tengo en cuenta los pairs para hacer la agrupaciones de
%canales por grupo.

%Preprocesamiento: 
%1.Crear matriz de los canales cogiendo solo 4 segundos
%2.Limpieza
    %2.1.Notch filtering 50Hz
    %2.2.Bandpass filtering 1-40Hz
%3.Downsampling
%4.Agrupar con PCA

%--Directorio de los datos--: 
%4 situiaciones distintas
%A)Dormido (2000-2004s)
%B)Anestesiado (1200-12004s)
%C)Despierto en la prueba de dormir (500-504s)
%D)Despierto en la prueba de anestesia (700-704s)

%HAY QUE DESCOMENTAR EL DIRECTORIO DE LA SITUACION QUE SE QUIERA ANALIZAR

%A)Datos de cuando esta dormido: la carpeta dormido session1
DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';

rangos=[200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100;
    204 304 404 504 604 704 804 904 1004 1104 1204 1304 1404 1504 1604 1704 1804 1904 2004 2104];

%B)Datos de cuando esta anestesiado: la carpeta anestesiado session2
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% 
% rangos=[1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475;
%     1004 1029 1054 1079 1104 1129 1154 1179 1204 1229 1254 1279 1304 1329 1354 1379 1404 1429 1454 1479];

%C)Datos de cuando esta despierto la carpeta de dormido session2
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% % 
% rangos=[100 125 150 175 200 225 250 275 300 325 350 375 400 425 450 475 500 525 550 575;
%     104 129 154 179 204 229 254 279 304 329 354 379 404 429 454 479 504 529 554 579];

%D)Datos de cuando esta despierto la carpeta de anestesia session1
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';
% 
% rangos=[400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875;
%     404 429 454 479 504 529 554 579 604 629 654 679 704 729 754 779 804 829 854 879];

%E) Datos del momento en el que se duerme y en el que se depierta
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120705SLP_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session1\';
% rangos=[139 3666;143 3670];

%F) Datos del momento en el que le afecta la anestesia
% DIR='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\20120719KT_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128\Session2\';
% rangos=[915 1501; 919 1505];

%Poner rango=1:20 si estas calculando A-D
%Poner rango=1:2 si estas calculando E-F
for rango=1:20

    %--Directorio de los datos--

    %% 1. CREAR MATRIZ DE LOS CANALES COGIENDO SOLO 4 SEGUNDOS

    % Crear estructuras para almacenar los datos
    ECoGData = struct(); 
    ECoGDataDS =struct();

    %Para el downsampling
    fs_original=1000;
    fs_downsampled=200;

    %Cargar el array del tiempo (esto en si de momento no utilizo para nada --> sería para visualizar los datos)
    load(strcat(DIR, 'EcoGTime.mat'));
    time=eval('ECoGTime');


    %HAY QUE DESCOMENTAR EL TIME DE LA SITUACION QUE SE QUIERA ANALIZAR
    %A)Coger 4 segundos del tiempo en el que está dormido (2000-2004s)
    %time=time(2000001:2004000);
    %B)Coger 4 segundos del tiempo en el que está bajo los efectos de la
    %anestesia (1200-12004s)
    %time=time(1200001:1204000);
    %C)Coger 4 segundos del tiempo en el que está despierto en la prueba de
    %dormir (500-504s)
    %time=time(500001:504000);
    %D)Coger 4 segundos del tiempo en el que está despierto en la prueba de
    %anestesia(700-704s)
%     time=time(700001:704000);


    %Crear el array de 4 segundos downsampled
    time_downsampled=0:1/fs_downsampled:3.995;

    %--Coger 4 segundos de cada canal (128) y hacer el downsampling--
    for chanel=1:128

        load(strcat(DIR, 'ECoG_ch', num2str(chanel), '.mat'));
        data=eval(strcat('ECoGData_ch', num2str(chanel)));

        %HAY QUE DESCOMENTAR EL DATA DE LA SITUACION QUE SE QUIERE ANALIZAR
        %A)
        %data=data(2000001:2004000);
        %B)
        %data=data(1200001:1204000);
        %C)
        %data=data(500001:504000);
        %D)
        %data=data(700001:704000);
        
        hasi=rangos(1,rango)*1000+1;
        amai=rangos(2,rango)*1000;
        
        data=data(hasi:amai);


        %data_downsampled=resample(data, fs_downsampled, fs_original); HE
        %COMENTADO TODO LO DE DOWNSMAPLING PORK LO VOY A HACER AL FINAL
        fieldname = ['ch' num2str(chanel)];
        ECoGData.(fieldname) = data; 
        %ECoGDataDS.(fieldname)=data_downsampled; ESTO TAMBIEN

        % Eliminar las variables temporales del workspace
        clear(['ECoGData_ch' num2str(chanel)]);

    end
    %--Coger 4 segundos de cada canal (128) y hacer el downsampling--

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
    %dataMatrixFiltered=bandpass(dataMatrix,[1 40],fs);

    %Esto me ha servido para ver que hacer notch+bandpass y hacer solo bandpass
    %no es lo mismo --> pero la diferencia es muy pequeña
    dataMatrixFiltered2=bandpass(dataMatrix,[1 40],fs);
    igual=dataMatrixFiltered==dataMatrixFiltered2;

    %--Estos dos pasos no los he aplicado--
    % 3. Visual inspection?

    % 4. Local detrending with the L1 Norm Technique --> Igual esto no tiene
    % ningun sentido en el mio pork solo pillo 4 segundos
    %--Estos dos pasos no los he aplicado--



    %% 3.DOWNSAMPLING

    data_downsampled=zeros(128,800);
    %data_downsampled=resample(dataMatrixFiltered, fs_downsampled, fs_original);
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
    dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEPING\Sleeping_data\';
    nombre_data_results = ['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
    ruta_data_results=fullfile(dir_data, nombre_data_results);
    save(ruta_data_results, 'reduced_data_matrix');
    %B)
    %save('20120719ANESChibi_Session2_1200_1204_work0223_PCA_matrix.mat', 'reduced_data_matrix');
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES\Anes_data\';
%     nombre_data_results = ['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');
    %C)
    %save('20120705SLPChibi_Session2_500_504_work0223_PCA_matrix.mat', 'reduced_data_matrix');
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_C\AwakeC_data\';
%     nombre_data_results = ['20120705SLPChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');    
    %D)
    %save('20120719ANESChibi_Session1_700_704_work0223_PCA_matrix.mat', 'reduced_data_matrix');
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_D\AwakeD_data\';
%     nombre_data_results = ['20120719ANESChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix'); 
    %E)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEP_TRANS\SleepTrans_data\';
%     nombre_data_results = ['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix'); 
    %F)
%     dir_data='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES_TRANS\AnesTrans_data\';
%     nombre_data_results = ['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_PCA_matrix.mat'];
%     ruta_data_results=fullfile(dir_data, nombre_data_results);
%     save(ruta_data_results, 'reduced_data_matrix');
    


    %COMO SE GUARDA LA DATA EJEMPLO: 20120719ANESChibi_Session2_700_704_work012502_PCA_matrix.mat
    %Fecha de prueba + estado analizado --> 20120719ANES
    %Mono --> Chibi
    %Sesion --> Session2
    %Rango de tiempo analizado --> 700_704
    %Volumen de codigo utilizado --> work012502
    %Metodo utilizado para la agrupacion --> PCA
    %Formato en el que se guarda --> matrix
    
    %A)
    dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEPING\Sleeping_figures\';
    %B)
    %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES\Anes_figures\';
    %C)
    %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_C\AwakeC_figures\';
    %D)
    %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\AWAKE_D\AwakeD_figures\';
    %E)
    %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\SLEEP_TRANS\SleepTrans_figures\';
    %F)
    %dir_fig='C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_02_25\Results\ANES_TRANS\AnesTrans_figures\';

    %Plotear explained para ver cuanta ifnormación recoge el primer componente
    %principal de cada grupo
    figure('Name','Explained PCA')
    for grupo = 1:num_grupos
        nombre_del_grupo = sprintf('Grupo%d', grupo);
        subplot(2,4,grupo)
        pareto(explained_groups.(nombre_del_grupo))
        title(nombre_del_grupo)
        xlabel('Principal Component')
        ylabel('Variance explained (%)')
       
        %A)
        nombre_fig_explained=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        %B)
        %nombre_fig_explained=['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        %C)
        %nombre_fig_explained=['20120705SLPChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        %D)
        %nombre_fig_explained=['20120719ANESChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        %E)
        %nombre_fig_explained=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        %F)
        %nombre_fig_explained=['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_EXPLAINED.fig'];
        
        ruta_fig_explained=fullfile(dir_fig, nombre_fig_explained);
        saveas(gcf, ruta_fig_explained);

    end

    %% 5.PLOTEAR RESULTADOS DE LAS SEÑALES 

    %--Plots 8 señales por region PCA--
    figure('Name','ECoG signals by regions (PCA) same Y')

    % Inicializar variable para almacenar el valor máximo
    maxY=1;
    minY=1;

    for grupo = 1:8

        campo = ['Grupo' num2str(grupo)];
        data = reduced_data.(campo);
        [M, N] = size(data);

        subplot(4, 2, grupo);
        plot(data);

        % Obtener el valor máximo del eje y de cada subplot
        maxY_subplot = max(ylim);
        minY_subplot = min(ylim);

        % Actualizar el valor máximo global
        maxY = max(maxY, maxY_subplot);
        minY = min(minY, minY_subplot);

        xlabel('Samples');    
        ylabel('Amplitude (microvolts)');
        title(['Region ' num2str(grupo)]);
    end

    % Establecer los límites del eje y de todos los subgráficos
    for grupo = 1:8
        subplot(4, 2, grupo);
        maxmin=max(abs(minY), abs(maxY));
        ylim([-maxmin, maxmin]);
    end
    
    %A)
    nombre_fig_results=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    %B)
    %nombre_fig_results=['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    %C)
    %nombre_fig_results=['20120705SLPChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    %D)
    %nombre_fig_results=['20120719ANESChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    %E)
    %nombre_fig_results=['20120705SLPChibi_Session1_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    %F)
    %nombre_fig_results=['20120719ANESChibi_Session2_', num2str(hasi),'_',num2str(amai), '_work0225_RESULTS.fig'];
    
    
    ruta_fig_results=fullfile(dir_fig, nombre_fig_results);
    saveas(gcf, ruta_fig_results);
    %--Plots 8 señales por region PCA--
end

