# -*- coding: utf-8 -*-
"""

@author: mgerard
"""

import pandas as pd
import subprocess
import shutil
from varnaapi import Structure

def main(query_sequence, id_name):
    '''
    Esta función es llamada por el webdemo para generar
    la interfaz gráfica y para ejecutar luego el webdemo.
    '''

    # CONSTRUYO ARCHIVO PARA PREDICCION ---> CSV que lee sincfold
    data = {'id': [id_name], 'sequence': [f'{query_sequence}']}
    df = pd.DataFrame(data=data)
    df.to_csv('to_predict.csv', index=False)

    shutil.rmtree('output', ignore_errors=True)
    subprocess.call(["sincFold pred to_predict.csv -o output"], shell=True)
    ct_file = f'output/{id_name}.ct'

    # Get dot-bracket structure from ct
    dotbracket_file  = f"output/{id_name}.fold"
    subprocess.call([f"export DATAPATH=/RNAstructure/data_tables; /usr/local/RNAstructure/ct2dot {ct_file} 1 {dotbracket_file}"], shell=True)
    dotbracket = open(dotbracket_file).readlines()[2].strip()

    # DECIDO COMO GRAFICAR
    max_lenght = 256
    if len(query_sequence) <= max_lenght:
        # GRAFICO LOCAL
        filename_html = draw_RNAseq(id_name, query_sequence, dotbracket)
    else:
        filename_html = f'{id_name}.html'

        # GENERO COPIA DEL TEMPLATE
        with open('TEMPLATE.html', 'r', encoding="utf-8") as fp:
            html = fp.read()

        with open(filename_html, 'w', encoding="utf-8") as fp:
            fp.writelines(html)

    # varna 
    png_file  = f"output/{id_name}.png"
    v = Structure(sequence=query_sequence, structure=dotbracket)
    v.update(resolution=10)
    v.savefig(png_file)
    #=======================================
    
    return filename_html, ct_file, dotbracket_file, png_file
#=============================================

#=====================================================
def draw_RNAseq(filename, sequence, folding):

    with open('TEMPLATE.html', 'r') as fp:
        html = fp.read()
        html = html.replace('<SEQUENCE>', f'{sequence}')
        html = html.replace('<FOLDING>', f'{folding}')

    filename_html = f'output/{filename}.html'

    with open(filename_html, 'w', encoding="utf-8") as fp:
        fp.writelines(html)

    return filename_html


#=====================================================