#!/bin/bash
#This Argocd set up script assumes you are using minikube and its all set up

#Run these commands to start and update your cluster(context) to minikube
minikube start

kubectl config set-context minikube

#check the status of minikube
minikube status

#Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/install.sh | bash -s v0.25.0

#Install the operator by running the following command:
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
#This Operator will be installed in the "operators" namespace and will be usable from all namespaces in the cluster.

#After install, watch your operator come up using next command.
kubectl get csv -n operators
kubectl get pods -n operators

#Create the argo-controller script and apply it with this command
kubectl apply -f argo-controller.yaml 

#change the service from ClusterIP to NodePort to access argocd on the browser
kubectl edit svc example-argocd-server

#Use the minikube service to generate the argocd url
minikube service example-argocd-server

#list the services and copy the url
minikube service list

#run this command to list the secrets
kubectl get secret

#ArgoCd store the encrypted password here, run the command, copy and decrypt below
kubectl edit secret example-argocd-cluster

#Default username is admin, to get the password run the command below
echo THE ENCRYPTED PASSWORD | base64 -d
