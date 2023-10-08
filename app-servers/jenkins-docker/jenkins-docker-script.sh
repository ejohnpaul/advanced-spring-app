#!/bin/bash
sudo yum update -y 
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y 
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo yum install git -y
sudo yum install docker -y 
sudo usermod -a -G docker ec2-user
sudo usermod -aG docker jenkins
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
sudo sudo cat /var/lib/jenkins/secrets/initialAdminPassword