resource "aws_instance" "demo-instance" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name
  user_data = <<-EOT
    #!/bin/bash
    set -e
    exec > /var/log/hk-eco-userdata.log 2>&1

    REGION="${var.region}"
    ECR_IMAGE="${var.ecr_image_url}"
    ECR_REGISTRY="${split("/", var.ecr_image_url)[0]}"

    yum update -y
    yum install -y docker awscli
    systemctl enable docker
    systemctl start docker

    sleep 10
    aws ecr get-login-password --region "$${REGION}" | docker login --username AWS --password-stdin "$${ECR_REGISTRY}"
    docker pull "$${ECR_IMAGE}"
    docker rm -f hk-eco-web || true
    docker run -d --name hk-eco-web -p 80:80 --restart unless-stopped "$${ECR_IMAGE}"
  EOT
  user_data_replace_on_change = true
  tags = {
    Name = "HK-ECO-demo-instance"
  }
}  

resource "aws_eip" "HK-ECO-eip" {
  instance = aws_instance.demo-instance.id
}

