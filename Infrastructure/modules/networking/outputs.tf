output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet[*].id]
}

output "private_subnet_ids" {
  value = [aws_subnet.public_subnet[*].id]
}