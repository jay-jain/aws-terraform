provider "aws" {
  region = var.region
  profile = "mfa"
}

module "terraform_state_backend" {
  source     = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.26.0"
  namespace  = "devsecops-group"
  stage      = "dev"
  name       = var.name_prefix
  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
  arn_format = var.arn_format
}

# --- Terraform state bucket name
output "bucket_id" {
  description = "The ID of the bucket for the Terraform state"
  value       = module.terraform_state_backend.s3_bucket_id
}

# --- Lock table
output "lock_table_id" {
  description = "The ID of the lock table for the Terraform state"
  value       = module.terraform_state_backend.dynamodb_table_id
}
