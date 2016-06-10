#!/bin/sh
set -x

#Ustawienie bazy danych
sudo -u postgres psql -f src/main/resources/physicalmodel.sql

#Pobranie zależności i wygenerowanie pliku .war projektu
mvn package

#Dołączenie do tomcata aplikacji
sudo cp target/project.war /var/lib/tomcat8/webapps/

#Uruchomienie tomcata
sudo service tomcat8 start
