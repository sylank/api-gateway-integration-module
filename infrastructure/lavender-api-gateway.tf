variable lambda_function_arn {}

variable default_region {}
variable accound_id {}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
}

resource "aws_api_gateway_resource" "resource" {
  path_part = "resource"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.default_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}

output rest_api_id {
    value = "${aws_api_gateway_rest_api.api.id}"
}

output api_method {
    value = "${aws_api_gateway_method.method.http_method}"
}

output api_resource {
    value = "${aws_api_gateway_resource.resource.path}"
}