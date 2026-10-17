
# Lambda CloudWatch log groups

resource "aws_cloudwatch_log_group" "service_request" {
  name = "/aws/lambda/myServiceRequestFunction"
}

resource "aws_cloudwatch_log_group" "external_api" {
  name = "/aws/lambda/p4ExternalApiIntegration"
}

resource "aws_cloudwatch_log_group" "service_request_worker" {
  name = "/aws/lambda/p4ServiceRequestWorker"
}

# Alarm: worker Lambda errors

resource "aws_cloudwatch_metric_alarm" "worker_lambda_errors" {
  alarm_name          = "p4-worker-lambda-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  actions_enabled     = true

  dimensions = {
    FunctionName = "p4ServiceRequestWorker"
  }
}

# Alarm: SQS message backlog

resource "aws_cloudwatch_metric_alarm" "sqs_message_backlog" {
  alarm_name          = "p4-sqs-message-backlog"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  actions_enabled     = true

  dimensions = {
    QueueName = "p4-service-request-queue"
  }
}
