resource "aws_batch_job_definition" "job" {
  name = local.prefix
  type = "container"
  platform_capabilities = [
    "FARGATE"
  ]
  container_properties = jsonencode({
    "image" : "${var.app_image}",
    "fargatePlatformConfiguration" : {
      "platformVersion" : "LATEST"
    },
    "resourceRequirements" : [
      { "type" : "VCPU", "value" : "0.25" },
      { "type" : "MEMORY", "value" : "512" }
    ],
    "environment" : [
      { "name" : "UPLOAD_BUCKET", "value" : "${aws_s3_bucket.batch_bucket.id}" }
    ],
    "executionRoleArn" : aws_iam_role.exec_role.arn,
    "jobRoleArn" : aws_iam_role.job_role.arn,
    "networkMode" : "awsvpc",
    "networkConfiguration" : {
      "assignPublicIp" : "ENABLED"
    }
  })
}

resource "aws_batch_job_queue" "job_queue" {
  name     = "${local.prefix}-q"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.batch_environment.arn
  ]
  depends_on = [
    aws_batch_compute_environment.batch_environment
  ]
}
