resource "aws_lambda_function" "lambda_cf" {
  function_name    = "cf_lambda_edge_redirect"
  role             = aws_iam_role.lambda_cf_role.arn
  runtime          = "nodejs12.x"
  filename         = data.archive_file.lambda_cf_zip.output_path
  source_code_hash = data.archive_file.lambda_cf_zip.output_base64sha256
  handler          = "index.handler"
  publish          = true
}

data "archive_file" "lambda_cf_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_cf.zip"
  source {
    content  = file("../lambda_logic/lambda_cf.js")
    filename = "index.js"
  }
}

resource "aws_iam_role" "lambda_cf_role" {
  name = "lambda_cf_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_cf_role_policy" {
  name = "lambda_cf_role_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1596793881581",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_cf_role_policy_attach" {
  role       = aws_iam_role.lambda_cf_role.name
  policy_arn = aws_iam_policy.lambda_cf_role_policy.arn
}

# logging
resource "aws_cloudwatch_log_group" "lambda_cf_logging_cloudwatch" {
  provider          = aws.aws_sg
  name              = "/aws/lambda/us-east-1.${aws_lambda_function.lambda_cf.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_cf_logging" {
  role       = aws_iam_role.lambda_cf_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

# need not provision the following service-linked roles if already present in AWS infra
resource "aws_iam_service_linked_role" "lambda_cf_role_replicator" {
  aws_service_name = "replicator.lambda.amazonaws.com"
}

resource "aws_iam_service_linked_role" "lambda_cf_role_logger" {
  aws_service_name = "logger.cloudfront.amazonaws.com"
}
