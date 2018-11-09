output "endpoint_resource_id" {
  value = "${var.cors_option_method==true?"empty":aws_api_gateway_resource.resource.id}"
}
