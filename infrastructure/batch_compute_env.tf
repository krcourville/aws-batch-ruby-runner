# NOTE: this resource will already exist.
# It should be imported so that retention can be applied.
resource "aws_cloudwatch_log_group" "aws_batch_job_log_group" {
  name              = "/aws/batch/job"
  retention_in_days = 5
}


resource "aws_security_group" "batch_security_group" {
  name   = "${local.prefix}-batch-env-sg"
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_batch_compute_environment" "batch_environment" {
  compute_environment_name = local.prefix

  compute_resources {
    max_vcpus = 16

    security_group_ids = [
      aws_security_group.batch_security_group.id
    ]

    subnets = data.aws_subnet_ids.all_default_subnets.ids
    type    = "FARGATE"
  }

  service_role = aws_iam_role.runner_batch_svc_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.runner_batch_svc_role_attach_batch_service_role]
}
