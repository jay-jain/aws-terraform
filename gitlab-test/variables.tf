variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region in which resources will be deployed"
}

variable "ami_map" {
  type        = map(string)
  description = "Map of AMIs and their regions"
  default = {
    "us-east-1" = "ami-027ae9dbb07c9dc48"
  }
}

variable "dns_zone_name" {
  description = "The name of the DNS zone on Route53 (example.com), to create records in for gitlab"
  type        = string
}

variable "gitlab_name" {
  description = "To generate the DNS record for gitlab, prefix the zone"
  default     = "gitlab"
  type        = string
}

variable "hosted_zone_id" {
  type = string
}