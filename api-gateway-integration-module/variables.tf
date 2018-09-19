
variable "region" {}

variable "lambda_function_arn" {}

variable "method_type" {}

variable "path_url" {}

variable "status_200" {
  default = "200"
}

variable "status_default" {
  default = "${var.status_200}"
}

variable "default_pattern" {
  default = ""
}

variable "log_level" {
  default = "INFO"
}

variable "retention_in_days" {
  default = "7"
}

variable "rest_api_id" {
  
}

variable "stage_name" {
  
}

variable "root_path" {
  
}

variable "root_resource_id" {
  
}

