variable "region" {
    type = string
    default = "us-east-1"
}

variable "tags" {
  type = map
  default = {
    "Name"                        = "lambda-to-s3"
  }
}

variable "bucket_name" {
  type        = string
  default     = "lambda-s3-bucket"
}