#!/bin/bash
# To create Jenkins and Snarqube servers for CI

cd app-servers/jenkins-docker || exit
terraform init
terraform fmt
terraform validate && terraform plan >vpcplan

if [ "$?" -eq "0" ]; then
  echo "Your code has been successfully validated"
  echo "You can view the plan file in jenkinsplan"
  sleep 2
else
  echo "The code needs some review!"
  exit
fi
terraform apply -auto-approve

sleep 60 #enough time to copy the jenkins password and accesss it on the browser

# change directory to sonarqube after jenkins-server is created
cd ../sonarqube || exit
# Create the sonarqube server
terraform init
terraform fmt
terraform validate && terraform plan >sonarplan

if [ "$?" -eq "0" ]; then
  echo "The code has been successfully validated"
  echo "You can review the plan file in sonarplan"
  sleep 2
else
  echo "The code needs some review!"
  exit
fi
terraform apply -auto-approve

echo "Jenkins ans Sanarqube servers created successfully"
exit