## Build and run locally

    docker build -t sincfold .

    docker run -it --volume="/TMP_PATH/:/sincfold:z" sincfold bash