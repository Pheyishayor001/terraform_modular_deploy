output "subnet_id" {
    value = aws_subnet.pub-sub.id
}

output "vpc_id" {
    value = aws_vpc.devops-vpc.id
}