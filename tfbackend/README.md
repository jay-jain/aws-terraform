# Terraform  Backend - S3/DynamoDB
* See:  __https://github.com/cloudposse/terraform-aws-tfstate-backend__
* Read more about S3 Backend [here](https://www.terraform.io/docs/backends/types/s3.html)
# Create Backend
## Downloads Terraform modules and providers
`terraform init`
## Creates S3 Bucket and DynamoDB Lock Table(state is still stored locally)
`terraform apply -auto-approve`
## Copies states from local to S3/DynamoDB 
`terraform init -force-copy`
# Delete Backend
## Change tfbackend.tf to:
```
module "terraform_state_backend" {
	terraform_backend_config_file_path = ""
	force_destroy = true
}
```
## Deletes backend.tf
`terraform apply -target module.terraform_state_backend -auto-approve`

## Move Terraform state from S3 backend to local files
`terraform init -force-copy`
## Delete all resources in deployment
`terraform destroy`

## Examine `terraform.tfstate` file to make sure it contains no resources to verify state has been deleted

# Specifying S3 Backend 
Use the following code snippet in your ```main.tf``` file in every directory that contains terraform code. 
```
terraform {
  backend "s3" {
    bucket = "<BUCKET NAME GOES HERE>"  # S3 Bucket Name
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```
* Make sure to update the bucket name, key, and region parameters as necessary.
* Make sure to import your local terraform state to the remote backend with ```terraform init -force-copy```.
*  Additionally, if you would like to recreate your resources, just delete your local ```.tfstate``` file and re-run ```terraform apply```
