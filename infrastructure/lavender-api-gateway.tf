locals {
  region = "${data.aws_region.current.name}"
}

resource "random_string" "deployment_variable" {
  length  = 10
  special = false
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "lavender-backend-api"
  description = "Lavender backend services API gateway"
}

resource "aws_api_gateway_deployment" "lavender_backend_deployment" {
  depends_on = [
    "aws_api_gateway_integration.reservation_enabled_integration",
    "aws_api_gateway_integration.query_all_reservation_integration",
    "aws_api_gateway_integration.create_reservation_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.stage_name}"

  variables = {
    "deployed_at" = "${random_string.deployment_variable.result}"
  }
}
