#!/bin/bash

PGUSER=postgres
PGPASSWORD=webapp
PGNAME=test_webapp_db


#Skip restarts of services during installation
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sleep 1
#Update general dependancies

sudo apt-get update -y && sudo apt-get upgrade -y

#github install and authentication

sudo apt-get install gh -y 
sleep 2
sudo touch /home/mytoken.txt && sudo chmod 777 /home/mytoken.txt && sudo echo "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" >> /home/mytoken.txt && sudo gh auth login --with-token < /home/mytoken.txt && sudo rm /home/mytoken.txt
sleep 1
cd /home/ && sudo gh repo clone PMprovectus/test-webapp-db
sleep 1
sudo mv /home/test-webapp-db/pg_hba.conf /etc/postgresql/16/main/pg_hba.conf && sudo mv /home/test-webapp-db/postgresql.conf /etc/postgresql/16/main/postgresql.conf

#Installing PostgresSql and PgAdmin
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sleep 1
sudo apt update && sudo apt install postgresql -y

#Linux Firewall rule allow inbound port 5432 for db and port 443+80 for pgadmin

sudo ufw allow 5432/tcp && sudo ufw allow 443/tcp && sudo ufw allow 80/tcp && sudo ufw allow 22/tcp

#Settting up the Database
#Creating DB user and logging in
sudo usermod -aG sudo $PGUSER && sudo su -l $PGUSER
sleep 1
PGUSER=postgres
PGNAME=test_webapp_db
PGPASSWORD=webapp 
sleep 1
psql -c "ALTER USER postgres PASSWORD '$PGPASSWORD'"
sleep 1
#Accessing PostgresSQL and creating the DB

psql -c "CREATE DATABASE $PGNAME" && psql -c "CREATE USER $PGUSER WITH ENCRYPTED PASSWORD '$PGPASSWORD';" && psql -c "GRANT ALL PRIVILEGES ON DATABASE $PGNAME to $PGUSER;" && psql -c "\c $PGNAME" && exit
sleep 1
#Placeholder for replacing the pg_hba.conf with a custom one

sudo systemctl restart postgresql

#Downloading and installing pgadmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg && sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sleep 1
sudo apt update && sudo apt install pgadmin4-web -y && sudo /usr/pgadmin4/bin/setup-web.sh --yes


#Update node.js to latest LTS
sudo su && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && nvm install --lts && exec bash
sleep 1
#Install Sequelize and connect to PostgresSQL DB
npm install --save sequelize && npm install --save pg pg-hstore
sleep 1
#Connecting Sequelize to PostgresSQL

node /home/test-webapp-db/connect_sequelize.js
sleep 1
echo "Passt!"