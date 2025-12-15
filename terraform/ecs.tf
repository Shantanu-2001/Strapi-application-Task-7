# =========================
# ECS Cluster
# =========================
resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster-shantanu"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# =========================
# Security Group for ECS
# =========================
resource "aws_security_group" "ecs_sg" {
  name   = "strapi-ecs-sg-shantanu"
  vpc_id = data.aws_vpc.default.id

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
# ECS Task Definition
# =========================
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn      = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.docker_image

      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.strapi_rds.address },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapi_db" },
        { name = "DATABASE_USERNAME", value = "strapi" },
        { name = "DATABASE_PASSWORD", value = "strapi123" },

        { name = "APP_KEYS", value = "key1,key2,key3,key4" },
        { name = "API_TOKEN_SALT", value = "api_token_salt_123" },
        { name = "ADMIN_JWT_SECRET", value = "admin_jwt_secret_123" },
        { name = "JWT_SECRET", value = "jwt_secret_123" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/strapi"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "strapi"
          awslogs-create-group  = "true"
        }
      }
    }
  ])
}

# =========================
# ECS Service
# =========================
resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.strapi
  ]
}

