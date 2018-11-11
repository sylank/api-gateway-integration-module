variable "region" {}

variable "lambda_function_arn" {}

variable "method_type" {}

variable "path_url" {}

variable "status_200" {
  default = "200"
}

variable "status_default" {
  default = "200"
}

variable "default_pattern" {
  default = ""
}

variable "rest_api_id" {}

variable "root_resource_id" {}
