#!/bin/bash

cwd=$(cd "$(dirname "$0")";pwd)

. $cwd/config

bash $cwd/init_replset.sh $cfg_pri_container $cfg_reps
