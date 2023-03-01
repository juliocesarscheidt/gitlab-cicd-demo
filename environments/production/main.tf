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
  region = "us-east-1"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST", "OPTIONS"]
    allowed_origins = ["http://${var.domain_name}"]
    max_age_seconds = 3000
  }
  tags = {}
}

resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "web_bucket_configuration" {
  bucket = aws_s3_bucket.web_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
}

resource "aws_s3_object" "web_index" {
  bucket = aws_s3_bucket.web_bucket.id
  key    = "index.html"
  source = "../../src/index.html"
  acl    = "public-read"
}

resource "aws_s3_object" "web_404" {
  bucket = aws_s3_bucket.web_bucket.id
  key    = "404.html"
  source = "../../src/404.html"
  acl    = "public-read"
}
