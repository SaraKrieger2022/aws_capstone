resource "aws_dynamodb_table" "courts" {
  name             = "courts"
  hash_key         = "id"
  billing_mode     = "PROVISIONED"
  read_capacity    = 25
  write_capacity   = 25

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    name = "Legal-data-table"
  }
}