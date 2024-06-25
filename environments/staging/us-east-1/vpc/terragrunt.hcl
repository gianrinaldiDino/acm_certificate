locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "vpc"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.8.1"
}

inputs = {
  name                                            = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  cidr                                            = "10.80.0.0/16" 
  azs                                             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets                                  = ["10.80.0.0/24", "10.80.1.0/24", "10.80.2.0/24"] 
  private_subnets                                 = ["10.80.6.0/24", "10.80.7.0/24", "10.80.8.0/24"]
  database_subnets                                = ["10.80.12.0/24", "10.80.13.0/24", "10.80.14.0/24"]
  enable_dns_hostnames                            = true
  enable_dns_support                              = true
  enable_nat_gateway                              = true
  single_nat_gateway                              = true
  enable_dhcp_options                             = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  enable_flow_log                                 = true
  flow_log_cloudwatch_log_group_retention_in_days = 1
  flow_log_traffic_type                           = "ALL"
  create_database_subnet_group                    = true

  public_subnet_tags = {
    "Type" = "public"
  }

  private_subnet_tags = {
    "Type" = "private"
  }

  database_subnet_tags = {
    "Type" = "database"
  }
}
