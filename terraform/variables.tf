variable "app" {
  description = "The application name"
  default     = "xerian"
}

variable "stage" {
  description = "The deployment stage"
  default     = "dev"
}

variable "region" {
  description = "AWS region the app is running in"
  default     = "eu-central-1"
}

variable "domain" {
  description = "The application domain"
  default     = "https://www.xerian.com/"
}

