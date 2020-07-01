FROM node:10-stretch
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
RUN mkdir -p /app/etc/supervisor/
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /app/log

#
# cleanup
#
RUN apt-get autoremove --purge -y && apt-get clean
RUN rm -rf /tmp/*

VOLUME /app

ENTRYPOINT [ "/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf" ]