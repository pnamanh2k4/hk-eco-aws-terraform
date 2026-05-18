resource "aws_instance" "demo-instance" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name
  user_data_replace_on_change = true
  tags = {
    Name = "HK-ECO-demo-instance"
  }
}  
resource "aws_eip" "HK-ECO-eip" {
  instance = aws_instance.demo-instance.id
}

