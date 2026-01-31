variable "vpc_cidr" {
  type = string

}


variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_sg_desc" {
  type = string

}

variable "eks_nodes_sg_name" {
  type = string

}

variable "eks_nodes_sg_desc" {
  type = string

}

variable "from_port" {
  type = number

}

variable "to_port" {
  type = number

}

variable "all_protocols" {
  type = string
}

variable "cidr_blocks" {
  type = list(string)

}

variable "sg_rule_type" {
  type = string

}

variable "sg_rule_from_port" {
  type = number

}

variable "sg_rule_to_port" {
  type = number

}

variable "tcp_protocol" {
  type = string

}

variable "eks_cluster_name" {
  type = string

}

variable "eks_cluster_version" {
  type = string

}

variable "eks_node_name" {
  type = string

}

variable "instance_types" {
  type = string
}

variable "disk_size" {
  type = number

}

variable "desired_size" {
  type = number

}

variable "min_size" {
  type = number

}

variable "max_size" {
  type = number

}

variable "client_id_list" {
  type = list(string)

}

variable "cert_manager_role_name" {
  type = string

}

variable "attach_cert_manager_policy" {
  type = bool

}

variable "cert_manager_hosted_zone_arns" {
  type = list(string)

}

variable "cert_manager_namespace" {
  type = list(string)

}

variable "external_dns_role_name" {
  type = string

}

variable "attach_external_dns_policy" {
  type = bool

}

variable "external_dns_hosted_zone_arns" {
  type = list(string)

}

variable "external_dns_namespace" {
  type = list(string)

}