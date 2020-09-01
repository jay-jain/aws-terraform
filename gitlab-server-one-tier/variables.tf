variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region in which resources will be deployed"
}

variable "ami_map" {
  type        = map(string)
  description = "Map of AMIs and their regions"
  default = {
    "us-east-1" = "AMI ID GOES HERE"
  }
}
