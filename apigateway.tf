
# Existing HTTP API
resource "aws_apigatewayv2_api" "service_request" {
  name          = "p4serviceRequestAPI"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["content-type"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins     = ["https://d2c9bn1eiwxujd.cloudfront.net"]
    max_age           = 0
  }
}

# Integration: external API Lambda
resource "aws_apigatewayv2_integration" "external_post" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:p4ExternalApiIntegration"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Integration: main Lambda, used by DELETE and PUT
resource "aws_apigatewayv2_integration" "main_delete_put" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:myServiceRequestFunction"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Integration: main Lambda, GET /requests
resource "aws_apigatewayv2_integration" "main_get_list" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:myServiceRequestFunction"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Integration: main Lambda, POST /requests
resource "aws_apigatewayv2_integration" "main_post" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:myServiceRequestFunction"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Integration: main Lambda, GET /requests/{id}
resource "aws_apigatewayv2_integration" "main_get_id" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:myServiceRequestFunction"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Existing integration not referenced by any of the six routes
resource "aws_apigatewayv2_integration" "main_unused" {
  api_id                 = aws_apigatewayv2_api.service_request.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = "arn:aws:lambda:ap-southeast-1:109375139212:function:myServiceRequestFunction"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

# Routes
resource "aws_apigatewayv2_route" "external_post" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "GET /external-post"
  target    = "integrations/${aws_apigatewayv2_integration.external_post.id}"
}

resource "aws_apigatewayv2_route" "requests_post" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "POST /requests"
  target    = "integrations/${aws_apigatewayv2_integration.main_post.id}"
}

resource "aws_apigatewayv2_route" "requests_delete_id" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "DELETE /requests/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.main_delete_put.id}"
}

resource "aws_apigatewayv2_route" "requests_get_id" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "GET /requests/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.main_get_id.id}"
}

resource "aws_apigatewayv2_route" "requests_put_id" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "PUT /requests/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.main_delete_put.id}"
}

resource "aws_apigatewayv2_route" "requests_get" {
  api_id    = aws_apigatewayv2_api.service_request.id
  route_key = "GET /requests"
  target    = "integrations/${aws_apigatewayv2_integration.main_get_list.id}"
}

# Existing $default stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.service_request.id
  name        = "$default"
  auto_deploy = true
}
