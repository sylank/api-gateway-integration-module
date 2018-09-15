locals {
  region = "${data.aws_region.current.name}"
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "lavender-backend-api"
  description = "Lavender backend services API gateway"
}



resource "aws_api_gateway_resource" "reservation_root" {
  path_part   = "reservation"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "reservation_enabled_resource" {
  path_part   = "enabled"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "query_all_reservation_method_resource" {
  path_part   = "query"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "create_reservation_resource" {
  path_part   = "create"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "reservation_enabled_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "query_all_reservation_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "create_reservation_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}



resource "aws_api_gateway_integration" "reservation_enabled_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method             = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.reservation_enabled_lambda.arn}/invocations"
}

resource "aws_api_gateway_integration" "query_all_reservation_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method             = "${aws_api_gateway_method.query_all_reservation_method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.query_all_reservation_lambda.arn}/invocations"
}

resource "aws_api_gateway_integration" "create_reservation_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method             = "${aws_api_gateway_method.create_reservation_method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.create_reservation_lambda.arn}/invocations"
}



resource "aws_api_gateway_deployment" "lavender_backend_deployment" {
  depends_on = [
                "aws_api_gateway_integration.reservation_enabled_integration",
                "aws_api_gateway_integration.query_all_reservation_integration",
                "aws_api_gateway_integration.create_reservation_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "api"

  variables = {
    "answer" = "42"
  }
}
