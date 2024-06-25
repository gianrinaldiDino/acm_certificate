locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "vpc-endpoint"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//modules/vpc-endpoints?version=5.8.1"
}

dependencies {
  paths = [
    "../vpc"
  ]
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id                     = dependency.vpc.outputs.vpc_id
  create_security_group      = true
  security_group_name        = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  security_group_description = "VPC endpoints security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = dependency.vpc.outputs.private_route_table_ids
      tags            = { Name = "s3-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"}
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { "Name" = "ssm-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"}
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { "Name" = "ssmmessages-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"}
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { "Name" = "ec2-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"}
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { "Name" = "ec2messages-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"}
    }
  }
}
