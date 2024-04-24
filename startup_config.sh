#!/bin/bash

PGUSER=postgres
PGPASSWORD=webapp
PGNAME=test_webapp_db

#Skip restarts of services during installation
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

#Update general dependancies

sudo apt-get update -y
sudo apt-get upgrade -y

#github install and authentication

sudo apt-get install gh -y
sudo touch /home/mytoken.txt
sudo chmod 777 /home/mytoken.txt
sudo echo "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" >> /home/mytoken.txt
sudo gh auth login --with-token < /home/mytoken.txt
sudo rm /home/mytoken.txt



#Installing PostgresSql and PgAdmin
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt update
sudo apt install postgresql -y

#Linux Firewall rule allow inbound port 5432 for db and port 443+80 for pgadmin

sudo ufw allow 5432/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
sudo ufw allow 22/tcp

#Settting up the Database
#Creating DB user 
sudo usermod -aG sudo $PGUSER

sudo su -l $PGUSER

PGUSER=postgres
PGNAME=test_webapp_db
PGPASSWORD=webapp 

psql -c "ALTER USER postgres PASSWORD '$PGPASSWORD'"

#Accessing PostgresSQL and creating the DB

psql -c "CREATE DATABASE $PGNAME"
psql -c "CREATE USER $PGUSER WITH ENCRYPTED PASSWORD '$PGPASSWORD';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE $PGNAME to $PGUSER;"
psql -c "\c $PGNAME"

exit

#Placeholder for replacing the pg_hba.conf with a custom one

sudo systemctl restart postgresql

#Downloading and installing pgadmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt update 

sudo apt install pgadmin4-web -y

sudo /usr/pgadmin4/bin/setup-web.sh --yes


#Update node.js to latest LTS
sudo su 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

nvm install --lts

exec bash

#Install Sequelize and connect to PostgresSQL DB
npm install --save sequelize

npm install --save pg pg-hstore

#Connecting Sequelize to PostgresSQL

psql

public const { Sequelize } = require('sequelize');
public const sequelize = new Sequelize('postgres://postgres:webapp@test-webapp-db.westeurope.cloudapp.azure.com:5432/test_webapp_db')

