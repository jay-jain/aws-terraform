resource "aws_security_group" "cluster_sg" {
  name        = "Cluster Shared Node Security Group"
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Communication between control plane and worker node group"
}

resource "aws_security_group" "control_plane_sg" {
  name        = "Control Plane Security Group"
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Communication between the control plane and worker nodegroups"
}

resource "aws_security_group_rule" "ingress_cluster_to_node_sg" {  
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = -1
  source_security_group_id = aws_security_group.control_plane_sg.id
  security_group_id        = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "ingress_inter_node_sg" {  
  description              = "Allow nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = -1
  source_security_group_id = aws_security_group.cluster_sg.id
  security_group_id        = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "ingress_node_to_cluster_sg" {  
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = -1
  source_security_group_id = aws_security_group.cluster_sg.id
  security_group_id        = aws_security_group.control_plane_sg.id
}

