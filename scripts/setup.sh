#!/bin/bash
set -e

# ──────────────────────────────────────────────────────────────────────────────
# AWS Governed Lakehouse — Environment Bootstrap
# Resolves live AWS resource IDs and exports Terraform variables.
# ──────────────────────────────────────────────────────────────────────────────

export PROJECT_PREFIX="gov-lakehouse"
export AWS_DEFAULT_REGION="us-east-1"
export VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=$PROJECT_PREFIX --query Vpcs[].VpcId --output text)

# ── Terraform Variables ──────────────────────────────────────────────────────
echo "export TF_VAR_project=$PROJECT_PREFIX" >> $HOME/.bashrc
echo "export TF_VAR_region=$AWS_DEFAULT_REGION" >> $HOME/.bashrc
echo "export TF_VAR_vpc_id=$VPC_ID" >> $HOME/.bashrc
echo "export TF_VAR_public_subnet_a_id=$(aws ec2 describe-subnets --filters "Name=tag:aws:cloudformation:logical-id,Values=PublicSubnetA" "Name=vpc-id,Values=$VPC_ID" --output text --query "Subnets[].SubnetId")" >> $HOME/.bashrc
echo "export TF_VAR_data_lake_name=$PROJECT_PREFIX-$(aws sts get-caller-identity --query 'Account' --output text)-$AWS_DEFAULT_REGION-data-lake" >> $HOME/.bashrc

echo "export TF_VAR_db_sg_id=$(aws rds describe-db-instances --db-instance-identifier $PROJECT_PREFIX-rds --output text --query "DBInstances[].VpcSecurityGroups[].VpcSecurityGroupId")" >> $HOME/.bashrc
echo "export TF_VAR_source_host=$(aws rds describe-db-instances --db-instance-identifier $PROJECT_PREFIX-rds --output text --query "DBInstances[].Endpoint.Address")" >> $HOME/.bashrc
echo "export TF_VAR_source_port=3306" >> $HOME/.bashrc
echo "export TF_VAR_source_database=\"classicmodels\"" >> $HOME/.bashrc

# IMPORTANT: Set these securely via environment variables or AWS Secrets Manager
echo "export TF_VAR_source_username=\"\${DB_USERNAME:?Set DB_USERNAME before running}\"" >> $HOME/.bashrc
echo "export TF_VAR_source_password=\"\${DB_PASSWORD:?Set DB_PASSWORD before running}\"" >> $HOME/.bashrc

echo "export TF_VAR_curated_db_name=\"curated_zone\"" >> $HOME/.bashrc
echo "export TF_VAR_curated_db_ratings_table=\"ratings\"" >> $HOME/.bashrc
echo "export TF_VAR_curated_db_ml_table=\"ratings_for_ml\"" >> $HOME/.bashrc
echo "export TF_VAR_ratings_new_column_name=\"ratingtimestamp\"" >> $HOME/.bashrc
echo "export TF_VAR_ratings_new_column_type=\"string\"" >> $HOME/.bashrc
echo "export TF_VAR_presentation_db_name=\"presentation_zone\"" >> $HOME/.bashrc
echo "export TF_VAR_presentation_db_table_sales=\"sales_report\"" >> $HOME/.bashrc
echo "export TF_VAR_presentation_db_table_employee=\"employee_report\"" >> $HOME/.bashrc
echo "export TF_VAR_source_data_lake_name=$PROJECT_PREFIX-$(aws sts get-caller-identity --query 'Account' --output text)-$AWS_DEFAULT_REGION-source" >> $HOME/.bashrc
echo "export TF_VAR_scripts_bucket_name=$PROJECT_PREFIX-$(aws sts get-caller-identity --query 'Account' --output text)-$AWS_DEFAULT_REGION-scripts" >> $HOME/.bashrc
echo "export TF_VAR_glue_role_name=$PROJECT_PREFIX-glue-role" >> $HOME/.bashrc

source $HOME/.bashrc

# ── Configure Terraform Backend ──────────────────────────────────────────────
script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
sed -i "s/<terraform_state_file>/$TF_VAR_project-$(aws sts get-caller-identity --query 'Account' --output text)-us-east-1-terraform-state/g" "$script_dir/../terraform/backend.tf"

echo "Setup completed successfully. All environment variables and Terraform backend configurations have been set."