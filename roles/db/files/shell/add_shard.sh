#!/bin/bash

set -x

container=$1
shift 1
shards=$*

mongo_cmd="docker exec $container mongo --quiet --eval "

add_shard() {
    echo "add sharding $1"
    $mongo_cmd "sh.addShard(\"$1\")"
}

for s in $shards; do
    add_shard $s
done

echo "sleep 5 second wait new shards"
sleep 5

$mongo_cmd "sh.status()"