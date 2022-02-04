variable "demo-name" {
  type        = string
  default     = "demo-vpc-aurora"
  description = "(optional) describe your variable"
}

################################################################################
# RDS Aurora Module - PostgreSQL
################################################################################

module "aurora_postgresql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name                   = "serverless-aurora-postgresql"
  engine                 = "aurora-postgresql"
  engine_mode            = "serverless"
  storage_encrypted      = true
  master_username        = "administrator"
  master_password        = "Admin123"
  create_random_password = false

  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.database_subnets
  create_security_group = true
  allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks

  monitoring_interval  = 60
  enable_http_endpoint = true # cool for querying via HTTP
  apply_immediately    = true
  skip_final_snapshot  = true

  db_parameter_group_name         = aws_db_parameter_group.example_postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example_postgresql.id
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true # DB cluster can be paused only when it's idle (it has no connections)
    min_capacity             = 2    # capacity units
    max_capacity             = 8    # capacity units
    seconds_until_auto_pause = 300  # time before an Aurora DB cluster in serverless mode is paused
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "example_postgresql" {
  name        = "${var.demo-name}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.demo-name}-aurora-db-postgres-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "example_postgresql" {
  name        = "${var.demo-name}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.demo-name}-aurora-postgres-cluster-parameter-group"
}

resource "aws_security_group" "ssh_access" {
  name        = "web_security_group"
  description = "Terraform web security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
