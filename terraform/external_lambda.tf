
resource "aws_lambda_function" "external_api" {
  function_name = "p4ExternalApiIntegration"
  role          = "arn:aws:iam::109375139212:role/service-role/p4ExternalApiIntegration-role-uw2x2cta"

  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"

  filename         = "${path.module}/p4ExternalApiIntegration.zip"
  source_code_hash = filebase64sha256("${path.module}/p4ExternalApiIntegration.zip")

  memory_size   = 128
  timeout       = 3
  architectures = ["x86_64"]
  package_type  = "Zip"
  description   = ""

  tracing_config {
    mode = "PassThrough"
  }

  ephemeral_storage {
    size = 512
  }

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/p4ExternalApiIntegration"
  }
}
