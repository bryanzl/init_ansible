#!/bin/bash

cwd=$(cd "$(dirname "$0")";pwd)

. $cwd/config

bash $cwd/add_shard.sh bsmongo_s $data_shards