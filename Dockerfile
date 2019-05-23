FROM docker.elastic.co/beats/metricbeat:7.1.0
COPY metricbeat.docker.yml /usr/share/metricbeat/metricbeat.yml
USER root
RUN chown root:metricbeat /usr/share/metricbeat/metricbeat.yml
USER metricbeat