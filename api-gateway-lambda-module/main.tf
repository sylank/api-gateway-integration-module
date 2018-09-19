# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api_name}"
  description = "${var.api_description}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_integration.integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.stage_name}"

  variables = {
    "deployed_at" = "${var.deployed_at}"
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_templates = {
    "application/json" = "${file("api_gateway_body_mapping.template")}"
  }
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "${var.method_type}"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "root_resource" {
  path_part   = "${var.root_path}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "${var.path_url}"
  parent_id   = "${aws_api_gateway_resource.root_resource.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

