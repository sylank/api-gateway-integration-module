resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_200}"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_integration_response" "default_integration_response" {
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.resource.id}"
  http_method       = "${aws_api_gateway_method.method.http_method}"
  status_code       = "${var.status_default}"
  selection_pattern = "${var.default_pattern}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = ["aws_api_gateway_integration.integration"]
}