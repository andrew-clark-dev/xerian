output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.cognito_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.cognito_user_pool_client.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.cognito_identity_pool.id
}
