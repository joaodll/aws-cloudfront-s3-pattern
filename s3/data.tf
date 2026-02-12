data "aws_caller_identity" "current" {}

data "tfe_outputs" "cloudfront" {
  organization = "ACME"
  workspace    = "cloudfront-acme"
}
