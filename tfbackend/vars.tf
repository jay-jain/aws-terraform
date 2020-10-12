# --- Terraform state region
variable "region" {
  description = "AWS default region for API access to Terraform state"
}

# --- Terraform state bucket name prefix
variable "name_prefix" {
  description = "The name prefix of the bucket for the Terraform state. Note that the actual bucket will be named '{prefix}-state' and the DynamoDB locking table '{prefix}-state-lock'."
}

variable "arn_format" {
  type        = string
  default     = "arn:aws"
  description = "ARN format to be used. May be changed to support deployment in GovCloud/China regions."
}