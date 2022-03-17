resource "aws_s3_bucket" "batch_bucket" {
  bucket        = local.prefix
  force_destroy = true
}
