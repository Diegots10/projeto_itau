
# Define provedor e região
provider "aws" {
  region = "us-east-1"
}

# Criando a Tabela
resource "aws_dynamodb_table" "tb_books" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "book_id"

  attribute {
    name = "book_id"
    type = "S"
  }

  tags = {
    Name = "tb_books"
  }
}

# Criando a funçaão IAM
resource "aws_iam_role" "lambda_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "LambdaExecutionRole"
  }
}

# Condig de acesso a função IAM
resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda-dynamodb-access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Define a função lambda
resource "aws_lambda_function" "books_lambda" {
  filename         = "C:\\Users\\Rafael\\3D Objects\\ITAU\\itau.api.books\\package.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.tb_books.name
    }
  }

  source_code_hash = filebase64sha256("C:\\Users\\Rafael\\3D Objects\\ITAU\\itau.api.books\\package.zip")
}

# Permissão para API Gateway chamar a lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.books_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

# Cria a API no API Gateway
resource "aws_api_gateway_rest_api" "books_api" {
  name = "BooksMicroserviceAPI"
}

# Cria o recurso na API Gateway
resource "aws_api_gateway_resource" "books_resource" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id
  parent_id   = aws_api_gateway_rest_api.books_api.root_resource_id
  path_part   = "recommendations"
}

# Config método get na API Gateway
resource "aws_api_gateway_method" "post_recommendations" {
  rest_api_id   = aws_api_gateway_rest_api.books_api.id
  resource_id   = aws_api_gateway_resource.books_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integração da API Gateway com a lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.books_api.id
  resource_id             = aws_api_gateway_resource.books_resource.id
  http_method             = aws_api_gateway_method.post_recommendations.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.books_lambda.invoke_arn
}

# Implanta a API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id
  stage_name  = "HML"
  depends_on  = [aws_api_gateway_integration.lambda_integration]
}

# Output da URL
output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

