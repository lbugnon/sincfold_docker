# -*- coding: utf-8 -*-
import subprocess
import shutil
import os 
import subprocess as sp
import shutil 
import os
from torch.utils.data import DataLoader
from sincfold.utils import ct2dot, write_ct, draw_structure
from sincfold.embeddings import NT_DICT
from sincfold.dataset import SeqDataset, pad_batch
from sincfold.model import sincfold
from sincfold.utils import VARNA_PATH

def main(id_name, sequence):
    sequence = sequence.upper().strip()
    shutil.rmtree("output", ignore_errors=True)
    os.mkdir("output")
    ct_file = f"output/{id_name}.ct"
    structure_draw = f"output/{id_name}.png"
    fasta_file = f"output/{id_name}.fasta"
    html_file = f"output/{id_name}.html"
    msg = "Completed."
    
    config= {"device": "cpu", "batch_size": 4,  "use_restrictions": False, 
            "max_len": 512, "verbose": False, "cache_path": None}

    resolution = 1
    if len(sequence)>100:
        resolution = 10
    elif len(sequence)>50:
        resolution = 5
    
    nt_set = set([i for item  in list(NT_DICT.values()) for i in item] + list(NT_DICT.keys()))
    if set(sequence).issubset(nt_set):
        pred_file = f"input.csv"
        with open(pred_file, "w") as f:
            f.write("id,sequence\n")
            f.write(f"{id_name},{sequence}\n")
        
        pred_loader = DataLoader(
            SeqDataset(pred_file, max_len=config["max_len"], for_prediction=True, use_restrictions=config["use_restrictions"]),
            batch_size=config["batch_size"],
            shuffle=False,
            num_workers=0,
            collate_fn=pad_batch,
        )
        
        net = sincfold(weights="weights.pmt", **config)
        predictions = net.pred(pred_loader)

        item = predictions.iloc[0]
        write_ct(ct_file, item.id, item.sequence, item.base_pairs)
        try:
            dotbracket = ct2dot(ct_file)
        except:
            dotbracket = ""
        if dotbracket:
            
            sp.run(f'java -Xmx64m -cp {VARNA_PATH} fr.orsay.lri.varna.applications.VARNAcmd -sequenceDBN {sequence} -structureDBN "{dotbracket}" -o  {structure_draw} -resolution {resolution}', shell=True)
            
            with open(fasta_file, "w") as f:
                f.write(f">{id_name}\n{sequence}\n{dotbracket}")

            max_lenght = 256
            if len(sequence) <= max_lenght:
                html_file = draw_RNAseq(id_name, sequence, dotbracket)
            else:
                html_file = f'{id_name}.html'

                with open('TEMPLATE.html', 'r', encoding="utf-8") as fp:
                    html = fp.read()

                with open(html_file, 'w', encoding="utf-8") as fp:
                    fp.writelines(html)

        else:
            msg = f"CT conversion failed (check CT file)"
            structure_draw = ""
            fasta_file = ""
                    
    else:
        msg = f"Invalid sequence (only {nt_set} are allowed)"
        dotbracket = ""
        fasta_file = ""
        ct_file = ""

    return structure_draw, dotbracket, fasta_file, ct_file, msg, html_file 

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
