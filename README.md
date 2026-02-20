# CloudFront + Private S3 Static Site (Terraform)

This repository contains Terraform modules and a small demo static site used to deploy a secure, production-ready static website served through Amazon CloudFront with a private S3 bucket as the origin. The configuration focuses on security best practices: minimum TLS version, origin access control (OAC) / origin access identity, restricted bucket policy, strict security headers, and (optional) geographic restrictions.

---

## What's included

- `s3/` — Terraform module and configuration to create a private S3 bucket for static assets (locked down with a policy so only CloudFront may read it).
- `cloudfront/` — Terraform module for a CloudFront distribution configured to use the private S3 origin, security headers, minimum TLS (e.g. `TLSv1.2_2025`), optional geo restrictions, and other hardening options.
- `static-demo-site/` — small demo static site (HTML/CSS/JS + assets) you can use to test the pipeline and distribution.

You can find more details about each module in their respective `README.md` files inside the `s3/`, `cloudfront/`, and `static-demo-site/` folders.

---

## Key features and security choices

- **Private S3 origin**: S3 bucket is *not public*. CloudFront accesses the bucket using Origin Access Control or an Origin Access Identity so objects are never served directly from S3 public endpoints.
- **Minimum TLS**: CloudFront is configured to enforce a strict TLS minimum protocol version.
- **Security headers**: The distribution includes response headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, etc.) to protect against common browser-based attacks.
- **Geo restrictions (optional)**: You can configure allow/deny lists in CloudFront to restrict serving to certain countries.
- **CI/CD**: Designed to work with a GitHub Actions workflow that builds the site (if needed), publishes assets to S3, and invalidates CloudFront cache on release.

---

## Repository

```
/
├─ cloudfront/            # CloudFront Terraform module and config
├─ s3/                    # S3 Terraform module and config
├─ static-demo-site/      # Example static site
├─ .github/workflows/     # GitHub Actions workflow
└─ README.md              # <-- this file
```

---

## GitHub Actions: example workflow (release -> deploy)

**Invalidate CloudFront cache**

After uploading new files, invalidate the distribution paths so edge caches pick up new changes. From CI, use the AWS CLI:

```bash
aws cloudfront create-invalidation --distribution-id $CF_DIST_ID --paths "/index.html" "/assets/*"
```
OR, you can set the `site_version_path` varaible like i did on my examples, so GitHub Actions will create a new path with the new Release name on S3 and you change the `variable.tf` default value on cloudfront dir, setting the new release version.

---

**Tips:**
- Prefer using [OIDC + IAM role for GitHub Actions](https://github.com/joaodll/aws-oidc-trust-examples/tree/main/github-actions) rather than long-lived keys. If you use OIDC, store role ARN in a secret.

---

## Variables and customization

- **TLS/minimum protocol**: Check `cloudfront/` module where the `minimum_protocol_version` is set (example: `TLSv1.2_2025`).
- **Geo restrictions**: CloudFront supports `whitelist` or `blacklist` country lists. Fine-tune in `cloudfront/variables.tf`.
- **Security headers**: Adjust CSP, HSTS, and other headers in the distribution configuration or via Lambda@Edge / CloudFront Functions if needed.
- **Edge caching TTLs**: Adjust caching rules (default, min, max TTL) to balance cache effectiveness vs invalidation frequency.

---

## Security considerations

- Keep bucket **private**. Never enable public read on bucket or objects.
- Use Origin Access Control (OAC) or Origin Access Identity (OAI) to ensure CloudFront is the only service allowed to read from the bucket.
- Use **short, narrow IAM policies** for CI roles (limit to the specific bucket + distribution actions required).
- Review CloudFront logging and S3 server access logging for auditing.
