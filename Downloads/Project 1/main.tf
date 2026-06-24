terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  backend "s3" {
    bucket         = "hk-eco-terraform-state-singapore-bucket"
    key            = "hk-eco-terraform"
    region         = "ap-southeast-1"
    dynamodb_table = "HK-ECO-terraform-state"
  }
}
provider "aws" {
  region = var.region
}

module "networking" {
  source              = "./modules/networking"
  region              = var.region
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
  cidr_block          = var.cidr_block
  public_subnet_ips   = var.public_subnet_ips
  private_subnet_ips  = var.private_subnet_ips
}
module "security" {
  source = "./modules/security"
  region = var.region
  vpc_id = module.networking.vpc_id
}

resource "aws_key_pair" "HK-ECO-keypair" {
  key_name   = "HK-ECO-keypair"
  public_key = file(var.keypair_path)
}
module "compute" {
  source                      = "./modules/compute"
  region                      = var.region
  image_id                    = var.amis[var.region]
  key_name                    = aws_key_pair.HK-ECO-keypair.key_name
  instance_type               = var.instance_type
  ec2_security_group_ids      = [module.security.public_security_group_id]
  subnet_id                   = module.networking.public_subnet_ids[0]
  iam_instance_profile_name   = aws_iam_instance_profile.ec2_profile.name
  ecr_image_url               = var.ecr_image_url
}

resource "aws_ecr_repository" "hk_eco_repo" {
  name                 = "hk-eco-web-app" 
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true 
  }
}



resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2-ecr-role-auto"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ecr-profile-auto"
  role = aws_iam_role.ec2_ecr_role.name
}