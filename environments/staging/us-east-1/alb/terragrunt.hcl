locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  global_vars = read_terragrunt_config(find_in_parent_folders("globals/globals.hcl")).locals
  resource = "alb"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/alb/aws?version=9.9.0"
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
  name               = "${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
  load_balancer_type = "application"
  vpc_id             = dependency.vpc.outputs.vpc_id
  subnets            = dependency.vpc.outputs.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = dependency.vpc.outputs.vpc_cidr_block
    }
  }

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
        type = "redirect"
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
    }
  ]
  target_groups = {
    general-tg = {
      name                              = "ecs-${local.resource}-${local.global_vars.sufix}-${local.environment_vars.environment}"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      create_attachment                 = false #target vacio
      deregistration_delay              = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz" #cambiar endpoint de health al momento de saber
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }
    }
  }

  
  tags = {
    Environment = "staging"
  }
}
