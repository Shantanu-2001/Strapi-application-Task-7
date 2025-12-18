# =========================
# ALB SECURITY GROUP
# =========================
resource "aws_security_group" "alb_sg" {
  name   = "strapi-alb-sg-shantanu"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
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
# SUBNETS GROUPED BY AZ (FINAL FIX)
# =========================
data "aws_subnet" "per_az" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  # Group subnets by AZ, then pick the first subnet from each AZ
  alb_subnets = [
    for az, subnets in {
      for s in data.aws_subnet.per_az :
      s.availability_zone => s.id...
    } : subnets[0]
  ]
}

# =========================
# APPLICATION LOAD BALANCER
# =========================
resource "aws_lb" "strapi" {
  name               = "strapi-alb-shantanu"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = local.alb_subnets
}

# =========================
# TARGET GROUP
# =========================
resource "aws_lb_target_group" "strapi" {
  name        = "strapi-tg-shantanu"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/admin"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200-399"
  }
}

# =========================
# LISTENER
# =========================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.strapi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi.arn
  }
}
