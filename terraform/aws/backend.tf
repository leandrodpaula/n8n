# terraform {
#   backend "s3" {
#     bucket         = "your-aws-tfstate-bucket-name" # Replace with your S3 bucket name
#     key            = "terraform/state"
#     region         = "us-east-1"                  # Replace with your S3 bucket region
#     # encrypt        = true # Optional: enable server-side encryption
#     # dynamodb_table = "your-terraform-lock-table" # Optional: for state locking
#   }
# }
