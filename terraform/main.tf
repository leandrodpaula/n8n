# This is the root Terraform directory for multi-cloud deployment.
# To deploy to a specific cloud provider, navigate to the respective subdirectory:
#
# For Google Cloud Platform (GCP):
#   cd gcp
#   # Ensure backend.tf in the gcp directory is configured for your GCS bucket.
#   terraform init
#   terraform plan
#   terraform apply
#
# For Amazon Web Services (AWS):
#   cd aws
#   # Ensure backend.tf in the aws directory is configured for your S3 bucket.
#   terraform init
#   terraform plan
#   terraform apply
#
# Each cloud provider directory (gcp/, aws/) contains its own Terraform configuration,
# including provider setup, variable definitions, and backend configuration.
# Shared variables are conceptually defined in shared/variables.tf but must be
# declared and valued within each cloud provider's context during execution.
