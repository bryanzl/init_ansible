#!/bin/bash

NOW=`TZ="UTC-8:00" date +%Y-%m-%d_%H%M%S`

lua5.3 /is_backup_time.lua ${BACKUP_MINUTES}

if [ $? -ne 0 ]; then
  # echo "==> not now: $NOW"
  exit 0
fi

echo "==> start backup all mongodb database, TS=$NOW {{{ "

rm -rf /backup/dbtmp

mongodump --gzip --out=/backup/dbtmp --host=bsmongo --readPreference=secondary

if [ ! -d /backup/dbdump ]; then
    mkdir /backup/dbdump
fi

mkdir /backup/dbdump/${NOW}

for f in `ls -1 /backup/dbtmp`; do
  echo "  ==> tar db: $f"
  tar cf /backup/dbdump/${NOW}/$f.tar /backup/dbtmp/$f
done

for x in `ls -1 /backup/dbdump | lua5.3 /garbage.lua`; do
  gc="/backup/dbdump/$x"
  echo "  ==> gc: $gc"
  rm -rf $gc
done

echo "==> }}} done"