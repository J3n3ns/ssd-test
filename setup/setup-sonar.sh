#!/bin/bash
## Script to setup sonarqube

sudo docker pull sonarqube
sudo docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest 
