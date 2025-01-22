resource "aws_vpc" "devops-vpc" {
  cidr_block = var.vpc_cidr
  
}

resource "aws_subnet" "pub-sub" {
  vpc_id            = var.vpc_id
  cidr_block        = var.sub_cidr
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

