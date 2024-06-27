# aws/staging/environment.hcl
locals {
  account_id     = "214633882441"
  account_name   = "Athlete.ai Staging"
  environment    = "staging"
  bucket         = "athlete-stg-tf-states-us-east-1-prueba-final"
  dynamodb_table = "athlete-stg-tf-locks-db"
}
