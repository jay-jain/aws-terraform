### NOTE: For this to work, the AWS credentials must have access to 
### the iam:PassRole. 
### See: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html#roles-usingrole-ec2instance-permissions


resource "aws_iam_role" "S3Role" {
  name = "EC2-S3-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  name = "GitLab-Server-S3-Access"
  role = aws_iam_role.S3Role.name
}

resource "aws_iam_role_policy" "S3FullAcess" {
  name = "S3FullAccess"
  role = aws_iam_role.S3Role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}