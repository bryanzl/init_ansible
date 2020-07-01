#!/bin/bash

. prepare.sh

pushd $D > /dev/null

image_name=`cat image_name`
docker build -t ${DOCKER_REGISTRY}/${image_name} --compress .

popd > /dev/null