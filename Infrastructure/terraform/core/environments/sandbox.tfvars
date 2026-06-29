environment         = "sandbox"
region              = "eu-west-1"
eks_cluster_version = "1.33"
instance_types      = "t3.medium"

vpc_config = {
  cidr_block              = "10.0.0.0/16"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  public_subnet_count     = 2
  private_subnet_count    = 2
  public_subnet_mask      = 24
  private_subnet_mask     = 24
  public_subnet_offset    = 0
  private_subnet_offset   = 10
  map_public_ip_on_launch = true
}
