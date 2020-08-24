# --- Terraform state provider credentials
# variable "access_key" {
#   description = "Access API key for the Terraform state"
# }

# variable "secret_key" {
#   description = "Secret key for the Terraform state"
# }

# --- Terraform state region
variable "region" {
  description = "AWS default region for API access to Terraform state"
}

# --- Terraform state bucket name prefix
variable "name_prefix" {
  description = "The name prefix of the bucket for the Terraform state. Note that the actual bucket will be named '{prefix}-state' and the DynamoDB locking table '{prefix}-state-lock'."
}

provider "aws" {
  #   access_key    = var.access_key
  #   secret_key    = var.secret_key
  region = var.region
}

# Backend Terraform code for the AWS provider
module "terraform-state-backend" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.14.0"
  prevent_unencrypted_uploads = false
  force_destroy               = true
  name                        = var.name_prefix
  region                      = var.region
}

# --- Terraform state bucket name
output "bucket_id" {
  description = "The ID of the bucket for the Terraform state"
  value       = module.terraform-state-backend.s3_bucket_id
}

# --- Lock table
output "lock_table_id" {
  description = "The ID of the lock table for the Terraform state"
  value       = module.terraform-state-backend.dynamodb_table_id
}
