variable "app" {
  description = "Application name - used for component names"
}

variable "region" {
  description = "AWS region the app is running in"
}

variable "stage" {
  description = "The deployment stage"
}

variable "entity_name" {
  description = "The name of the entiy."
  type        = string
}

variable "lambda_src" {
  description = "The directory of the lambda src code."
  type        = string
}

# variable "user_pool" {
#   description = "The arn of the cognito user pool."
#   type        = string
# }
