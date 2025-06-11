# n8n Infrastructure Deployment using Terraform

This project uses Terraform to provision the necessary infrastructure for deploying the n8n application. The Terraform configuration is structured to support deployment on both Google Cloud Platform (GCP) and Amazon Web Services (AWS).

## Prerequisites

*   **Terraform:** Ensure you have Terraform installed. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
*   **Cloud Provider CLI/Authentication:**
    *   **GCP:** Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) and authenticate with `gcloud auth application-default login`.
    *   **AWS:** Install the [AWS CLI](https://aws.amazon.com/cli/) and configure your credentials (e.g., via `aws configure`).

## Terraform Structure

The Terraform code is organized as follows:

*   `terraform/`: Root directory for Terraform configurations.
    *   `terraform/gcp/`: Contains all Terraform files specific to GCP deployment.
        *   `backend.tf`: Configures the GCS backend for Terraform state (requires manual setup of the GCS bucket).
        *   `variables.tf`: Declares variables used in the GCP configuration.
    *   `terraform/aws/`: Contains all Terraform files specific to AWS deployment.
        *   `backend.tf`: Contains a commented-out S3 backend configuration for Terraform state (requires manual setup of the S3 bucket and DynamoDB table if used).
        *   `variables.tf`: Declares variables used in the AWS configuration.
    *   `terraform/shared/`: Contains shared variable definitions conceptually, but variables must be declared and valued within each cloud's context.
    *   `terraform/main.tf`: Provides general guidance (this file).

## Deployment Instructions

### Google Cloud Platform (GCP)

1.  **Navigate to the GCP configuration directory:**
    ```bash
    cd terraform/gcp
    ```
2.  **Configure the Backend:**
    *   Open `backend.tf`.
    *   Ensure the `bucket` name under `backend "gcs"` is set to a GCS bucket you have created and have access to for storing the Terraform state.
3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
4.  **Review the Plan:**
    ```bash
    terraform plan -var="project_id=your-gcp-project-id" -var="gcp_region=your-gcp-region" # Add other variables as needed
    ```
    (Alternatively, create a `terraform.tfvars` file in the `terraform/gcp` directory to specify variable values.)
5.  **Apply the Configuration:**
    ```bash
    terraform apply -var="project_id=your-gcp-project-id" -var="gcp_region=your-gcp-region" # Add other variables as needed
    ```

### Amazon Web Services (AWS)

1.  **Navigate to the AWS configuration directory:**
    ```bash
    cd terraform/aws
    ```
2.  **Configure the Backend:**
    *   Open `backend.tf`.
    *   Uncomment the `backend "s3"` block.
    *   Set the `bucket` name to an S3 bucket you have created for Terraform state.
    *   Set the `region` to the region of your S3 bucket.
    *   (Optional) Configure `dynamodb_table` for state locking.
3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
4.  **Review the Plan:**
    ```bash
    terraform plan -var="aws_region=your-aws-region" # Add other variables as needed (e.g., aws_account_id if required by your setup)
    ```
    (Alternatively, create a `terraform.tfvars` file in the `terraform/aws` directory to specify variable values.)
5.  **Apply the Configuration:**
    ```bash
    terraform apply -var="aws_region=your-aws-region" # Add other variables as needed
    ```

## Variables

Each cloud-specific directory (`terraform/gcp` and `terraform/aws`) has its own `variables.tf` file. Common variables like `service_name` and `environment` are also declared here. You will need to provide values for these variables either through command-line flags (`-var="key=value"`) or by creating a `.tfvars` file in the respective directory.

The `terraform/shared/variables.tf` file outlines variables that are conceptually common across both cloud platforms.