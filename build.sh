#!/usr/bin/env bash

set +e

version=$1
docker build .
image_id=$(docker images|head -2 | grep none | awk '{print $3}')
docker tag ${image_id} bueti/gobbledygook:${version}
docker save -o gobbledygook-${version}.tar bueti/gobbledygook:${version}
gzip -f gobbledygook-${version}.tar
scp gobbledygook-${version}.tar.gz aio:
rm -f gobbledygook-${version}.tar.gz
