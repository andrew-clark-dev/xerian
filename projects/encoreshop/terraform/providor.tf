variable "region" {}

variable "aws_profile" {}

# AWS provider with region and profile set to the
# region and aws_profile variables
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}