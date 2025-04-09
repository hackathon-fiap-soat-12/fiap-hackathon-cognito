data "aws_caller_identity" "current" {}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_lambda_function" "lambda_authorizer" {
  function_name = var.lambda_authorizer_name
}

data "aws_ssm_parameter" "fiap_hackathon_api_invoke_url" {
  name = "/fiap-hackathon/fiap-hackathon-api-invoke-url"
}