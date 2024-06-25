# aws/production/environment.hcl
locals {
  account_id     = "214633882441"
  account_name   = "Athlete.ai Production"
  environment    = "production"
  bucket         = "athlete-prod-tf-states-us-east-1"
  dynamodb_table = "athlete-prod-tf-locks-db"
}
