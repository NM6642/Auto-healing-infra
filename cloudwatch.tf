# CloudWatch Alarm for Low CPU
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "LowCPUAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300      # 5 minutes
  statistic           = "Average"
  threshold           = 10       # 10% CPU
  alarm_description   = "Triggers when instance CPU < 10% for 5 minutes"
  dimensions = {
    InstanceId = aws_instance.autoheal_instance.id
  }

  # Trigger both email and Lambda
  alarm_actions = [
    aws_sns_topic.idle_instance_topic.arn,
    aws_sns_topic.autoheal_topic.arn
  ]
}
