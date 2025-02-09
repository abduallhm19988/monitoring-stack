terraform {
  backend "s3" {
    bucket = "abD"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
