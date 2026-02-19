resource "aws_cloudfront_origin_access_control" "access_control" {
  name                              = "s3-site"
  description                       = "Access Control for S3 Origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
