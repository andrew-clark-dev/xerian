resource "aws_dynamodb_table" "entity_dynamodb_table" {
  name         = "${var.app}-${var.entity_name}-entity-${var.stage}"
  hash_key     = "id"
  range_key    = "number"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "number"
    type = "N"
  }
}

resource "aws_dynamodb_table" "entity_counter_dynamodb_table" {
  name         = "${var.app}-${var.entity_name}-counter-${var.stage}"
  hash_key     = "id"
  range_key    = "count"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "count"
    type = "N"
  }
}


# Create IAM policy allowing access to DynamoDB table
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "${var.app}-${var.entity_name}-db-policy-${var.stage}"
  description = "Allows access to DynamoDB tables"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = [aws_dynamodb_table.entity_dynamodb_table.arn, aws_dynamodb_table.entity_counter_dynamodb_table.arn],
      }
    ]
  })
}
