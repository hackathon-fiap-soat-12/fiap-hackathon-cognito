variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Account region"
}

variable "vpc_name" {
  type = string
  default = "fiap-hackathon-vpc"
  description = "Custom VPC name"
}

variable "lambda_authorizer_name" {
  type = string
  default = "fiap-hackathon-lambda-authorizer"
  description = "Lambda Authorizer name"
}
