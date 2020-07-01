FROM debian:stretch
LABEL AUTHOR hongying<"hongying@gzshuangzixing.com">

#
# system
#
COPY system/etc /tmp/system/etc
COPY system/script /tmp/system/script
RUN chmod -R 755 /tmp/system/script/*

RUN /tmp/system/script/00-apt-update
RUN /tmp/system/script/01-setup

ADD python/get-pip.py /tmp/
RUN python /tmp/get-pip.py

RUN pip install yq

RUN mkdir -p /app

RUN mkdir -p /game/app

#
# filebeat
#
ADD beat/filebeat-7.1.1-linux-x86_64.tar.gz /tmp/
RUN mv /tmp/filebeat-7.1.1-linux-x86_64 /app/filebeat

#
# metricbeat
#
ADD beat/metricbeat-7.1.1-linux-x86_64.tar.gz /tmp/
RUN mv /tmp/metricbeat-7.1.1-linux-x86_64 /app/metricbeat


#
# sshd config
#
RUN mkdir -p /var/run/sshd
ADD system/ssh/sshd_config /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh
ADD system/ssh/authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

#
# supervisor config
#
RUN pip install supervisor
ADD supervisor/supervisord.conf /etc/

RUN mkdir -p /game/log/sshd/

RUN mkdir -p /game/etc/supervisor/
RUN mkdir -p /game/log/supervisor/

RUN mkdir -p /game/log/filebeat/
RUN mkdir -p /game/etc/filebeat


RUN mkdir -p /game/log/metricbeat/
RUN mkdir -p /game/etc/metricbeat

#
# game server
#
RUN mkdir -p /game/server/var
RUN mkdir -p /game/server/log
RUN mkdir -p /game/server/cache

RUN mkdir -p /game/var/

#
# cleanup
#
RUN apt-get autoremove --purge -y && apt-get clean
RUN rm -rf /tmp/*

VOLUME /game

ENTRYPOINT [ "/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf" ]