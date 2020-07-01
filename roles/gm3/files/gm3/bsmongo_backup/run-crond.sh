#!/bin/bash

env | egrep '^BACKUP_MINUTES' | cat - /crontab > /etc/cron.d/crontab

chmod 0644 /etc/cron.d/crontab

cron && tail -f /var/log/cron.log