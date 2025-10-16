resource "aws_s3_bucket" "lambda-s3-bucket" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    tomap({
      "Name"        = "lambda-s3-bucket"
    })
  )
}

# data "aws_iam_policy_document" "bucket-iam-policy" {
#   statement {
#     sid = "bucket-allow-private-ips"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions = ["s3:GetObject"]

#     resources = ["${aws_s3_bucket.lambda-s3-bucket.arn}/*"]

#     condition {
#       test = "IpAddress"
#       variable = "aws:VpcSourceIp"
#       values = ["10.10.0.0/16"]
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "api-bucket-pub" {
#   bucket = aws_s3_bucket.lambda-s3-bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_policy" "bucket-iam-attach" {
#   bucket = aws_s3_bucket.lambda-s3-bucket.id
#   policy = data.aws_iam_policy_document.bucket-iam-policy.json
# }