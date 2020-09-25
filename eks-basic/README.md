
  

# EKS From Scratch

  

**This repo is based on [@Septem151](https://github.com/Septem151/)'s [Fleact Repo](https://github.com/Septem151/Fleact/).**

  

## Deployment Steps

1. Run ```terraform apply``` and deploy EKS cluster

2. Run `attach-eks-gitlab.sh` script which will add the EKS Cluster to GitLab

3. Run ```config-cluster.sh``` which deploys metrics server, dashboard, generates `node_autoscaler.yaml`, applies `node_autoscaler.yaml`, and deploys nginx ingress controller

4. Run `deploy.sh` which generates TLS certificate & generates and applies `kube_up.yaml`

 **Remember to replace ECR references as well as SUBDOMAIN and DOMAIN names in the `kube_up_template.yaml`.**

  

## To Do

* Write `.gitlab-ci.yml` scripts for build process

* Automate `terraform import` of the load balancer created by the nginx-ingress-controller

* Figure out why there are unhealthy targets in the Target Groups (Hint: try using only one node group)

* Configure an ACM TLS Certificate on the NLB

* Use Vault to Store Credentials
