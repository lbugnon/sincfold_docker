## Build and run locally

    docker build -t sincfold .

    docker run -it --volume="/webdemo/:/sincfold:z" sincfold bash

## Run 

    source python_env/bin/activate
    cd sincfold
    python
    from main import main
    html, ctfile, fastafile = main('CGAACCGUGUCAGGUCCGGAAGGAAGCAGCACUAAG', 'srp_Carb.hydr._CP000141')
