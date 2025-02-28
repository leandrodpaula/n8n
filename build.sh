#!/bin/bash

# Export environment variables
 export TF_VAR_service_name="tutto-flows"
 export TF_VAR_project_id="tutto-assistants"
 export TF_VAR_environment="hml"
 export TF_VAR_region="southamerica-east1"

 cd terraform

 # Initialize Terraform
terraform init -backend-config="bucket=${TF_VAR_project_id}-tfstate" -backend-config="prefix=${TF_VAR_service_name}/${TF_VAR_environment}" -reconfigure 



# Apply the Terraform configuration
if [ "$1" == "apply" ]; then
  terraform apply -auto-approve
fi

# Destroy the Terraform configuration
if [ "$1" == "destroy" ]; then
  terraform destroy -auto-approve
fi

