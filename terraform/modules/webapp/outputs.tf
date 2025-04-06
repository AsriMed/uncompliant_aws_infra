output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.webapp.id
}

output "s3_bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = aws_s3_bucket.webapp.website_endpoint
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.webapp.domain_name
} 