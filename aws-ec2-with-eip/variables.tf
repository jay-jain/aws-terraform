variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region in which the EC2 instance will run"
}

variable "ami_map" {
  type = map(string)
  description = "Map of AMIs and their regions"
  default = {
    "us-east-1" = "ami-09d95fab7fff3776c"
  }
}

variable "ssh_priv_key_path" {
  type        = string
  description = "Path to local ssh private key for ssh authentication"
}

variable "ssh_pub_key_path" {
  type        = string
  description = "Path to local ssh public key for ssh authentication"
}
