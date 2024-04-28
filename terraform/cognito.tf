resource "aws_cognito_user_pool" "cognito_user_pool" {
  name                     = "${var.app}-user-pool-${var.stage}"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_uppercase                = false
    require_numbers                  = false
    require_symbols                  = false
    temporary_password_validity_days = 1
  }
}

resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name         = "${var.app}-user-pool-client-${var.stage}"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  # Flutter SDK doesnot support secrets here
  generate_secret = false

  # Create a user pool client with Cognito as the identity provider
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["openid", "email"]
  callback_urls                        = ["https://xerian.com"]
  supported_identity_providers         = ["COGNITO"]
}
