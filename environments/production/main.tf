terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "=4.55.0"
    }
  }
  backend "http" {
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "bucket_name" {
  type        = string
  description = "The name for the S3 bucket"
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  tags   = {}
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
}

resource "aws_s3_bucket_cors_configuration" "web_bucket_cors_configuration" {
  bucket = aws_s3_bucket.web_bucket.id
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = []
    expose_headers  = []
  }
}

resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "web_bucket_website_configuration" {
  bucket = aws_s3_bucket.web_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_versioning" "web_bucket_versioning" {
  bucket = aws_s3_bucket.web_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "web_index" {
  bucket        = aws_s3_bucket.web_bucket.id
  key           = "index.html"
  content_type  = "text/html"
  source        = "../../src/index.html"
  etag          = filemd5("../../src/index.html")
  acl           = "public-read"
  force_destroy = true
}

resource "aws_s3_object" "web_404" {
  bucket        = aws_s3_bucket.web_bucket.id
  key           = "404.html"
  content_type  = "text/html"
  source        = "../../src/404.html"
  etag          = filemd5("../../src/404.html")
  acl           = "public-read"
  force_destroy = true
}

output "website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.web_bucket_website_configuration.website_endpoint}"
}
