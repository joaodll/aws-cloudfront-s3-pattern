data "aws_route53_zone" "this" {
  name = local.domain
}

data "tfe_outputs" "s3-bucket" {
  organization = "ACME"
  workspace    = "s3-bucket-acme"
}
