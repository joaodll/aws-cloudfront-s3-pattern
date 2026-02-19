data "aws_route53_zone" "this" {
  name = local.domain
}

data "tfe_outputs" "s3-bucket" {
  organization = "ACME"
  workspace    = "s3-bucket-acme"
}

data "aws_acm_certificate" "issued" {
  domain   = local.domain
  statuses = ["ISSUED"]
}

data "aws_cloudfront_response_headers_policy" "secure_headers" {
  name = "Managed-SecurityHeadersPolicy"
}
