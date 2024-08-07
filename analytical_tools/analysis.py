# author: Renzo Comolatti (renzo.com@gmail.com)
# created: 5/2022
# summary: Scripts to load and plot O-info analysis using the hyperplot toolbox.

from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt

import itertools
import scipy.io as sio

import hyperplot

# IMPORTANT NOTE:
# Functions in this library load dataset by creating a 'data' structure (dict) with the following information that
# is needed to call the plotting functions (e.g. plot_polygons(data)) that wrap around Hyperplot:
#    data : dict
#         'edges' : {'red': {order (int) : list of edges}, 'syn': {order (int) : list of edges}}
#           (dictionary of edges for both redundancy and synergy, for each multiplex order)
#         'node2labels' : {node : label}, None
#         'node2colors' : {node : color}, None
#         'orders' : list of int with multiplex orders (e.g. [3, 4, 5, 6])
#
# 'data' contains more field, but the ones above are essential to call the plotting functions here.

## FUNCTIONS TO LOAD DATASETS
def rawdata2data(rawdata, min_ord=3, max_ord=6):
    '''
    Input: rawdata (dict with '__header__', 'Otot', 'data' fields).
    Output: dict with Otot fields (sorted_red, index_red, bootsig_red, etc) and 'orders'.
    '''

    data = {'sorted_red': {}, 'index_red': {}, 'bootsig_red': {},
            'sorted_syn': {}, 'index_syn': {}, 'bootsig_syn': {}}

    for order in range(min_ord, max_ord+1):
        for key in data.keys():
            tmp = rawdata['Otot'][order - 1][key]

            if not hasattr(tmp, '__len__'):  # convert matlab singletons to array
                tmp = np.array([tmp])

            if key == 'index_syn' or key == 'index_red':  # VERY IMPORTANT!! matlab to python indexing
                data[key][order] = tmp - 1
            else:
                data[key][order] = tmp  # python indexing

    data['orders'] = list(range(min_ord, max_ord+1))

    return data

def add_datainfo2data(data, datainfo):
    '''
    Adds 'data', 'n_dims' and 'n_points' fields to data.

    Valid for 'empathy', 'eating', 'PTSD' datasets only.
    '''
    print('Adding data info...')
    data_shape = datainfo.shape
    print(f"shape: {data_shape}")
    data['data'] = datainfo
    data['n_dims'] = data_shape[1]
    data['n_points'] = data_shape[0]

def add_hypergraph2data(data):
    '''
    Add 'edges', 'edge2vals', 'hypergraph', 'node' to data.
    '''
    print('Adding hypergraph info...')

    decomposed_edges, decomposed_edge2vals = get_decomposed_edge_and_vals(data)
    nodes = list(range(1, data['n_dims'] + 1))
    hypergraphs = {stat: hyperplot.utils.create_decomposed_hypergraph(nodes, decomposed_edges[stat]) for stat in ['syn', 'red']}

    data['edges'] = decomposed_edges
    data['edge2vals'] = decomposed_edge2vals
    data['nodes'] = nodes
    data['hypergraph'] = hypergraphs


def flip_color2node(color2nodes):
    '''
    Turns color2node into node2color dict.
    '''

    node2color = {}
    for color, nodes in color2nodes.items():
        for node in nodes:
            node2color[node] = color
    return node2color


def get_decomposed_edge_and_vals(data):
    '''
    PARAMETERS
    ----------
    data : {'sorted_red' : {order : vals}, 'index_red' : {order : ixs},
            'sorted_syn' : {order : vals}, 'index_syn' : {order : ixs},
            'n_dims' : int, 'n_points' : int, 'data' : (n_dims, n_points)}

    RETURNS
    -------
    decomposed_edges : {order : tuple}
    decomposed_edge2val : {order : {edge : val}}
    '''
    # process data into
    # decomposed_edges = {red/syn : {order : list of edges}}
    # decomposed_edge2vals = {red/syn : {order : {edge : val}}}

    decomposed_edges = {'red': {}, 'syn': {}}
    decomposed_edge2vals = {'red': {}, 'syn': {}}

    for stat in ['red', 'syn']:
        print(f'>>> {stat.upper()}')

        decomposed_ixs = data['index_' + stat]
        print(f'decomposed_ixs: {decomposed_ixs}') #nik sartuta
        decomposed_vals = data['sorted_' + stat]

        # edges in the hypergraph
        print('Retrieving edges...')
        orders = data['index_' + stat].keys()
        #Nik sartuta
        print(f'Orders for {stat}: {orders}')
        for order in orders:
            n_dims = data['n_dims']
            print(f'n_dims: {n_dims}')  # Añade esta línea para imprimir el valor de n_dims

            # ATTENTION HERE: comes from matlab nchoosek function, e.g. a=nchoosek(1:53,3) (53 is n_dim, 3 is the order of multiplet)
            index2edge = list(itertools.combinations(range(1, n_dims + 1), order))
            #print(f'index2edge: {index2edge}')#nik sartuta

            ixs = decomposed_ixs[order]
            print(f'Order: {order} | ixs: {ixs}')
            decomposed_edges[stat][order] = [index2edge[ix] for ix in ixs]
            print(f'decomposed_edges: {decomposed_edges}')#nik sartuta

        # values for each edge
        print('Retrieving edge values...')
        edge2vals = {}
        for order in orders:

            edges = decomposed_edges[stat][order]
            vals = decomposed_vals[order]
            print(f'Order: {order} | vals: {vals}')
            for edge, val in zip(edges, vals):
                decomposed_edge2vals[stat][edge] = val  # add order field?

    return decomposed_edges, decomposed_edge2vals

def load_empathy_dataset(fpath):
    '''
    Load Briganti 2017 empathy dataset.
    '''
    empathy_color2nodes = {'red': [1, 5, 7, 12, 16, 23, 26],
                           'lightblue': [2, 4, 9, 14, 18, 20, 22],
                           'blue': [6, 10, 13, 17, 19, 24, 27],
                           'orange': [3, 8, 11, 15, 21, 25, 28]}
    node2colors = flip_color2node(empathy_color2nodes)

    nodes = [1, 5, 7, 12, 16, 23, 26,
             2, 4, 9, 14, 18, 20, 22,
             6, 10, 13, 17, 19, 24, 27,
             3, 8, 11, 15, 21, 25, 28]

    node2labels = {1:'1FS', 5:'5FS', 7:'7FS-R', 12:'12FS-R', 16:'16FS', 23:'23FS', 26:'26FS',
                   3:'3PT-R', 8:'8PT', 11:'11PT', 15:'15PT-R', 21:'21PT', 25:'25PT', 28:'28PT',
                   2:'2EC', 4:'4EC-R', 9:'9EC', 14:'14EC-R', 18:'18EC-R', 20:'20EC', 22:'22EC',
                   6:'6PD', 10:'10PD', 13:'13PD-R', 17:'17PD', 19:'19PD-R', 24:'24PD', 27:'27PD'
                   }

    nodeorder = {node: n for n, node in enumerate(nodes)}

    # load dataset
    data = load_dataset(fpath, min_ord=3, max_ord=5)

    data['nodeorder'] = nodeorder
    data['node2labels'] = node2labels
    data['node2labels'] = None
    data['node2colors'] = node2colors


    return data
#Nirea editatzeko
def load_anes_dataset(fpath):
    '''
    Load anes dataset.    '''

   
    anes_color2nodes = {'purple': [1],
                           'blue': [2],
                           'lightblue': [3],
                           'green': [4],
                           'yellow': [5],
                           'orange': [6],
                           'red': [7],
                           'pink': [8]}
    
    node2colors = flip_color2node(anes_color2nodes)
    
    nodes = [1, 2, 3, 4, 5, 6, 7, 8]
    
    node2labels = {
        1: '1MP', 2: '2LP', 3: '3PM', 4: '4MS',
        5: '5PC', 6: '6TC', 7: '7HV', 8: '8LV'
    }
   

    nodeorder = {node: n for n, node in enumerate(nodes)}

    # load dataset
    data = load_dataset(fpath, min_ord=3, max_ord=4)

    data['nodeorder'] = nodeorder
    data['node2labels'] = node2labels
    data['node2labels'] = None
    data['node2colors'] = node2colors


    return data

def load_eating_dataset(fpath):
    '''
    Load Eating disorders dataset.
    '''

    labels = ['Dft', 'Bul', 'Bod', 'Ine', 'Per', 'Dis', 'Awa', 'Fea', 'Asm', 'Imp', 'Soc', 'BDI',
              'Anx', 'Res', 'Nov', 'Har', 'Red', 'Pes', 'Sed', 'Coa', 'Set', 'Dir', 'Aut', 'Lim',
              'Foc', 'Inh', 'Mis', 'Sta', 'Exp', 'Cri', 'Qua', 'Pref']

    eating_color2labels = {'#7bba72' : ['Mis', 'Qua', 'Pref', 'Sta', 'Cri', 'Exp'],
                           '#ad9a53' : ['Soc', 'Asm', 'Imp', 'Per', 'Bod', 'Dft', 'Ine', 'Bul',
                                'Dis', 'Awa', 'Fea'],
                           '#789cff' : ['Sed', 'Har', 'Pes', 'Nov', 'Coa', 'Red', 'Set'],
                           '#d78adb' : ['Aut', 'Inh', 'Dir', 'Lim', 'Foc'],
                           '#cf5540' : ['BDI'],
                           '#48c0c2' : ['Anx', 'Res']}

    label2colors = flip_color2node(eating_color2labels)
    node2colors = {labels.index(label) + 1: color for label, color in label2colors.items()}
    node2labels = {node:label for node, label in zip(range(1, len(labels)+1), labels)}

    # load dataset
    data = load_dataset(fpath, min_ord=3, max_ord=6)

    data['nodeorder'] = None
    data['node2labels'] = node2labels
    data['node2colors'] = node2colors

    return data

def load_fmri_dataset(fpath):
    fMRI_color2nodes = {'#ffb169': [30, 41, 99, 45, 50],
                        '#7eed64': [66, 76],
                        '#348feb': [2, 5, 8, 4, 23, 97, 74, 79, 69],
                        '#a35ef2': [6, 1, 25, 13, 14, 43, 19, 7, 98],
                        '#e65555': [71, 65, 42, 93, 53, 83, 75, 31, 90, 78, 81, 95, 73, 70, 54, 96, 27],
                        '#d1d1d1': [20, 35, 29, 52, 34, 24, 85],
                        '#94fff6': [48, 77, 26, 88]}

    node2colors = flip_color2node(fMRI_color2nodes)

    data = load_dataset(fpath, min_ord=3, max_ord=6, n_dims=53)

    data['nodeorder'] = None
    data['node2labels'] = None
    data['node2colors'] = node2colors

    return data

def load_dataset(fpath, min_ord, max_ord, n_dims=None, n_points=None):
    '''
    Load dataset (output from O-info analysis, i.e. Otot structure)

    Returns
    -------
    data : dict ('sorted_red', 'index_red', 'bootsig_red', 'sorted_syn', 'index_syn', 'bootsig_syn')
    '''
    rawdata = loadmat(fpath)
    rawdata['Otot'] = [todict(x) for x in rawdata['Otot']]
    data = rawdata2data(rawdata, min_ord, max_ord)
    if 'data' in rawdata.keys():
        add_datainfo2data(data, rawdata['data'])
    else:
        data['n_points'] = n_points
        data['n_dims'] = n_dims
    add_hypergraph2data(data)
    return data

# functions to load .mat
def loadmat(fname):
    """
    this function should be called instead of direct spio.loadmat
    as it cures the problem of not properly recovering python dictionaries
    from mat files. It calls the function check keys to cure all entries
    which are still mat-objects
    """
    fname = str(fname)
    data = sio.loadmat(fname, struct_as_record=False, squeeze_me=True)
    return _check_keys(data)

def todict(matobj):
    """
    A recursive function which constructs from mat objects nested dictionaries
    """
    dict = {}
    for strg in matobj._fieldnames:
        elem = matobj.__dict__[strg]
        if isinstance(elem, sio.matlab.mio5_params.mat_struct):
            dict[strg] = _todict(elem)
        else:
            dict[strg] = elem
    return dict

def _check_keys(dict_in):
    """
    checks if entries in dictionary are mat-objects. If yes
    todict is called to change them to nested dictionaries
    """
    for key in dict_in:
        if isinstance(dict_in[key], sio.matlab.mio5_params.mat_struct):
            dict_in[key] = _todict(dict_in[key])
    return dict_in

## FUNCTIONS TO PLOT O-INFO ANALYSIS USING HYPERPLOT

def plot_polygons(data, internode_dists=[None, None], show_nodelabels=False, **kwargs):
    '''
    Plot O-info hypergraph using polygons

    Parameters
    ----------
    data : dict
        'edges' : {'red': {order (int) : list of edges}, 'syn': {order (int) : list of edges}}
        'node2labels' : {node : label}
        'node2colors' : {node : color}
        'orders' : list of int with multiplex orders (e.g. [3, 4, 5, 6])

    internode_dists : [float, float], where 1/np.sqrt(n_nodes) is the default optimal distance
    show_nodelabels : bool
    kwargs : node_size, nodelabel_xoffset, but see xgi.draw()
    '''

    n_plots = len(data['orders'])

    n_nodes = len(data['nodes'])
    k_opt = 1 / np.sqrt(n_nodes)
    print(f"Optimal internode distance: {k_opt:.2f}")

    if show_nodelabels:
        if data['node2labels'] is not None:
            nodelabels = data['node2labels']
        else:
            nodelabels = True
    else:
        nodelabels = None
    nodecolors = data['node2colors']

    fig, axs = plt.subplots(nrows=2, ncols=n_plots + 1, figsize=(n_plots * 4, 8))

    for i, kind in enumerate(['red', 'syn']):
        decomposed_edges = data['edges'][kind]
        all_edges = [edge for n in data['orders'] for edge in decomposed_edges[n]]
        ax = axs[i, 0]
        hyperplot.polygons(all_edges, ax=ax, nodecolors=nodecolors, nodelabels=nodelabels, internode_dist=internode_dists[i], **kwargs)
        ax.set_title(f"{kind.upper()}")

        for j, n in enumerate(decomposed_edges.keys()):
            ax = axs[i, j + 1]
            edges = decomposed_edges[n]
            if len(edges) > 0:
                hyperplot.polygons(edges, ax=ax, nodecolors=nodecolors, nodelabels=nodelabels, internode_dist=internode_dists[i], **kwargs)
            else:
                ax.axis('off')
            ax.set_title(f"Multiplet Order: {n}")

def plot_two_rows(data, column_spacing=2.5, nodesize=0.11, subplot_width=20, subplot_height=4):
    '''
    Plot O-info hypergraph using bipartite two row visualization from hypernetx

    Parameters
    ----------
    data : dict
        'edges' : {'red': {order (int) : list of edges}, 'syn': {order (int) : list of edges}}
        'node2labels' : {node : label}
        'node2colors' : {node : color}
        'orders' : list of int with multiplex orders (e.g. [3, 4, 5, 6])
        'nodeorder', list with order to plot nodes
    '''
    n_plots = len(data['orders'])
    nodelabels = data['node2labels']
    nodeorder = data['nodeorder']
    nodecolors = data['node2colors']

    fig, axs = plt.subplots(n_plots, 2, figsize=(subplot_width, n_plots * subplot_height))

    for i, kind in enumerate(['red', 'syn']):
        for n, order in enumerate(data['edges'][kind].keys()):
            ax = axs[i] if n_plots == 1 else axs[n, i]
            edges = data['edges'][kind][order]
            hyperplot.two_rows(edges,
                               nodelabels=nodelabels,
                               nodecolors=nodecolors,
                               nodeorder=nodeorder,
                               ax=ax,
                               nodesize=nodesize,
                               column_spacing=column_spacing)
            if n==1:
                ax.set_title(f'{kind.upper()}\nMultiplet Order: {order}', fontsize=16)
            else:
                ax.set_title(f'Multiplet Order: {order}', fontsize=16)

def plot_areas(data, edgecolors='gray'):
    '''
    Plot O-info hypergraph using concentric traces from hypernetx.

    Parameters
    ----------
    data : dict
        'edges' : {'red': {order (int) : list of edges}, 'syn': {order (int) : list of edges}}
        'node2labels' : {node : label}
        'node2colors' : {node : color}
        'orders' : list of int with multiplex orders (e.g. [3, 4, 5, 6])
    '''
    nodelabels = data['node2labels']
    nodecolors = data['node2colors']

    n_plots = len(data['orders'])
    fig, axs = plt.subplots(2, n_plots, figsize=(5 * n_plots, 10))

    for i, kind in enumerate(['red', 'syn']):
        for n, order in enumerate(data['edges'][kind].keys()):

            ax = axs[i] if n_plots == 1 else axs[i, n]
            edges = data['edges'][kind][order]

            if len(edges) > 0:
                hyperplot.areas(edges,
                                nodelabels=nodelabels,
                                nodecolors=nodecolors,
                                edgecolors=edgecolors,
                                ax=ax,
                                linewidth=1)
            else:
                ax.axis('off')

            ax.set_title(f'Multiplet Order: {order}')

def plot_planar(data):
    '''
    Plot planar hypergraph using networkx.

    Parameters
    ----------
    data : dict
        'edges' : {'red': {order (int) : list of edges}, 'syn': {order (int) : list of edges}}
        'node2labels' : {node : label}
        'node2colors' : {node : color}
        'orders' : list of int with multiplex orders (e.g. [3, 4, 5, 6])
    '''

    nodelabels = data['node2labels']

    n_plots = len(data['orders'])
    fig, axs = plt.subplots(2, n_plots, figsize=(5 * n_plots, 10))

    for _, ax in np.ndenumerate(axs):
        ax.axis('off')

    for i, kind in enumerate(['red', 'syn']):
        for n, order in enumerate(data['edges'][kind].keys()):
            ax = axs[i] if n_plots == 1 else axs[i, n]
            edges = data['edges'][kind][order]

            hyperplot.planar(edges, nodelabels=nodelabels, ax=ax)

            ax.set_title(f'Multiplet Order: {n + 3}')

if __name__ == "__main__":

    DATASET_DIR = Path.cwd() / 'data'
    SAVE_DIR = Path.cwd() / 'figs'

    savefig = True
    datasets = ['eating', 'empathy']
    plots = ['polygons', 'two_rows', 'areas', 'planar']
    dataset = ['eating']
    plots = ['polygons']

    for dataset in datasets:

        # LOAD DATA
        print(f'DATASET: {dataset.upper()}')
        print(8 * '=')
        if dataset=='eating':
            fpath = DATASET_DIR / 'EatingDisorders.mat'
            data = load_eating_dataset(fpath)

        elif dataset=='empathy':
            fpath = DATASET_DIR / 'Briganti2017.mat'
            data = load_empathy_dataset(fpath)
        else:
            raise ValueError('Dataset not accepted.')

        # PLOT DATA
        if 'polygons' in plots:
            plot_polygons(data, internode_dists=[1.6, None], show_nodelabels=True, **{'node_size':0.035})
            plt.suptitle(f'{dataset.upper()} Dataset', fontsize=20)
            if savefig:
                plt.savefig(SAVE_DIR / f"{dataset}_polygons.png", dpi=300)

        if 'two_rows' in plots:
            plot_two_rows(data, column_spacing=2.5, nodesize=0.11, subplot_width=20, subplot_height=4)
            plt.suptitle(f'{dataset.upper()} Dataset', fontsize=20)
            plt.subplots_adjust(top=0.9)
            if savefig:
                plt.savefig(SAVE_DIR / f"{dataset}_two-rows.png", dpi=300)

        if 'areas' in plots:
            plot_areas(data)
            plt.suptitle(f"{dataset.upper()} Dataset", fontsize=20)
            if savefig:
                plt.savefig(SAVE_DIR / f"{dataset}_areas.png", dpi=300)

        if 'planar' in plots:
            plot_planar(data)
            plt.suptitle(f'{dataset.upper()} Dataset', fontsize=20)
            if savefig:
                plt.savefig(SAVE_DIR / f"{dataset}_planar.png", dpi=300)
