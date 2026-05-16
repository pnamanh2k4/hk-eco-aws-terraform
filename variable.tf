variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "availability_zone_1" {
  type = string
  nullable = false
}
variable "availability_zone_2" {
  type = string
  nullable = false
}
variable "cidr_block" {
  type = string
  nullable = false
}
variable "public_subnet_ips" {
  type = list(string)
  nullable = false
  
}
variable "private_subnet_ips" {
  type = list(string)
  nullable = false
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to launch. Example: t2.micro"
  default = "t3.micro"
}
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" : "ami-0e4b5d31e60aa0acd"
    "ap-northeast-1" : "ami-0dfa284c9d7b2adad"
  }
}
variable "keypair_path" {
  type = string
  default = "./keypair/HK-ECO-key.pub"
}

variable "ecr_image_url" {
  description = "From Image to ECR"
  type        = string
  default     = "541692464957.dkr.ecr.ap-southeast-1.amazonaws.com/hk-eco-web-app:v1.0.0"
}