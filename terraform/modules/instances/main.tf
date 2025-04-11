resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name      = var.key_name
  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3"
  }
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}