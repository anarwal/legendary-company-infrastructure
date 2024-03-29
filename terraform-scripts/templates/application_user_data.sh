#!/bin/sh
sudo apt-get update
sudo apt-get install -y sysbench
sudo apt-get install -y mysql-client-core-5.7
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install docker-ce -y
sudo usermod -a -G docker ubuntu
