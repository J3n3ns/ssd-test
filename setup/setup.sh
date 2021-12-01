#!/bin/bash
## Script to auto-setup nginx reverse proxy with jenkins

sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo docker run hello-world

# Initialize docker network
sudo docker network create jenkins

## Build blueocean plug-in image
# Use the docker file
sudo docker build -t myjenkins-blueocean:1.1 . 

## __Without nginx__
sudo docker run --name jenkins-blueocean-dofd --rm --user root --detach --network jenkins -v /var/run/docker.sock:/var/run/docker.sock -v jenkins-data:/var/jenkins_home -v "$HOME":/home  --publish 8080:8080 myjenkins-blueocean:1.1

## __With nginx__

# docker run \
#   --name jenkins-blueocean-dofd  \
#   --rm \
#   --user root \
#   --detach \
#   --network jenkins \
#   -v "$HOME"/jenkins-test:/var/jenkins_home/workspace/jenkins-test \
#   -v "$HOME"/Team30-AY21:/var/jenkins_home/workspace/SecureGenericForum \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -v jenkins-data:/var/jenkins_home \
#   -e VIRTUAL_HOST=jenkins.justaforum.sitict.net \
#   -e VIRTUAL_PORT=8080 \
#   myjenkins-blueocean:1.1

## Publish nginx reverse proxu
# docker run \
#   --name nginx-rproxy \
#   -d \
#   --rm \
#   --network jenkins \
#   -u root \
#   -p 443:443 \
#   -p 8443:443 \
#   -e HTTPS_PORT=443 \
#   -v /var/run/docker.sock:/tmp/docker.sock:ro \
#   -v "$HOME"/certs:/etc/nginx/certs \
#   jwilder/nginx-proxy:0.9