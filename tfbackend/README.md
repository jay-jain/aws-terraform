# See: https://github.com/cloudposse/terraform-aws-tfstate-backend

# Create Backend
## Downloads Terraform modules and providers
terraform init

## Creates S3 Bucket and DynamoDB Lock Table; state is still stored locally
terraform apply -auto-approve

## Copies states from local to S3/DynamoDB
terraform init -force-copy

# Delete Backend

## Change tfbackend.tf to:
 
 module "terraform_state_backend" {
     ...
   terraform_backend_config_file_path = ""
   force_destroy                      = true
 }

 ## Deletes backend.tf
 terraform apply -target module.terraform_state_backend -auto-approve

## Move Terraform state from S3 backend to local files
terraform init -force-copy

## Delete all resources in deployment
terraform destroy

## Examine terraform.tfstate file to make sure it contains no resources