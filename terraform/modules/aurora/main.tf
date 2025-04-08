resource "aws_rds_cluster" "this" {
  cluster_identifier      = "aurora-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.11.2"
  database_name          = var.db_name
  master_username        = var.username
  master_password        = var.password
  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
}

resource "aws_security_group" "aurora" {
  name        = "aurora-db-sg"
  description = "Allow inbound MySQL access"
  vpc_id      = var.vpc_id

  tags = {
    Name = "aurora-db-sg"
  }
}

resource "aws_security_group_rule" "allow_db_connections" {
  security_group_id = aws_security_group.aurora.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
}

resource "aws_db_subnet_group" "this" {
  name       = "aurora-subnet-group"
  subnet_ids = var.subnets
  tags = {
    Name = "aurora-subnet-group"
  }
}

resource "aws_rds_cluster_instance" "this" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
}