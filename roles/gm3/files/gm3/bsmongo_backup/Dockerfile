FROM mongo:3.6.12

RUN apt-get update
RUN apt-get -y install cron lua5.3

ADD backup_all_db.sh /backup_all_db.sh

ADD garbage.lua /garbage.lua

ADD is_backup_time.lua /is_backup_time.lua

RUN chmod +x /backup_all_db.sh

ADD crontab /crontab

RUN touch /var/log/cron.log

ADD run-crond.sh /run-crond.sh

RUN chmod +x /run-crond.sh

CMD [ "/run-crond.sh" ]