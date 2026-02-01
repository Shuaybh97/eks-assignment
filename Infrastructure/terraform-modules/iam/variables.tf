variable "global_tags" {
  type = map(string)
}

variable "role_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "managed_policies" {
  type = list(string)
}