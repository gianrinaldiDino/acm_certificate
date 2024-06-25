# include "root" {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "tfr:///terraform-aws-modules/ecs/aws//modules/service?version=5.11.2"
# }

# dependencies {
#   paths = [
#     "../cluster",
#     "../../vpc",
#     "../../alb"    
#   ]
# }

# dependency "ecs_cluster" {
#   config_path = "../cluster"
# }

# dependency "alb" {
#   config_path = "../../alb"
# }

# dependency "vpc" {
#   config_path = "../../vpc"
# }

# inputs = {
#   name              = "athlete-service"
#   cluster_arn        = dependency.ecs_cluster.outputs.arn
#   container_definitions = {generic = { 
#     image = "changeMeViaCICD"     #cambiara cuando se deploye
#     port_mappings = [{
#       "containerPort" : 80
#       }]}}
#   desired_count     = 1
#   launch_type       = "FARGATE"
#   platform_version  = "LATEST"
#   subnet_ids         = dependency.vpc.outputs.public_subnets

#   load_balancer = [{
#     target_group_arn = dependency.alb.outputs.target_groups.general-tg.arn
#     container_name   = "generic"
#     container_port   = 80
#   }]
# }
