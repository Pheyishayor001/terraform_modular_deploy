resource "aws_instance" "dev-ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data = file("userdata.sh")
  vpc_security_group_ids = [var.security_id]
  tags = {
    Name = "dev-ec2"
  }
}