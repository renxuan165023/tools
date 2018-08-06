#!/bin/bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat << EOF > /etc/yum.repos.d/elasticsearch.repo
[elastic-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install filebeat metricbeat -y
systemctl enable filebeat
cat << EOF > /etc/filebeat/filebeat.yml.1
filebeat.inputs:
- type: log
  paths:
    - []
  fields:
    project_name: ""
  fields_under_root: true

output.elasticsearch:
  hosts: ["https://10.1.48.7:9200"]
  index: "filebeat-da-aqu-%{+yyyy.MM.dd}"
  username: "logstash"
  password: "logstash"
  ssl.verification_mode: none

setup.template.name: "filebeat-da-aqu"
setup.template.pattern: "filebeat-da-aqu-*"
EOF
