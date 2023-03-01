> https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html

> https://docs.gitlab.com/ee/user/infrastructure/iac/mr_integration.html

```bash
export PROJECT_ID=""
export TF_USERNAME=""
export TF_PASSWORD=""
export TF_ADDRESS="https://gitlab.com/api/v4/projects/${PROJECT_ID}/terraform/state/state"

export AWS_REGION="us-east-1"
export TF_VAR_domain_name="bitcoin-bucket-web-$AWS_REGION"
export TF_VAR_bucket_name="bitcoin-bucket-web-$AWS_REGION"

terraform init \
  -backend-config=address=${TF_ADDRESS} \
  -backend-config=lock_address=${TF_ADDRESS}/lock \
  -backend-config=unlock_address=${TF_ADDRESS}/lock \
  -backend-config=username=${TF_USERNAME} \
  -backend-config=password=${TF_PASSWORD} \
  -backend-config=lock_method=POST \
  -backend-config=unlock_method=DELETE \
  -backend-config=retry_wait_min=5

terraform validate

terraform fmt -write=true -recursive

terraform plan

terraform apply -auto-approve

terraform destroy -auto-approve
```
