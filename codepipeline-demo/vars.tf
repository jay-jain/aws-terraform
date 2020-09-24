variable "AWS_REGION" {
  default = "us-east-1"
}

variable "github_org" {
  type = string
}

variable "repo" {
  type = string
}

variable "github_token" {
  type = string
}

variable "ecr_repo_name" {
  type = string
}