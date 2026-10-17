

# Dead-letter queue
resource "aws_sqs_queue" "service_request_dlq" {
  name                      = "p4-service-request-dlq"
  message_retention_seconds = 345600
  max_message_size          = 1048576
  sqs_managed_sse_enabled   = true
}

# Main SQS queue
resource "aws_sqs_queue" "service_request_queue" {
  name                       = "p4-service-request-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  max_message_size           = 1048576
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.service_request_dlq.arn
    maxReceiveCount     = 3
  })
}

# Worker Lambda
resource "aws_lambda_function" "service_request_worker" {
  function_name = "p4ServiceRequestWorker"
  role          = "arn:aws:iam::109375139212:role/service-role/p4ServiceRequestWorker-role-d7womzpj"
  runtime       = "python3.14"
  handler       = "lambda_function.lambda_handler"

  filename         = "${path.module}/p4ServiceRequestWorker.zip"
  source_code_hash = filebase64sha256("${path.module}/p4ServiceRequestWorker.zip")
}

# SQS trigger for worker Lambda
resource "aws_lambda_event_source_mapping" "service_request_worker" {
  event_source_arn = aws_sqs_queue.service_request_queue.arn
  function_name    = aws_lambda_function.service_request_worker.arn
  batch_size       = 1
}

#The moved block tells Terraform that the existing queue has been renamed in the configuration, not replaced in AWS
moved {
  from = aws_sqs_queue.service_request_processing
  to   = aws_sqs_queue.service_request_queue
}