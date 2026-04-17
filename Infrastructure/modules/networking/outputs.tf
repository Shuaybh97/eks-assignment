output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "load_balancer_sg_id" {
  value       = aws_security_group.load_balancer_sg.id
  description = "Security group ID for the load balancer"
}