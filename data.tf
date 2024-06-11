data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    region   = var.region
    bucket   = "${var.bucket_tfstate}-${var.environment}"
    key      = "${var.region}/${var.environment}/route53.tfstate"
  }
}