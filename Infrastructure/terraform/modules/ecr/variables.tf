variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "Image tag mutability setting (MUTABLE or IMMUTABLE)"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Enable image scanning on push"
}

variable "enable_lifecycle_policy" {
  type        = bool
  default     = true
  description = "Enable lifecycle policy to clean up old images"
}

variable "max_image_count" {
  type        = number
  default     = 10
  description = "Maximum number of images to retain in the repository"
}

variable "global_tags" {
  type        = map(string)
  description = "Global tags to apply to all resources"
}
