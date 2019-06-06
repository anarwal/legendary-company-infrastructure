#!/bin/sh
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user
mkdir nexus-data
chown -R 200 nexus-data
docker pull sonatype/nexus3
docker run -d -p 8081:8081 -p 8082:8082 -p 8083:8083 --name nexus --user root -v nexus-data:/nexus-data sonatype/nexus3