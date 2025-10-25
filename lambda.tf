
# Lambda Execution Role

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_autoheal_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Inline policy for Lambda to allow EC2 reboot & CloudWatch logs
resource "aws_iam_role_policy" "lambda_exec_inline_policy" {
  name = "lambda_autoheal_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:RebootInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}


# Lambda Function

resource "aws_lambda_function" "autoheal_lambda" {
  function_name = "AutoHealEC2"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename      = "lambda.zip"

  environment {
    variables = {
      REGION = "eu-north-1"  # Your region which you used 
    }
  }
}

# SNS Subscription to trigger Lambda

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.autoheal_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.autoheal_lambda.arn
}
