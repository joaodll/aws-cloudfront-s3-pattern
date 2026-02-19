## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.33.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | terraform-aws-modules/cloudfront/aws | 6.4.0 |
| <a name="module_records"></a> [records](#module\_records) | terraform-aws-modules/route53/aws//modules/records | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_origin_access_control.access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_cloudfront_response_headers_policy.secure_headers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [tfe_outputs.s3-bucket](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_site_version_path"></a> [site\_version\_path](#input\_site\_version\_path) | The path of the current AWS S3 site version | `string` | `"v1.0.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | Distribution ID |