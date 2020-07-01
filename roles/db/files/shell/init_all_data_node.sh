#!/bin/bash

cwd=$(cd "$(dirname "$0")";pwd)

. $cwd/config

bash $cwd/init_replset.sh $cfg_pri_container db1:34011 db2:34012 db3:34013

bash $cwd/init_replset.sh $cfg_pri_container db2:34022 db1:34021 db3:34023

bash $cwd/init_replset.sh $cfg_pri_container db3:34033 db1:34031 db2:34032