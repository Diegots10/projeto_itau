variable "lambda_function_name" {
  description = "Nome da função Lambda"
  default     = "BooksMicroserviceLambda"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  default     = "tb_books"
}
