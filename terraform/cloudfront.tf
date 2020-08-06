resource "aws_cloudfront_distribution" "edge_redirect_cf_distribution" {
  enabled = true

  origin {
    domain_name = "nossbigg.github.io"
    origin_id   = "some-origin-id"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["HEAD","GET"]
    cached_methods  = ["HEAD","GET"]

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "some-origin-id"

    forwarded_values {
      cookies {
        forward = "all"
      }
      query_string = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
