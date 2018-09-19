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

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_200}"
  depends_on  = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_integration_response" "default_integration_response" {
  rest_api_id       = "${aws_api_gateway_rest_api.api.id}"
  resource_id       = "${aws_api_gateway_resource.resource.id}"
  http_method       = "${aws_api_gateway_method.method.http_method}"
  status_code       = "${var.status_default}"
  selection_pattern = "${var.default_pattern}"

  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_account" "gateway" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatchlog.arn}"
}

resource "aws_iam_role" "cloudwatchlog_role" {
  name = "gateway_cloudwatchlog"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "cloudwatchlog_attachment" {
  name       = "${var.api_name}_logs"
  roles      = ["${aws_iam_role.cloudwatchlog_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_method_settings" "settings_enabled" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.deployment.stage_name}"
  method_path = "${aws_api_gateway_resource.root_resource.path_part}/${aws_api_gateway_resource.resource.path_part}/${aws_api_gateway_method.method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "${var.log_level}"
  }
}

resource "aws_cloudwatch_log_group" "gateway_logging" {
  name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${var.stage_name}"

  retention_in_days = "${var.retention_in_days}"
}
