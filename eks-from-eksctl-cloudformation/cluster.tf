
provider "aws" {
  version = "3.4.0"
  region = "us-east-1"
}
/* Will need to write a script that checks availability zones with sufficient capacity and use in vpc.tf code. */


## Check Availability Zones with sufficient capacity:
## aws ec2 describe-reserved-instances-offerings --filters 'Name=scope,Values=Availability Zone' --no-include-marketplace --instance-type m5.large | jq -r '.ReservedInstancesOfferings[].AvailabilityZone' | sort | uniq

resource "aws_eks_cluster" "devops_cluster" {
  name     = "devops-cluster"
  role_arn = "arn:aws:iam::0000000000000:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"

  vpc_config {
    subnet_ids = [aws_subnet.public-1.id, aws_subnet.public-2.id,
                  aws_subnet.private-1.id, aws_subnet.private-2.id]
    security_group_ids = [aws_security_group.control_plane_sg.id]
  }
  version = "1.17"
  #depends_on = [aws_iam_role_policy_attachment.EKSClusterPolicy]
}

output "endpoint" {
  value = aws_eks_cluster.devops_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.devops_cluster.certificate_authority[0].data
}