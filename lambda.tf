


resource "aws_lambda_function" "service_request" {
  function_name = "myServiceRequestFunction"
  role          = "arn:aws:iam::109375139212:role/service-role/myServiceRequestFunction-role-cj9cyoda"

  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"

  filename         = "${path.module}/myServiceRequestFunction.zip"
  source_code_hash = filebase64sha256("${path.module}/myServiceRequestFunction.zip")

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
    log_group  = "/aws/lambda/myServiceRequestFunction"
  }
}
