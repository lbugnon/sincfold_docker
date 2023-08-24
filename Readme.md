## Build and run locally

    docker build -t sincfold .

    docker run -it --volume="/home/leandro/docker_tmp/:/sincfold:z" sincfold bash