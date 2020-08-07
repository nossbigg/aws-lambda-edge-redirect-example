resource "aws_lambda_function" "edge_redirect_cf_lambda_edge" {
  function_name    = "cf_lambda_edge_redirect"
  role             = aws_iam_role.edge_redirect_cf_lambda_edge_role.arn
  runtime          = "nodejs12.x"
  filename         = data.archive_file.lambda_edge_zip.output_path
  source_code_hash = data.archive_file.lambda_edge_zip.output_base64sha256
  handler          = "index.handler"
  publish          = true
}

data "archive_file" "lambda_edge_zip" {
  type        = "zip"
  output_path = "/tmp/lambda.zip"
  source {
    content  = file("../lambda_edge_logic/index.js")
    filename = "index.js"
  }
}

resource "aws_iam_role" "edge_redirect_cf_lambda_edge_role" {
  name = "cf_lambda_edge_redirect_role"

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

resource "aws_iam_policy" "edge_redirect_cf_lambda_edge_role_policy" {
  name = "edge_redirect_cf_lambda_edge_role_policy"

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

resource "aws_iam_role_policy_attachment" "edge_redirect_cf_lambda_edge_role_policy_attach" {
  role       = aws_iam_role.edge_redirect_cf_lambda_edge_role.name
  policy_arn = aws_iam_policy.edge_redirect_cf_lambda_edge_role_policy.arn
}

# need not provision the following service-linked roles if already present in AWS infra
resource "aws_iam_service_linked_role" "edge_redirect_cf_lambda_edge_role_replicator" {
  aws_service_name = "replicator.lambda.amazonaws.com"
}

resource "aws_iam_service_linked_role" "edge_redirect_cf_lambda_edge_role_logger" {
  aws_service_name = "logger.cloudfront.amazonaws.com"
}
