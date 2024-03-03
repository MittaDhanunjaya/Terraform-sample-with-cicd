resource "aws_glue_catalog_database" "example_database"{
  name = "adalkh-new-database"
}
resource "aws_glue_crawler" "sample_s3_glue_crawler" {
  name = "adalkh-glue-new-crawler"
  role = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.example_database.name
  s3_target{
    path = "s3://adalkh-glue-s3-bucket-new-dev/sample_data/"
  }


#Create Glue Table

  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${aws_glue_crawler.sample_s3_glue_crawler.name}"
  }
}
