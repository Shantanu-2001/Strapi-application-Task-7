# =========================
# DEFAULT VPC
# =========================
data "aws_vpc" "default" {
  default = true
}

# =========================
# AVAILABLE SUBNETS (PUBLIC)
# =========================
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# =========================
# ECS SECURITY GROUP
# =========================
resource "aws_security_group" "ecs_sg" {
  name   = "shantanu-strapi-ecs-sg"
  vpc_id = data.aws_vpc.default.id

  # ❗ Required so ECS task can still be accessed via public IP (Task-8 behavior)
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =========================
# ALB → ECS ALLOW RULE (CRITICAL)
# =========================
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
