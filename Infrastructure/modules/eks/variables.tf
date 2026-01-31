variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_cluster_name" {
  type = string
}

variable "instance_types" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}