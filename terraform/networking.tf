# DEFAULT VPC
data "aws_vpc" "default" {
  default = true
}

# PUBLIC SUBNETS ONLY (internet-facing)
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# ECS SECURITY GROUP
resource "aws_security_group" "ecs_sg" {
  name   = "shantanu-strapi-ecs-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # keeps ECS public IP access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB → ECS
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
