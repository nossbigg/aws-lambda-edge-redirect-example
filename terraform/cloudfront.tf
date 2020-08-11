resource "aws_cloudfront_distribution" "edge_redirect_cf_distribution" {
  comment = "edge_redirect_cf_distribution"

  enabled = true

  depends_on = [aws_lambda_function.edge_redirect_cf_lambda_edge]

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
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["HEAD", "GET"]

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "some-origin-id"

    // disable caching for Lambda@Edge testing purposes
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    forwarded_values {
      cookies {
        forward = "all"
      }
      headers      = ["*"]
      query_string = false
    }

    lambda_function_association {
      event_type = "origin-request"
      // have to manually build ARN due to inability to use $LATEST for Lambda@Edge-CloudFront association
      lambda_arn   = "${aws_lambda_function.edge_redirect_cf_lambda_edge.arn}:${aws_lambda_function.edge_redirect_cf_lambda_edge.version}"
      include_body = false
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
