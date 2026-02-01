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
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.this]
  tags       = local.tags
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = values(aws_subnet.public_subnet)[0].id
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
  for_each       = aws_subnet.private_subnet
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}

# Security Group for Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# Application Load Balancer
resource "aws_lb" "this" {
  name               = "eks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false
  enable_http2               = true

  tags = local.tags
}

# Target Group for ALB
resource "aws_lb_target_group" "this" {
  name        = "eks-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = local.tags
}

# ALB Listener for HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
