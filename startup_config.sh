#!/bin/bash

PGUSER=postgres
PGPASSWORD=webapp
PGNAME=test-webapp-db

#Update general dependancies

sudo apt-get update && apt-get upgrade

#Installing PostgresSql and PgAdmin
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt install postgresql

#Linux Firewall rule allow inbound port 5432 for db and port 443+80 for pgadmin

sudo ufw allow 5432/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp

#Settting up the Database
#Creating DB user 
sudo usermod -aG sudo $PGUSER

PGPASSWORD=webapp psql -u $PGUSER $PGNAME

#Accessing PostgresSQL and creating the DB

sudo su -l $PGUSER
psql -c "CREATE DATABASE $PGNAME"
psql -c "CREATE USER $PGUSER WITH ENCRYPTED PASSWORD '$PGPASSWORD'"
psql -c "GRANT ALL PRIVILEGES ON DATABASE mytestdb to $PGUSER"
psql -c "\c $PGNAME"

#Placeholder for replacing the pg_hba.conf with a custom one

sudo systemctl restart postgresql
#Downloading and installing pgadmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
udo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

#Setting up pgadmin
sudo apt install pgadmin4-web
sleep 5



#Update node.js to latest LTS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install --lts

#killall -SIGQUIT gnome-shell

#Install Sequelize and connect to PostgresSQL DB
npm install --save sequelize
npm install --save pg pg-hstore

#Connecting Sequelize to PostgresSQL
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('postgres://$PGUSER:$PGPASSWORD@52.178.38.54:5432/$PGNAME')