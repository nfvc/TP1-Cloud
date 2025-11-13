terraform {
  required_providers {
    minio = {
      source  = "terraform-provider-minio/minio"
      version = ">= 3.1.0"
    }
  }
}

provider "minio" {
  minio_server = "127.0.0.1:9000"
  minio_user = "minioadmin"
  minio_password = "minioadmin"
}

resource "minio_s3_bucket" "tp1_bucket" {
  bucket = "tp1-cloud-bucket"
  acl    = "private"
}

resource "minio_s3_bucket" "web_bucket" {
  bucket = "webbucket"
  acl = "public"
}

resource "minio_s3_object" "index_html" {
  bucket_name = minio_s3_bucket.web_bucket.bucket
  object_name = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "minio_s3_object" "style_css" {
  bucket_name = minio_s3_bucket.web_bucket.bucket
  object_name = "style.css"
  source = "style.css"
  content_type = "text/css"
}

resource "minio_s3_bucket_policy" "web_bucket_policy" {
  bucket = minio_s3_bucket.web_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::${minio_s3_bucket.web_bucket.bucket}/*"]
      }
    ]
  })
}
