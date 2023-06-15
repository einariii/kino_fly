#! /usr/bin/fish

docker run \
    --rm \
    -it \
    -v "$PWD":/kino_fly:rw \
    -e LIVEBOOK_HOME=/kino_fly \
    # --env-file .env \
    --network host \
    livebook/livebook:latest
