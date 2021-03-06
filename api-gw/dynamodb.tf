resource "aws_dynamodb_table" "http-crud-tutorial-table" {
  name         = "http-crud-tutorial-items-mro"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

}
