resource "aws_dynamodb_table" "service_requests" {
  name         = "p4-service-request-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}