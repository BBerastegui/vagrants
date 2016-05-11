#!/usr/bin/env bash

alias errecho='>&2 echo'
eth0ip=$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)

sudo apt-get update && sudo apt-get install -y git

git clone https://github.com/infobyte/faraday.git faraday-dev
cd faraday-dev

# Override the installation of QT libraries
sed -i 's/if \[ "\$down" -eq 1 \]; then/if false; then\n   (>\&2 echo "\[!\] OVERRIDED QT LIBRARIES INSTALLATION (downloaded)")/g' ./install.sh
sed -i 's/apt-get -y install python-qt3/(>\&2 echo "\[!\] OVERRIDED QT LIBRARIES INSTALLATION (apt-get)")/g' ./install.sh
sudo ./install.sh

# Run Faraday and kill it to have the config files created (and modified later)
./faraday.py --gui=no-gui &
PID_TO_KILL=$!

# Wait for the config file to be created... and kill the process
sleep 5
kill $PID_TO_KILL

# Change the CouchDB workspace and IP
sed -i 's/<last_workspace>untitled<\/last_workspace>/<last_workspace>workspace<\/last_workspace>/g' ~/.faraday/config/user.xml
sed -i 's/<couch_uri \/>/<couch_uri>http:\/\/'$eth0ip':5984<\/couch_uri>/g' ~/.faraday/config/user.xml

# Make couchdb listen on the IP of eth0
sudo sed -i 's/;bind_address = 127.0.0.1/bind_address = '$eth0ip'/g' /etc/couchdb/local.ini
sudo service couchdb restart

# Run faraday :D
./faraday.py --gui=no-gui &

# Done 
echo 
echo "[i] Now go to http://localhost:5984/reports/_design/reports/index.html"
echo
