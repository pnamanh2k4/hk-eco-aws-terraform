variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "key_name" {
  type = string
  description = "name of the keypair to use for the instance"
  nullable = false
}
variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to launch. Example: t2.micro"
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
  description = "The subnet ID to launch in"
  nullable = false
}

variable "ec2_security_group_ids" {
  type = list(string)
  nullable = false
}
variable "iam_instance_profile_name" {
  type = string
  description = "The name of the IAM instance profile to associate with the instance"
  nullable = false
}

variable "ecr_image_url" {
  type        = string
  description = "Full ECR image URI (registry/repo:tag) for docker pull/run"
}

