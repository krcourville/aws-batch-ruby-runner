variable "region" {
  type    = string
  default = "us-east-1"
}

variable "app_env" {
  type    = string
  default = "dev"
}

variable "org" {
  type        = string
  default     = "org"
  description = "Short id for organization to help namespace global resources, such as s3 buckets"
}

variable "team" {
  type        = string
  default     = "alpha"
  description = "Team to associate with resources"
}

variable "code_repo" {
  type        = string
  default     = "https://github.com/krcourville/aws-batch-runner"
  description = "Source code associated to this deployment"
}

variable "app_name" {
  type    = string
  default = "runner"
}

variable "app_image" {
  type        = string
  description = "Docker hub tag. Example: krcourville/ruby-runner:1.0.0"
}
