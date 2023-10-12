#!/bin/bash
# Destroying the resources created
cd app-servers/jenkins-docker
terraform destroy -auto-approve
#sleep 180
cd ../sonarqube
terraform destroy -auto-approve
echo "Resources completely destroyed"