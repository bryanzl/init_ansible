FROM docker.elastic.co/beats/metricbeat:7.1.1

COPY metricbeat.yml /usr/share/metricbeat/metricbeat.yml

USER root

RUN chown root:metricbeat /usr/share/metricbeat/metricbeat.yml
RUN chmod 600 /usr/share/metricbeat/metricbeat.yml
