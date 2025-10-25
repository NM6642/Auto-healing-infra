# SNS topic for idle instance email alerts
resource "aws_sns_topic" "idle_instance_topic" {
  name = "IdleInstanceTopic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.idle_instance_topic.arn
  protocol  = "email"
  endpoint  = "-------@gmail.com"  # Replace with your email :)
}

# SNS topic to trigger Lambda for auto-healing
resource "aws_sns_topic" "autoheal_topic" {
  name = "AutoHealTopic"
}

