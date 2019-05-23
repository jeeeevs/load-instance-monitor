#!/bin/bash
KIBANA_HOST=kibana:5601
ELASTICSEARCH_HOST=elasticsearch:9200
docker build -t metricbeat .
docker rm -f metricbeat
docker run \
    --network=my-ne \
    --hostname metricbeat \
    --user=root \
    --user=root \
    --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
    --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
    --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
    --volume="/proc:/hostfs/proc:ro" \
    --volume="/:/hostfs:ro" \
    metricbeat \
    setup -E setup.kibana.host=$KIBANA_HOST \
    -E output.elasticsearch.hosts=[$ELASTICSEARCH_HOST]

docker run \
    -d \
    --network=my-ne \
    --name=metricbeat \
    --hostname metricbeat \
    --user=root \
    --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
    --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
    --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
    --volume="/proc:/hostfs/proc:ro" \
    --volume="/:/hostfs:ro" \
    metricbeat metricbeat -e \
    -system.hostfs=/hostfs \
    -E output.elasticsearch.hosts=[$ELASTICSEARCH_HOST] \
    -E setup.kibana.host=$KIBANA_HOST 