#!/bin/bash

set -x

container=$1

pri_node=$2

shift 2
sec_nodes=$*

all_nodes="$pri_node $sec_nodes"

init_replset() {
    echo "init replset"
    mongo_cmd="docker exec $container mongo --quiet $pri_node --eval "
	$mongo_cmd "var result = rs.initiate()"
    echo "reconfig replset: $pri_node"
	$mongo_cmd "var cfg = rs.conf(); cfg.members = [{ _id: 0, host:\"${pri_node}\", priority: 10 }]; rs.reconfig(cfg, { force: true })"
    for node in $sec_nodes; do
        echo "add $node to replset"
        $mongo_cmd "rs.add({host: \"${node}\", priority: 1})"
    done
}

init() {
    init_replset
}

init
