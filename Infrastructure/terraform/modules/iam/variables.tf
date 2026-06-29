variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "service_name" {
  type        = string
  description = "AWS service that will assume this role (e.g., eks.amazonaws.com, ec2.amazonaws.com)"
  default     = ""
}

variable "managed_policies" {
  type        = list(string)
  description = "List of AWS managed policy names to attach to the role"
  default     = []
}

variable "global_tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "use_irsa" {
  type        = bool
  description = "Whether this role is for IRSA (IAM Roles for Service Accounts)"
  default     = false
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the OIDC provider for IRSA"
  default     = ""
}

variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC provider (without https://)"
  default     = ""
}

variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace for IRSA"
  default     = ""
}

variable "kubernetes_service_account" {
  type        = string
  description = "Kubernetes service account name for IRSA"
  default     = ""
}

variable "create_policy" {
  type        = bool
  description = "Whether to create a custom IAM policy"
  default     = false
}

variable "policy_name" {
  type        = string
  description = "Name of the custom IAM policy"
  default     = ""
}

variable "policy_description" {
  type        = string
  description = "Description of the custom IAM policy"
  default     = ""
}

variable "policy_statements" {
  type        = list(any)
  description = "List of policy statement objects"
  default     = []
}
