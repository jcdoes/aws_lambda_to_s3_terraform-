data "archive_file" "archive-zip" {
    type        = "zip"
    output_path = "archive_zip.zip"
    source_dir  = "archive_zip"
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    effect          = "Allow"
    principals {
      type          = "Service"
      identifiers   = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam-for-lambda" {
  name               = "iam-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json
  inline_policy {
    name = "lambda_s3_access"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
                
          ],
          "Resource": "*"
        }
      ]
    })
  }
}

resource "aws_lambda_layer_version" "lambda_layer_shared_libs" {
  filename              = "python.zip"
  layer_name            = "shared-python"
  compatible_runtimes   = ["python3.10"]
}

resource "aws_lambda_function" "lambda-function" {
  filename              = "${data.archive_file.archive-zip.output_path}"
  source_code_hash      = "${data.archive_file.archive-zip.output_base64sha256}"
  function_name         = "lambda-fastapi-app"
  role                  = aws_iam_role.iam-for-lambda.arn
  handler               = "app.handler"
  runtime               = "python3.10"
  timeout               = 300
  layers                = [aws_lambda_layer_version.lambda_layer_shared_libs.arn]
  environment {
    variables = {
      API_KEY = var.api-key
    }
  }
  tags = merge(
    var.tags,
    tomap({
      "Name"           = "lambda-function"
    })
  )
}
