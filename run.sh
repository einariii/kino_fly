#! /bin/bash

pnpm install
pnpm build

docker run \
    --rm \
    -it \
    -v "$PWD":/kino:rw \
    -e LIVEBOOK_HOME=/kino \
    -e LIVEBOOK_TOKEN_ENABLED=false \
    --env-file .env \
    --network host \
    livebook/livebook:latest

# livebook server ./nbs
