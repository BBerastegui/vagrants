#!/usr/bin/env bash

web2py_PASS="1234"

sudo apt-get update

# Gen locale
sudo locale-gen UTF-8

# Core libraries
sudo apt-get install -y python-pip git-core python-lxml python-tornado python-beautifulsoup python-dev python-yaml
sudo pip install msgpack-python

# Database and libraries
sudo apt-get install -y postgresql python-psycopg2

cd /opt
sudo git clone --recursive https://github.com/web2py/web2py.git web2py

# Don't blame me on this please :'(
sudo sed -i 's/local\s\+all\s\+all\s\+peer/local all all md5/g' /etc/postgresql/*/main/pg_hba.conf

# sudo -u postgres createuser -SleEPRD kvasir 
sudo -u postgres bash -c "psql -c \"CREATE ROLE kvasir PASSWORD 'kvasir' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""

sudo -u postgres createdb kvasir -O kvasir

cd
sudo openssl genrsa -out server.key 2048
sudo openssl req -new -subj "/C=ES/O=Hashicorp/CN=Vagrant" -key server.key -out server.csr
sudo openssl x509 -req -days 1095 -in server.csr -signkey server.key -out server.crt

# sudo ln -s /etc/ssl/private/server.key /var/lib/postgresql/*/main/server.key
# sudo ln -s /etc/ssl/certs/server.crt /var/lib/postgresql/*/main/server.crt

# Install Kvasir
cd /opt
sudo git clone https://github.com/KvasirSecurity/Kvasir.git Kvasir
cd Kvasir
sudo cp kvasir.yaml.sample kvasir.yaml

sudo sed -i 's/uri: postgres:\/\/kvuser:kvpass@localhost:5432\/kvasir/uri: postgres:\/\/kvasir:kvasir@localhost:5432\/kvasir/g' kvasir.yaml

cd /opt/web2py/applications
sudo ln -s /opt/Kvasir kvasir

# Run server
cd /opt/web2py
python web2py.py -K kvasir &
sudo python web2py.py -c ~/server.crt -k ~/server.key -p 8443 -i 0.0.0.0 --minthreads=40 -a $web2py_PASS

