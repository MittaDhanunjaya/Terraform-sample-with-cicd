resource "aws_iam_role" "glue_role"{
  name = "aws-iam-new-glue-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }]
  })
}

#Attach IAM Policy to Glue role
resource "aws_iam_role_policy_attachment" "glue_policy_Attachment"{
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role = aws_iam_role.glue_role.name
}
resource "aws_iam_policy_attachment" "s3_full_access_attachment" {
  name       = "YourGlueRole-s3-full-access-attachment"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}