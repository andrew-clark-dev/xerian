// Create ECR repo
resource "aws_ecr_repository" "xerian_ecr_repository" {
  name                 = "xerian-ecr-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
