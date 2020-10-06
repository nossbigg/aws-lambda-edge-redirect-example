resource "aws_lambda_function" "lambda_apigw" {
  function_name    = "lambda_apigw"
  role             = aws_iam_role.lambda_apigw_role.arn
  runtime          = "nodejs12.x"
  filename         = data.archive_file.lambda_apigw_zip.output_path
  source_code_hash = data.archive_file.lambda_apigw_zip.output_base64sha256
  handler          = "index.handler"
  publish          = true
}

data "archive_file" "lambda_apigw_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_apigw.zip"
  source {
    content  = file("../lambda_logic/lambda_apigw.js")
    filename = "index.js"
  }
}

resource "aws_iam_role" "lambda_apigw_role" {
  name = "lambda_apigw_role"

  assume_role_policy = <<POLICY
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
POLICY
}

# logging
resource "aws_cloudwatch_log_group" "lambda_apigw_logging_cloudwatch" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_apigw.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_apigw_logging" {
  role       = aws_iam_role.lambda_apigw_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}
