#!/bin/bash

set -e
echo Setting up GitLab configuration for Kubernetes for workspace \'$WORKSPACE\'...

GITLAB_PROJECT_ID=<INSERT PROJECT ID HERE>
GITLAB_PERSONAL_TOKEN=<INSERT PERSONAL ACCESS TOKEN HERE>
GITLAB_CLUSTER_BASE_DOMAIN=

REGION=us-east-1
CLUSTER_NAME=my-cluster
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME

# Create mandatory objects for GitLab to work in Kubernetes
# ServiceAccount and (Cluster)RoleBinding
echo Applying Kubernetes objects necessary for GitLab integration...
kubectl apply -f gitlab-admin-service-account.yaml
echo Applying Kubernetes objects necessary for GitLab integration...success.

# kubectl API server
API_SERVER=$(kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}')
echo Kubernetes API endpoint to be added to GitLab: $API_SERVER

# Get secret name
SECRET=$(kubectl get secrets | cut -c1-19 | grep def)

# Get certificate starting with 'default-token...' with:
K8S_CERT=`kubectl get secret $SECRET -o jsonpath="{['data']['ca\.crt']}" | base64 --decode`

# Get token from gitlab-admin service account
KUBE_TOKEN=$(kubectl -n kube-system describe secret \
    $(kubectl -n kube-system get secret | awk '/gitlab-admin/ {print $1}') \
    | awk '/token:/ {print $2}' \
    )

# Add cluster to GitLab
#  --trace-ascii - \
echo Adding cluster to GitLab...
curl -s -o /dev/null \
https://gitlab.com/api/v4/projects/$GITLAB_PROJECT_ID/clusters/user \
-H "Authorization: Bearer $GITLAB_PERSONAL_TOKEN" \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST \
-d "{\"name\":\"$CLUSTER_NAME\",\"platform_kubernetes_attributes\":{\"api_url\":\"$API_SERVER\",\"token\":\"$KUBE_TOKEN\",\"ca_cert\":\"$K8S_CERT\"}}"
echo Adding cluster to GitLab... done.