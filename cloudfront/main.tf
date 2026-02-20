locals {
  bucket_domain_name = data.tfe_outputs.s3-bucket.values.bucket_regional_domain_name
  subdomain          = "hello-there"
  domain             = "acme.com"
  acm_cert_arn       = data.aws_acm_certificate.issued.arn
}
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "6.4.0"

  aliases      = ["${local.subdomain}.${local.domain}"]
  enabled      = true
  comment      = "CloudFront to Static site on Private S3"
  http_version = "http2and3"

  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["US", "BR", "DE", "FR", "CA", "JP"]
    }
  }
  origin = {
    s3 = {
      domain_name = local.bucket_domain_name
      origin_id   = "s3-site"
      origin_access_control = {
        signing_behavior = "always"
        signing_protocol = "sigv4"
        origin_type      = "s3"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-site"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  viewer_certificate = {
    acm_certificate_arn = local.acm_cert_arn
    ssl_support_method  = "sni-only"
  }
}
