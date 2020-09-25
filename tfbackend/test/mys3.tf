provider "aws"{
  region = "us-east-1"
  profile = "default"
}

terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "devsecops-group-dev-terraform-state"
    key            = "terraform.tfstate"
    dynamodb_table = "devsecops-group-dev-terraform-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}



resource "aws_s3_bucket" "registry-bucket" {
  bucket = "mys3bucket-asdgasdgasdgasd"
  acl    = "public-read-write"
}
