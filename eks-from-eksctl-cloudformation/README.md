
# EKS Terraform Modeled From eksctl CloudFormation

`eksctl` creates two cloudformation stacks:
* One stack for  a ***cluster*** (cluster.json/cluster.yaml)
* One stack for the ***nodegroup*** (nodegroup.json/nodegroup.yaml)

This repo contains terraform code that models that cloudformation.
