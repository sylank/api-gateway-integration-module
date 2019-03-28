resource "aws_api_gateway_method_response" "200" {
  count = "${var.aws_proxy ? 0 : 1}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_200}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_method.method"]
}

resource "aws_api_gateway_integration_response" "default_integration_response" {
  count = "${var.aws_proxy ? 0 : 1}"
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

#500 error
resource "aws_api_gateway_method_response" "500" {
  count = "${var.aws_proxy ? 0 : 1}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_500}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_method.method"]
}

resource "aws_api_gateway_integration_response" "integration_response_500" {
  count = "${var.aws_proxy ? 0 : 1}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.resource.id}"
  http_method       = "${aws_api_gateway_method.method.http_method}"
  status_code       = "${var.status_500}"
  selection_pattern = "${var.status_500_pattern}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = ["aws_api_gateway_integration.integration"]
}

#400 error
resource "aws_api_gateway_method_response" "400" {
  count = "${var.aws_proxy ? 0 : 1}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_400}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_method.method"]
}

resource "aws_api_gateway_integration_response" "integration_response_400" {
  count = "${var.aws_proxy ? 0 : 1}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.resource.id}"
  http_method       = "${aws_api_gateway_method.method.http_method}"
  status_code       = "${var.status_400}"
  selection_pattern = "${var.status_400_pattern}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = ["aws_api_gateway_integration.integration"]
}