# role assigned to Batch Compute Environment
resource "aws_iam_role" "runner_batch_svc_role" {
  name = "${local.prefix}-batch-svc-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Principal : {
          Service : "batch.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "runner_batch_svc_role_attach_batch_service_role" {
  role       = aws_iam_role.runner_batch_svc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}
