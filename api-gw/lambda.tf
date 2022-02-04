resource "aws_lambda_function" "http_crud_lambda" {
  function_name    = "http-crud-tutorial-function-mro"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.handler"
  filename         = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  architectures    = ["arm64"]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name               = "http-crud-tutorial-role-mro"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "dynamodb-access-rw" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:eu-central-1:833515639939:table/*"
    ]
  }
}

resource "aws_iam_policy" "dynamodb-access-rw" {
  name   = "dynamodb-access-rw-mro"
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.dynamodb-access-rw.json
}

resource "aws_iam_role_policy_attachment" "dynamodb-access-rw" {
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = aws_iam_policy.dynamodb-access-rw.arn
}

resource "aws_iam_role_policy_attachment" "basic-exec-role" {
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

