variable "environment" {
  type        = string
  description = "Environment name (e.g., sandbox, dev, prod)"
}

variable "region" {
  type        = string
  description = "AWS region for resource deployment"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "instance_types" {
  type        = string
  description = "EC2 instance type for EKS node group"
}

variable "alb_controller_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace for AWS Load Balancer Controller"
}

variable "alb_controller_service_account" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Service account name for AWS Load Balancer Controller"
}

variable "traefik_namespace" {
  type        = string
  default     = "traefik"
  description = "Kubernetes namespace for Traefik ingress controller"
}

variable "vpc_config" {
  type = object({
    cidr_block              = optional(string, "10.0.0.0/16")
    enable_dns_hostnames    = optional(bool, true)
    enable_dns_support      = optional(bool, true)
    public_subnet_cidrs     = optional(list(string), [])
    private_subnet_cidrs    = optional(list(string), [])
    public_subnet_count     = optional(number, 2)
    private_subnet_count    = optional(number, 2)
    public_subnet_mask      = optional(number, 24)
    private_subnet_mask     = optional(number, 24)
    public_subnet_offset    = optional(number, 0)
    private_subnet_offset   = optional(number, 10)
    map_public_ip_on_launch = optional(bool, true)
  })
  description = "VPC configuration map. Subnet CIDRs can be explicitly provided or dynamically generated. Subnet masks determine the size of generated subnets."
}
