variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "eks_cluster_version" {
  type    = string
  default = "1.34"
}
variable "tcp_protocol" {
  type    = string
  default = "tcp"
}
variable "eks_cluster_name" {
  type    = string
  default = "eks-cluster-sh"
}

variable "node_instance_type" {
  type    = string
  default = "t2.medium"
}