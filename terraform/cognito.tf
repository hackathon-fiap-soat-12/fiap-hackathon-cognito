resource "random_id" "hex_string" {
  byte_length = 8
}

resource "aws_cognito_user_pool" "user_pool" {
  name                     = "fiap-hackathon-user-pool"
  auto_verified_attributes = ["email"]

  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "fiap-hackathon-domain-${random_id.hex_string.hex}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_resource_server" "gateway_scope" {
  identifier   = data.aws_ssm_parameter.fiap_hackathon_api_invoke_url.value
  name         = "fiap-hackathon-gateway-resource"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  scope {
    scope_name        = "read"
    scope_description = "Read access to resources"
  }

  scope {
    scope_name        = "write"
    scope_description = "Write access to resources"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name            = "fiap-hackathon-client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

#  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = ["COGNITO"]
#  explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  callback_urls = ["https://fiap-soat-12.github.io/fiap-soat-fiap-hackathon-api/"]
}

resource "null_resource" "update_lambda_environment" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "aws lambda update-function-configuration --function-name ${var.lambda_authorizer_name} --environment Variables={USER_POOL_ID=${aws_cognito_user_pool.user_pool.id}}"
  }
}
