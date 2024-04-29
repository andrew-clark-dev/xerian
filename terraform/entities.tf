module "account" {
  source      = "./modules/entity"
  app         = var.app
  region      = var.region
  stage       = var.stage
  entity_name = "account"
  lambda_src  = "./files/lambda/src/account"
}
