#!/bin/bash


echo "----- Deploying App -----";
# Configure TLS key and cert for Ingress
if [[ ! -f tls.crt || ! -f tls.key ]]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout tls.key -out tls.crt -subj "/CN=<SUBDOMAIN>.<DOMAIN>.org"
fi
export TLS_CRT=$(cat tls.crt | base64 -w 0) TLS_KEY=$(cat tls.key | base64 -w 0);
export NAMESPACE=fleact

envsubst < templates/kube_up_template.yaml > kube_up.yaml;

kubectl apply -f kube_up.yaml;