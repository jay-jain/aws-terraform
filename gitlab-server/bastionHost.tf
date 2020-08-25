resource "aws_instance" "bh" {
  key_name      = "gitlab"
  ami           = var.ami_map[var.region]
  instance_type = "t2.micro"  
  vpc_security_group_ids = [aws_security_group.gitlab.id]  
  subnet_id       = aws_subnet.public-1.id  
  associate_public_ip_address = true

  tags ={
      "Name" = "Bastion Host"
  }
}

# NOTE: This is very unsecure practice and should only be done in testing.
# First SSH into bastion host to check that it works
# Then exit from that SSH session and copy the key over to the bastion host
# Then SSH back into bastion host, now you can SSH into the Gitlab Server which is in a private subnet
# scp -i "KEY_NAME.pem" KEY_NAME.pem ubuntu@DNS_NAME:~