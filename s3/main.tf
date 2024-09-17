variable "bucket-name" {}
variable "app" {}

output "s3-bucket-id" {
  value = aws_s3_bucket.mern-app-bucket.id
}

output "s3-object-id" {
  value = aws_s3_object.s3-obejct.id
}

resource "aws_s3_bucket" "mern-app-bucket" {
  bucket = var.bucket-name

  tags = {
    Name = "My backend bucket"
  }

}

# resource "aws_s3_bucket_acl" "my-bucket-acl" {
#   bucket = aws_s3_bucket.mern-app-bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "my-bucket-versioning" {
  bucket = aws_s3_bucket.mern-app-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "s3-obejct" {
  bucket = aws_s3_bucket.mern-app-bucket.id
  key    = var.app
  # source = var.app
}