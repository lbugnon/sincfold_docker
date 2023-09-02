## Build and run locally

    docker build -t sincfold .

    docker run -it --volume="./webdemo/:/sincfold:z" sincfold bash

## Run 

    source python_env/bin/activate
    cd sincfold
    python
    from main import main
    structure_draw, dotbracket, fasta_file, ct_file, msg, html_file = main('srp_Bruc.abor._AE017223', 'AACCGGGUCAGGUCCGGAAGGAAGCAGCCCUAA')  
    
    main('5s_Chlorobium-limicola-2', 'CCACGGCGACUAUAUCCCUGGUGUUCACCUCUUCCCAUUCCGAACAGAGUCGUUAAGCCCAGGAGAGCCGAUGGUACUGCUUUAUUGCGGGAGAGUAGGUCGUCGCCGAGU')

    main('16s_C.elegans_domain2', 'GAUAAACCUUUAGCAAUAAACGAAAGUUUAACUAAGCCAUACUAACCCCAGGGUUGGUCAAUUUCGUGCCAGCCACCGCGGUCACACGAUUAACCCAAGCCAAUAGAAAUCGGCGUAAAGAGUGUUUUAGAUCAAUCCCCCAAUAAAGCUAAAAUUCACCUG')


## Register 

    docker login
    docker tag sincfold DOCKER_USERNAME/sincfold 
    docker push DOCKER_USERNAME/sincfold
