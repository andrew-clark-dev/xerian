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

resource "aws_cognito_identity_pool" "cognito_identity_pool" {
  identity_pool_name = "${var.app}-identity-pool-${var.stage}"
  # No anoymous users
  allow_unauthenticated_identities = false
  # Specify supported Cognito User Pool(s)
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.cognito_user_pool_client.id
    provider_name           = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.cognito_user_pool.id}"
    server_side_token_check = false
  }
}



resource "aws_cognito_identity_pool_roles_attachment" "cognito_identity_pool_roles_attachment" {
  identity_pool_id = aws_cognito_identity_pool.cognito_identity_pool.id

  roles = {
    "authenticated"   = aws_iam_role.authenticated_role.arn
    "unauthenticated" = aws_iam_role.unauthenticated_role.arn
  }
}

resource "aws_iam_role" "authenticated_role" {
  name = "${var.app}-authenticated-role-${var.stage}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity",
          Principal = {
            Federated = "cognito-identity.amazonaws.com"
          },
          Effect = "Allow",
          Condition = {
            StringEquals = {
              "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.cognito_identity_pool.id
            }
          }
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "authenticated_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess" # Full access to DB's TODO we need to limit this (the best way is the api gateway)
  role       = aws_iam_role.authenticated_role.name
}

resource "aws_iam_role" "unauthenticated_role" {
  name = "${var.app}-unauthenticated-role-${var.stage}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.cognito_identity_pool.id
          }
        }
      }
    ]
  })
}
