
# role assigned to ECS container
resource "aws_iam_role" "exec_role" {
  name = "${local.prefix}-task-exec-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Principal : {
          Service : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "exec_role_attachment" {
  role       = aws_iam_role.exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# role assigned to job definition
resource "aws_iam_role" "job_role" {
  name = "${local.prefix}-job-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Principal : {
          Service : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "${local.prefix}-resource-access"
    policy = jsonencode({
      Version : "2012-10-17"
      Statement = [
        {
          Action = ["s3:*"]
          Effect = "Allow"
          Resource : [
            aws_s3_bucket.batch_bucket.arn,
            "${aws_s3_bucket.batch_bucket.arn}/*"
          ]
        }
      ]
    })
  }
}
