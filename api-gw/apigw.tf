resource "aws_apigatewayv2_api" "http-crud-tutorial-api" {
  name          = "http-crud-tutorial-api-mro"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "http-crud-tutorial-api" {
  api_id      = aws_apigatewayv2_api.http-crud-tutorial-api.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.http-crud-tutorial-api.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_route" "route-1" {
  api_id    = aws_apigatewayv2_api.http-crud-tutorial-api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.http-crud-tutorial-api.id}"
}

resource "aws_apigatewayv2_route" "route-2" {
  api_id    = aws_apigatewayv2_api.http-crud-tutorial-api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.http-crud-tutorial-api.id}"
}

resource "aws_apigatewayv2_route" "route-3" {
  api_id    = aws_apigatewayv2_api.http-crud-tutorial-api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.http-crud-tutorial-api.id}"
}

resource "aws_apigatewayv2_route" "route-4" {
  api_id    = aws_apigatewayv2_api.http-crud-tutorial-api.id
  route_key = "DELETE /items"
  target    = "integrations/${aws_apigatewayv2_integration.http-crud-tutorial-api.id}"
}

resource "aws_apigatewayv2_integration" "http-crud-tutorial-api" {
  api_id                 = aws_apigatewayv2_api.http-crud-tutorial-api.id
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0" # important, required by the Lambda-function!

  connection_type = "INTERNET" # default-value
  #content_handling_strategy = "CONVERT_TO_TEXT"
  description          = "Lambda example"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.http_crud_lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH" # default-value
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_crud_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http-crud-tutorial-api.execution_arn}/*/*"
}
