resource "aws_lambda_function" "edge_redirect_cf_lambda_edge" {
  function_name    = "cf_lambda_edge_redirect"
  role             = aws_iam_role.edge_redirect_cf_lambda_edge_role.arn
  runtime          = "nodejs12.x"
  filename         = data.archive_file.lambda_edge_zip.output_path
  source_code_hash = data.archive_file.lambda_edge_zip.output_base64sha256
  handler          = "index.handler"
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
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
