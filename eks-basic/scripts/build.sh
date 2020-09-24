#!/bin/bash
set -e;

function deploy {
    echo "----- Deploying App -----";
    # Configure TLS key and cert for Ingress
    if [[ ! -f tls.crt || ! -f tls.key ]]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout tls.key -out tls.crt -subj "/CN=<SUBDOMAIN>.<DOMAIN>"
    fi
    export TLS_CRT=$(cat tls.crt | base64 -w 0) TLS_KEY=$(cat tls.key | base64 -w 0);
    export NAMESPACE=fleact

    envsubst < templates/kube_up_template.yaml > kube_up.yaml;

    kubectl apply -f kube_up.yaml;
}

function config_cluster {
    echo "----- Configuring Cluster -----";
    # Deploy metrics server
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml

    # Deploy dashboard
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

    # Cluster Node Autoscaling
    export CLUSTER_NAME=test-eks-zE3gdASZ
    envsubst < templates/node_autoscaler_template.yaml > node_autoscaler.yaml;
    kubectl apply -f node_autoscaler.yaml;

    # Nginx Ingress Controller
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/aws/deploy.yaml;
    echo;

    # Wait a few minutes for Ingress Controller to become accessible
    echo "Waiting a few moments for Nginx Ingress Controller availability...";
    sleep 5m;
}

config_cluster;
deploy;
