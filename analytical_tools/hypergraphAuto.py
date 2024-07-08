import scipy.io
import matplotlib.pyplot as plt
import hypernetx as hnx

def load_and_process_data(file_path):
    # Cargar el archivo .mat
    mat = scipy.io.loadmat(file_path)

    # Extraer la variable comb_90 del archivo .mat
    comb_90 = mat['comb_90'][0]

    # Mapeo de números a nombres de variables
    variable_names = {
        1: 'MP',
        2: 'LP',
        3: 'PM',
        4: 'MS',
        5: 'PC',
        6: 'TC',
        7: 'HV',
        8: 'LC'
    }

    # Crear el diccionario scenes con números y nombres, manejando errores
    scenes_names = {}
    for i in range(len(comb_90)):
        try:
            scenes_names[i] = tuple(f"{int(num)}({variable_names[int(num)]})" for num in comb_90[i][0] if num.strip().isdigit())
        except ValueError as e:
            print(f"Error converting {comb_90[i][0]}: {e}")

    return scenes_names

# Especifica la ruta completa de los archivos .mat
file_paths = [
    r'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\MultipletAnalysisPython\Anes_comb_3_regiones_90.mat',
    r'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\MultipletAnalysisPython\Anes_comb_3_regiones_90_red.mat',
    r'C:\Users\June\OneDrive - Mondragon Unibertsitatea\ERASMUS\0_TFG\WORKING\Chibi\CODES\2024_05_28\MultipletAnalysisPython\Anes_comb_4_regiones_90_red.mat'
]

# Procesar los datos y generar los gráficos
fig, axes = plt.subplots(1, 3, figsize=(18, 6))

for i, file_path in enumerate(file_paths):
    scenes_names = load_and_process_data(file_path)
    title = ['SYN Order 3', 'RED Order 3', 'RED Order 4'][i]
    H_names = hnx.Hypergraph(scenes_names)
    hnx.draw(H_names, ax=axes[i])
    axes[i].set_title(title)

# Título general para los tres subplots
plt.suptitle('SLEEP', fontsize=16)

# Mostrar los gráficos
plt.tight_layout()
plt.show()
