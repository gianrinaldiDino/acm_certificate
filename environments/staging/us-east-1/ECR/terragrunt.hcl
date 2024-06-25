locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "ecr"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/ecr/aws?version=2.2.1"
}

inputs = {
  repository_name                   = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"  
  create_lifecycle_policy           = false
}
