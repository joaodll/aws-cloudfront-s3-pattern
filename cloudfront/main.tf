locals {
  bucket_domain_name = data.tfe_outputs.s3-bucket.values.bucket_regional_domain_name
  subdomain          = "hello-there"
  domain             = "acme.com"
  acm_cert_arn       = data.aws_acm_certificate.issued.arn
  secure_headers_id  = data.aws_cloudfront_response_headers_policy.secure_headers
}
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "6.4.0"

  aliases      = ["${local.subdomain}.${local.domain}"]
  enabled      = true
  comment      = "CloudFront to Static site on Private S3"
  http_version = "http2and3"

  default_root_object = "index.html"
  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["US", "BR", "DE", "FR", "CA", "JP"]
    }
  }
  origin = {
    s3-site = {
      domain_name              = local.bucket_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.access_control.id
      origin_path              = "/${var.site_version_path}"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-site"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    response_headers_policy_id = local.secure_headers_id
  }

  viewer_certificate = {
    acm_certificate_arn      = local.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2025"
  }
}
