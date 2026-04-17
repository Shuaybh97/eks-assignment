output "load_balancer_security_group_id" {
  value       = module.networking.load_balancer_sg_id
  description = "Security group ID for the load balancer"
}

output "node_security_group_id" {
  value       = module.eks.node_security_group_id
  description = "Security group ID for EKS worker nodes"
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
