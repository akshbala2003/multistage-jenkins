terraform {
  backend "s3" {
    bucket         = "tf-state-aks"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks-aks"
    encrypt        = true
  }
} 