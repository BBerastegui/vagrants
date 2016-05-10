#!/usr/bin/env bash

# Install Oracle JDK
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update

# For silent java installation
echo debconf shared/accepted-oracle-license-v1-1 select true | \
sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
sudo debconf-set-selections

sudo apt-get install -y oracle-java8-installer

sudo /bin/bash -c 'echo -n 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment'
source /etc/environment

# Elasticsearch repo
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list
echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list

apt-get update

sudo apt-get update
sudo apt-get install -y elasticsearch logstash kibana

# Run services
sudo service elasticsearch restart
sudo service kibana restart

# Auto startup
sudo update-rc.d elasticsearch defaults 95 10
sudo update-rc.d kibana defaults 95 10


