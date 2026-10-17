
# Custom EventBridge event bus
resource "aws_cloudwatch_event_bus" "service_request" {
  name = "p4-service-request-bus"


}

# Rule that detects newly created service requests
resource "aws_cloudwatch_event_rule" "service_request_created" {
  name           = "p4-service-request-created-rule"
  description    = "Routes service-request-created events to SQS"
  event_bus_name = aws_cloudwatch_event_bus.service_request.name

  event_pattern = jsonencode({
    source      = ["p4.service-request"]
    detail-type = ["Service Request Created"]
  })


}
