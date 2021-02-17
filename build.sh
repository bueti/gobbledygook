#!/usr/bin/env bash

set +e

docker build .
image_id=$(docker images|head -2 | grep none | awk '{print $3}')
docker tag ${image_id} bueti/gobbledygook:latest
docker save -o gobbledygook-1.0.tar bueti/gobbledygook:latest
gzip -f gobbledygook-1.0.tar
scp gobbledygook-1.0.tar.gz aio:
rm -f gobbledygook-1.0.tar.gz
