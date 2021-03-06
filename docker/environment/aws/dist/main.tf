terraform {
  backend "s3" {
    bucket = "covid19-civitech-remote"
    key    = "covid19-civitech-remote/prod"
    region = "us-east-1"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "random_string" "password_main" {
  length           = 16
  special          = false
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  override_special = ",.+-%!"
}

resource "aws_rds_cluster" "db" {
  cluster_identifier      = "covid19-civitech"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name           = "civitech"
  master_username         = "app"
  master_password         = (length(var.password) > 0) ? var.password : random_string.password_main.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  final_snapshot_identifier = "backup"
  skip_final_snapshot     = true
}

resource "aws_ecr_repository" "registry" {
  name                 = var.stack_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "api" {
  name = var.stack_name
}


data "aws_ecr_repository" "registry" {
  name = var.stack_name
}
