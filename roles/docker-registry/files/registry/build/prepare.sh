D=$1

if [ "_" == "_"$D ]; then
  echo need docker build dir
  exit 1
fi

if [ ! -d $D ]; then
  echo no such docker build dir
  exit 1
fi

set -o allexport
source /home/gs/registry/config/env
set +o allexport
