# S3 bucket for the webapp
resource "aws_s3_bucket" "webapp" {
  bucket = "${var.project_name}-webapp-${random_string.suffix.result}"
  
  # COMPLIANCE ISSUE: No versioning (data protection best practice violation)
  
  # COMPLIANCE ISSUE: No encryption (GDPR Article 32 violation)
  
  # COMPLIANCE ISSUE: No logging (security best practice violation)
  
  tags = {
    Name = "${var.project_name}-webapp"
  }
}

# Generate random suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# COMPLIANCE ISSUE: Public access to S3 (ANSSI recommendation violation)
resource "aws_s3_bucket_public_access_block" "webapp" {
  bucket = aws_s3_bucket.webapp.id
  
  block_public_acls       = false # Should be true
  block_public_policy     = false # Should be true
  ignore_public_acls      = false # Should be true
  restrict_public_buckets = false # Should be true
}

# COMPLIANCE ISSUE: Allow public access to all objects (data protection violation)
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.webapp.id
  policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.webapp.bucket}/*"
      }
    ]
  }
  EOT
}

# Upload index.html with basic "Hello World"
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.webapp.bucket
  key          = "index.html"
  content_type = "text/html"
  content      = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
      <title>CloudCRM - Hello World</title>
      <!-- COMPLIANCE ISSUE: Including tracking scripts without consent (GDPR Article 7 violation) -->
      <script async src="https://www.googletagmanager.com/gtag/js?id=UA-XXXXX-Y"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'UA-XXXXX-Y');
      </script>
    </head>
    <body>
      <h1>Welcome to CloudCRM</h1>
      <p>This is a non-compliant web application for demonstration purposes.</p>
      
      <!-- COMPLIANCE ISSUE: Contact form without privacy notice (GDPR Articles 13 and 14 violation) -->
      <form id="contact-form">
        <h2>Contact Us</h2>
        <input type="text" name="name" placeholder="Your Name" required><br>
        <input type="email" name="email" placeholder="Your Email" required><br>
        <textarea name="message" placeholder="Your Message" required></textarea><br>
        <button type="submit">Submit</button>
      </form>
    </body>
    </html>
  EOT
}

# CloudFront distribution for the webapp
resource "aws_cloudfront_distribution" "webapp" {
  origin {
    domain_name = aws_s3_bucket.webapp.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.webapp.bucket}"
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  # COMPLIANCE ISSUE: No custom SSL certificate (GDPR Article 32 violation)
  # Should use ACM certificate
  
  # COMPLIANCE ISSUE: Using outdated TLS version (ANSSI recommendation violation)
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1" # Should be TLSv1.2 or higher
  }
  
  # COMPLIANCE ISSUE: No logging (security best practice violation)
  # Should enable logging to S3 bucket
  
  # COMPLIANCE ISSUE: No web application firewall (ANSSI recommendation violation)
  # Should associate AWS WAF web ACL
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.webapp.bucket}"
    
    # COMPLIANCE ISSUE: No CORS policy (OWASP Top 10 violation)
    
    forwarded_values {
      query_string = false
      
      cookies {
        forward = "none"
      }
    }
    
    # COMPLIANCE ISSUE: No HTTPS enforcement (GDPR Article 32 violation)
    viewer_protocol_policy = "allow-all" # Should be redirect-to-https
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none" # COMPLIANCE ISSUE: No geo-restrictions
    }
  }
  
  tags = {
    Name = "${var.project_name}-webapp-distribution"
  }
} 