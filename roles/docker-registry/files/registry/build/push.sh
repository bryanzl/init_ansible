#!/bin/bash

. prepare.sh

pushd $D > /dev/null

image_name=`cat image_name`
docker push ${DOCKER_REGISTRY}/${image_name}

popd > /dev/null