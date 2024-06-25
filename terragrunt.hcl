# aws/terragrunt.hcl
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_id     = local.environment_vars.locals.account_id
  environment    = local.environment_vars.locals.environment
  bucket         = local.environment_vars.locals.bucket
  dynamodb_table = local.environment_vars.locals.dynamodb_table
  region         = local.region_vars.locals.region
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = local.dynamodb_table
    encrypt        = true
  }
}

generate "provider" {
  path      = "generated.provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      backend "s3" {}
      required_version = ">= 0.56.0"
    }

    provider "aws" {
      region = "${local.region}"
      # assume_role {
      #   role_arn     = "arn:aws:iam::${local.account_id}:role/terragrunt-sso"
      #   session_name = "terraform"
      # }
      default_tags {
        tags = {
          "aws-migration-project-id" = "Athlete.ai"
          "Environment"              = "${local.environment}"
          "Project"                  = "Athlete.ai"
          "Owner"                    = "Athlete.ai"
          "CostCenter"               = "${local.environment}"
        }
      }
    }
    EOF
}
