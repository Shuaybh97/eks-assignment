resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = local.tags
}

resource "aws_subnet" "public_subnet" {
  for_each                = toset(local.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.key))
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags                    = local.tags
}

resource "aws_subnet" "private_subnet" {
  for_each          = toset(local.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.key) + 10)
  availability_zone = each.value
  tags              = local.tags

}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = local.tags
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.igw]
  tags       = local.tags
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_eip.elastic_ip]
  tags          = local.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
