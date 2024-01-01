resource "aws_s3_bucket" "b03" {
  bucket = "kops0320-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
