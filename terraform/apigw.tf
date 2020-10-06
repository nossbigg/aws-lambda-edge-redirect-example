resource "aws_apigatewayv2_api" "apigw" {
  name          = "apigw"
  protocol_type = "HTTP"
  target        = aws_lambda_function.lambda_apigw.arn
}

resource "aws_lambda_permission" "apigw_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_apigw.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigw.execution_arn}/*/*"
}
