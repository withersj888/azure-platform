#!/bin/bash
# Terraform deployment script for Azure Platform

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Check if environment parameter is provided
if [ $# -eq 0 ]; then
    print_color $RED "Error: Environment parameter is required"
    print_color $YELLOW "Usage: $0 <environment> [action]"
    print_color $YELLOW "Environments: dev, pre, prd"
    print_color $YELLOW "Actions: plan (default), apply, destroy"
    exit 1
fi

ENVIRONMENT=$1
ACTION=${2:-plan}

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|pre|prd)$ ]]; then
    print_color $RED "Error: Invalid environment '$ENVIRONMENT'"
    print_color $YELLOW "Valid environments: dev, pre, prd"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(plan|apply|destroy|init)$ ]]; then
    print_color $RED "Error: Invalid action '$ACTION'"
    print_color $YELLOW "Valid actions: init, plan, apply, destroy"
    exit 1
fi

print_color $BLUE "=== Azure Platform Terraform Deployment ==="
print_color $GREEN "Environment: $ENVIRONMENT"
print_color $GREEN "Action: $ACTION"
print_color $BLUE "=========================================="

# Change to terraform directory
cd "$(dirname "$0")/../terraform"

# Check if required environment variables are set
if [ "$ACTION" != "init" ]; then
    if [ -z "$TF_STATE_RESOURCE_GROUP" ] || [ -z "$TF_STATE_STORAGE_ACCOUNT" ]; then
        print_color $YELLOW "Warning: Terraform state variables not set"
        print_color $YELLOW "Please set TF_STATE_RESOURCE_GROUP and TF_STATE_STORAGE_ACCOUNT"
        print_color $YELLOW "Using local state instead..."
        BACKEND_CONFIG=""
    else
        BACKEND_CONFIG="-backend-config=\"resource_group_name=$TF_STATE_RESOURCE_GROUP\" -backend-config=\"storage_account_name=$TF_STATE_STORAGE_ACCOUNT\" -backend-config=\"container_name=tfstate\" -backend-config=\"key=$ENVIRONMENT/terraform.tfstate\""
    fi
fi

# Initialize Terraform
if [ "$ACTION" = "init" ] || [ ! -d ".terraform" ]; then
    print_color $BLUE "Initializing Terraform..."
    if [ -n "$BACKEND_CONFIG" ]; then
        eval "terraform init $BACKEND_CONFIG"
    else
        terraform init -backend=false
    fi
fi

# Execute the requested action
case $ACTION in
    "plan")
        print_color $BLUE "Creating Terraform plan for $ENVIRONMENT..."
        terraform plan -var-file="environments/$ENVIRONMENT/terraform.tfvars" -out="tfplan-$ENVIRONMENT"
        print_color $GREEN "Plan created successfully!"
        print_color $YELLOW "To apply: terraform apply tfplan-$ENVIRONMENT"
        ;;
    "apply")
        if [ ! -f "tfplan-$ENVIRONMENT" ]; then
            print_color $YELLOW "No plan file found. Creating plan first..."
            terraform plan -var-file="environments/$ENVIRONMENT/terraform.tfvars" -out="tfplan-$ENVIRONMENT"
        fi
        print_color $BLUE "Applying Terraform changes for $ENVIRONMENT..."
        terraform apply "tfplan-$ENVIRONMENT"
        print_color $GREEN "Deployment completed successfully!"
        ;;
    "destroy")
        print_color $YELLOW "WARNING: This will destroy all resources in $ENVIRONMENT environment!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform destroy -var-file="environments/$ENVIRONMENT/terraform.tfvars"
            print_color $GREEN "Resources destroyed successfully!"
        else
            print_color $YELLOW "Destroy cancelled."
        fi
        ;;
    "init")
        print_color $GREEN "Terraform initialization completed!"
        ;;
esac

print_color $BLUE "=========================================="
print_color $GREEN "Operation completed!"