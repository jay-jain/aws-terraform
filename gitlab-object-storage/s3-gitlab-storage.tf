## Creates S3 buckets for Gitlab Server object storage

provider "aws" {
  region  = "us-east-1"
}


resource "aws_s3_bucket" "registry-bucket" {
  bucket = "gitlab-container-registry-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "artifacts-bucket" {
  bucket = "gitlab-artifacts-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "diffs-bucket" {
  bucket = "gitlab-diffs-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "lfs-bucket" {
  bucket = "gitlab-lfs-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "uploads-bucket" {
  bucket = "gitlab-uploads-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "packages-bucket" {
  bucket = "gitlab-packages-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "proxy-bucket" {
  bucket = "gitlab-proxy-123"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "gitlab-terraform-123"
  acl    = "public-read-write"
}