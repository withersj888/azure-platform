# Azure Platform - Terraform Infrastructure

This repository contains the Terraform infrastructure code for the Azure Platform microservices architecture.

## Architecture Overview

The Azure Platform consists of the following components:

- **API Management (APIM)**: Central gateway for API management and routing
- **Azure Functions**: Two serverless functions for microservices
  - User Service: Manages user-related operations
  - Data Service: Handles data processing operations
- **Cosmos DB**: NoSQL database for storing microservices data
- **Key Vault**: Secure storage for secrets and connection strings
- **Application Insights**: Monitoring and observability
- **Log Analytics**: Centralized logging and analytics

## Directory Structure

```
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output values
│   ├── modules/                # Reusable Terraform modules
│   │   ├── api-management/     # API Management module
│   │   ├── azure-functions/    # Azure Functions module
│   │   ├── cosmos-db/          # Cosmos DB module
│   │   ├── key-vault/          # Key Vault module
│   │   └── application-insights/ # Application Insights module
│   └── environments/           # Environment-specific configurations
│       ├── dev/                # Development environment
│       ├── pre/                # Pre-production environment
│       └── prd/                # Production environment
└── pipelines/
    └── azure-pipelines.yml     # Azure DevOps pipeline
```

## Naming Convention

Resources follow a consistent naming pattern:
```
{project_name}-{environment}-{resource_type}-{random_suffix}
```

Example: `azplatform-dev-apim-abc123`

## Tagging Strategy

All resources are tagged with:
- `Environment`: dev/pre/prd
- `Project`: Project name
- `ManagedBy`: Terraform
- `DeployedBy`: Azure-DevOps
- `CreatedDate`: Resource creation date
- `Owner`: Platform Team
- `CostCenter`: Engineering
- `Purpose`: Microservices Platform

## Prerequisites

1. Azure subscription with appropriate permissions
2. Azure DevOps project set up
3. Service connection configured in Azure DevOps
4. Terraform state storage account created
5. Variable groups configured in Azure DevOps

## Deployment

### Manual Deployment

1. **Initialize Terraform:**
   ```bash
   cd terraform
   terraform init \
     -backend-config="resource_group_name=terraform-state-rg" \
     -backend-config="storage_account_name=terraformstateXXXXXX" \
     -backend-config="container_name=tfstate" \
     -backend-config="key=dev/terraform.tfstate"
   ```

2. **Plan deployment:**
   ```bash
   terraform plan -var-file="environments/dev/terraform.tfvars"
   ```

3. **Apply changes:**
   ```bash
   terraform apply -var-file="environments/dev/terraform.tfvars"
   ```

### Automated Deployment

The repository includes an Azure DevOps pipeline that automatically deploys to:
- **Development**: Triggered by commits to `develop` branch
- **Pre-production**: Triggered by commits to `main` branch
- **Production**: Requires manual approval after pre-production deployment

## Configuration

### Environment Variables

Set the following variables in Azure DevOps variable groups:

- `TF_STATE_RESOURCE_GROUP`: Resource group containing Terraform state storage
- `TF_STATE_STORAGE_ACCOUNT`: Storage account for Terraform state

### Environment-Specific Settings

Each environment has its own `terraform.tfvars` file with appropriate sizing:

- **Development**: Smaller, cost-optimized resources
- **Pre-production**: Medium-sized resources for testing
- **Production**: Larger, production-ready resources with premium features

## Security

- All secrets are stored in Azure Key Vault
- Function Apps use managed identities for Azure service authentication
- Network access controls are configured where applicable
- Soft delete is enabled on Key Vault for recovery

## Monitoring

- Application Insights provides application performance monitoring
- Log Analytics workspace centralizes logging
- Metric alerts are configured for key performance indicators
- Availability tests ensure service uptime

## Cost Optimization

- Consumption plans are used for Azure Functions
- Appropriate SKUs are selected based on environment
- Resource tagging enables cost tracking and allocation

## Support and Maintenance

For issues or questions regarding this infrastructure:

1. Check the Azure DevOps pipeline for deployment status
2. Review Application Insights for application health
3. Check Key Vault for secret management
4. Contact the Platform Team for support

## Contributing

1. Create a feature branch from `develop`
2. Make your changes following the established patterns
3. Test locally using `terraform plan`
4. Create a pull request to `develop`
5. After testing in dev, merge to `main` for pre-production deployment