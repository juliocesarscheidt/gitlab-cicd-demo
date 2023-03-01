
```bash
export PROJECT_ID=""
export TF_HTTP_USERNAME=""
export TF_HTTP_PASSWORD=""
export TF_HTTP_ADDRESS="https://gitlab.com/api/v4/projects/${PROJECT_ID}/terraform/state/state"
export TF_HTTP_RETRY_WAIT_MIN="1"

export AWS_REGION="us-east-1"
export TF_VAR_domain_name="bitcoin-bucket-web-$AWS_REGION"
export TF_VAR_bucket_name="bitcoin-bucket-web-$AWS_REGION"


terraform init \
  -backend-config=address=${TF_HTTP_ADDRESS} \
  -backend-config=lock_address=${TF_HTTP_ADDRESS}/lock \
  -backend-config=unlock_address=${TF_HTTP_ADDRESS}/lock \
  -backend-config=username=${TF_HTTP_USERNAME} \
  -backend-config=password=${TF_HTTP_PASSWORD} \
  -backend-config=lock_method=POST \
  -backend-config=unlock_method=DELETE \
  -backend-config=retry_wait_min=${TF_HTTP_RETRY_WAIT_MIN}


terraform validate

terraform fmt -write=true -recursive

terraform plan

terraform apply -auto-approve
```
