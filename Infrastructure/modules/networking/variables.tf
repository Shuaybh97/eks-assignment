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
  description = "VPC configuration"
}

variable "global_tags" {
  type        = map(string)
  description = "Global tags to apply to all resources"
  default     = {}
}
