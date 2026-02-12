locals {
  bucket_name                = "acme-static-site"
  account_id                 = data.aws_caller_identity.current.account_id
  cloudfront_distribution_id = data.tfe_outputs.cloudfront.values.cloudfront_distribution_id
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.10.0"

  bucket = local.bucket_name

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_policy.json

  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }

  tags = {
    Project = "ACME"
  }
}
