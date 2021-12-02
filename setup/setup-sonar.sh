#!/bin/bash
## Script to setup sonarqube

sudo docker pull sonarqube
sudo docker run --memory=3g -d --name sonarqube --rm -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest 
