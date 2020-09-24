#!/bin/bash

# Deploy metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml

# Deploy dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

# Go to : http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# You will need token to login to dashboard:

#KUBE_TOKEN=$(kubectl -n kube-system describe secret \
#    $(kubectl -n kube-system get secret | awk '/gitlab-admin/ {print $1}') \
#    | awk '/token:/ {print $2}' \
#    )

export CLUSTER_NAME=''
envsubst < templates/node_autoscaler_template.yaml > node_autoscaler.yaml;
kubectl apply -f node_autoscaler.yaml;

# Deploy nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/aws/deploy.yaml;