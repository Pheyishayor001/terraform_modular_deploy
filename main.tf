resource "aws_vpc" "devops-vpc" {
  cidr_block = "10.20.0.0/16"
}

resource "aws_subnet" "pub-sub" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = var.avz

}

resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = {
    Name = "dev-gw"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.devops-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "pub-rt"
  }
}

resource "aws_route_table_association" "dev-rt-ass" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.pub-rt.id
}




resource "aws_instance" "dev-ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pub-sub.id
  associate_public_ip_address = true
  user_data = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "dev-ec2"
  }
}



resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  vpc_id      = aws_vpc.devops-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

