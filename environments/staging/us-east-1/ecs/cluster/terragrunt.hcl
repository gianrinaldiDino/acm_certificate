locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "ecs-cluster"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//modules/cluster?ref=v5.11.2"
}

inputs = {
  name                  = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  cluster_name          = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  container_insights    = true
  create_auto_scaling_group = false
  capacity_providers    = ["FARGATE"]
}
