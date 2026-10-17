

# Main service request Lambda role
resource "aws_iam_role" "service_request" {
  name = "myServiceRequestFunction-role-cj9cyoda"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# External API Lambda role
resource "aws_iam_role" "external_api" {
  name = "p4ExternalApiIntegration-role-uw2x2cta"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Worker Lambda role
resource "aws_iam_role" "service_request_worker" {
  name = "p4ServiceRequestWorker-role-d7womzpj"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


# -------------- Inline Policy Documents ------------------

# Main Lambda: DynamoDB access
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "p4-dynamodb-access"
  role = aws_iam_role.service_request.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "VisualEditor0"
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ]
      Resource = "arn:aws:dynamodb:ap-southeast-1:109375139212:table/p4-service-request-table"
    }]
  })
}

# Main Lambda: publish events to EventBridge
resource "aws_iam_role_policy" "publish_events" {
  name = "publish-service-request-events"
  role = aws_iam_role.service_request.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "PublishServiceRequestEvents"
      Effect   = "Allow"
      Action   = "events:PutEvents"
      Resource = "arn:aws:events:ap-southeast-1:109375139212:event-bus/p4-service-request-bus"
    }]
  })
}

# Worker Lambda: SQS permissions
resource "aws_iam_role_policy" "worker_sqs_access" {
  name = "worker-sqs-access"
  role = aws_iam_role.service_request_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "VisualEditor0"
      Effect = "Allow"
      Action = [
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:ReceiveMessage",
        "sqs:GetQueueAttributes"
      ]
      Resource = "arn:aws:sqs:ap-southeast-1:109375139212:p4-service-request-queue"
    }]
  })
}


# Attaching existing Lambda execution policies
resource "aws_iam_role_policy_attachment" "service_request_basic" {
  role       = aws_iam_role.service_request.name
  policy_arn = "arn:aws:iam::109375139212:policy/service-role/AWSLambdaBasicExecutionRole-c1b2e5cc-371a-4677-b57a-4fcf1fc8b060"
}

resource "aws_iam_role_policy_attachment" "external_api_basic" {
  role       = aws_iam_role.external_api.name
  policy_arn = "arn:aws:iam::109375139212:policy/service-role/AWSLambdaBasicExecutionRole-d5a3ebf5-b78b-4af6-943b-5fbbe1dd1e0e"
}

resource "aws_iam_role_policy_attachment" "worker_basic" {
  role       = aws_iam_role.service_request_worker.name
  policy_arn = "arn:aws:iam::109375139212:policy/service-role/AWSLambdaBasicExecutionRole-e028a0d0-e03b-4d3b-a59d-3150e8f7e565"
}
