terraform {
  backend "s3" {
    bucket = "devsecops-group-dev-devsecops-state"  # S3 Bucket Name
    key    = "terraform.tfstate" 			# Path to the S3 object in the given bucket
    region = "us-east-1"
    #dynamodb_table = "great-name-locks-2"
    #encrypt        = true
  }
}

provider "aws"{
  region = "us-east-1"
  profile = "default"
}


resource "aws_s3_bucket" "registry-bucket" {
  bucket = "mys3bucket-asdgasdgasdgasd"
  acl    = "public-read-write"
}
