locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "aurora"
}

include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/rds-aurora/aws?version=9.4.0"
}

dependencies {
  paths = [
    "../vpc"
  ]
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  name            = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  engine          = "aurora-postgresql"
  engine_version  = "15.6"
  master_username = "adm_psql"
  instances = {
    1 = {
      instance_class = "db.t3.medium"
    }
  }
  create_monitoring_role  = false
  create_security_group   = true
  security_group_rules = {
    ingress_rules = {
        description = "Allow from private subnets"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks
      }
    egress_rules = {
        type        = "egress"
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
  }

  
  vpc_id                  = dependency.vpc.outputs.vpc_id
  db_subnet_group_name    = dependency.vpc.outputs.database_subnet_group_name


  # Multi-AZ and Cluster configuration
  multi_az                = false
  apply_immediately       = true
  # Tags
}
