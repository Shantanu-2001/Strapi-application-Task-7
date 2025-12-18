resource "aws_db_subnet_group" "strapi" {
  name       = "shantanu-strapi-db-subnet-group"
  subnet_ids = data.aws_subnets.public.ids
}

resource "aws_security_group" "rds_sg" {
  name   = "shantanu-strapi-rds-sg"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_db_instance" "strapi" {
  identifier             = "strapi-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "strapi"
  password               = "strapi123"
  db_name                = "strapi_db"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.strapi.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
