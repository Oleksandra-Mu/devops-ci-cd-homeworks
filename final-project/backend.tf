terraform {
  backend "s3" {
    bucket         = "omukhamedova"
    key            = "final/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}