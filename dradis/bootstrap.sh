#!/usr/bin/env bash

sudo apt-get update

# Redis, NodeJS
apt-get install -y redis-server #nodejs

# Dradis
# wget http://sourceforge.net/projects/dradis/files/dradis/v3.1/dradis-3.1.0.rc2-linux-x86_64.tar.gz
# tar -xzf dradis-3.1.0.rc2-linux-x86_64.tar.gz
# cd dradis-3.1.0.rc2-linux-x86_64/
# ./dradis-webapp  && ./dradis-worker

# Install Ruby 2.2.2
sudo apt-get purge -y ruby1.9.1

sudo apt-get install -y libssl-dev zlib1g-dev libmysqld-dev libsqlite3-dev
sudo apt-get install -y build-essential g++

wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz
tar zxf ruby-2.2.2.tar.gz
cd ruby-2.2.2
./configure && make && sudo make install
sudo gem install bundler

# Install some missing weird gem
sudo gem install ruby-nmap

# Build Dradis from git
cd
sudo apt-get install -y git
# Clone Dradis
git clone https://github.com/dradis/dradis-ce.git
# Clone the rest
git clone https://github.com/dradis/dradis-plugins.git
git clone https://github.com/dradis/dradis-projects.git
cd dradis-ce/
bundle install
./bin/setup

# Run dradis
bundle exec rails server -b 0.0.0.0

echo "[i] Now go to http://localhost:3000 :D"
