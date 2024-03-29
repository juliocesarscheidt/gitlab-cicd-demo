# Instructions on creating an AWS User to be used on CI to interact with S3

```bash

# create a bucket
export S3_BUCKET_NAME="bitcoin-bucket-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | tr '[:upper:]' '[:lower:]' | head -n 1)"
echo "${S3_BUCKET_NAME}"

export AWS_REGION=us-east-1
export AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account')

aws s3api create-bucket --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}" --acl private

# create policy to user interact with S3
cat <<EOF > tmp_policy_s3_user.json
{
  "Version": "2012-10-17",
  "Statement": [{
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "arn:aws:s3:::*/*"
    },
    {
      "Sid": "VisualEditor2",
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "*"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name "s3-user-gitlab-cicd-demo-policy" \
  --policy-document file://tmp_policy_s3_user.json
rm -f tmp_policy_s3_user.json

# "arn:aws:iam::${AWS_ACCOUNT}:policy/s3-user-gitlab-cicd-demo-policy"

# create an user to interact with S3
aws iam create-user --user-name "s3-user-gitlab-cicd-demo"

# attach policies to user
aws iam attach-user-policy \
  --user-name "s3-user-gitlab-cicd-demo" \
  --policy-arn "arn:aws:iam::${AWS_ACCOUNT}:policy/s3-user-gitlab-cicd-demo-policy"

# create an access key to use on CI
export ACCESS_KEY=$(aws iam create-access-key --user-name "s3-user-gitlab-cicd-demo" | jq -r '.AccessKey')
echo "${ACCESS_KEY}"
{
  "UserName": "s3-user-gitlab-cicd-demo",
  "AccessKeyId": "",
  "Status": "Active",
  "SecretAccessKey": "",
  "CreateDate": ""
}

# save credentials on secrets manager
aws secretsmanager create-secret \
  --region "${AWS_REGION}" \
  --description "Credentials for IAM user grafana-monitoring-user - Grafana user for AWS" \
  --name "/iam/user/credentials/s3-user-gitlab-cicd-demo" \
  --secret-string '{"AWS_ACCESS_KEY_ID":"'$(echo "${ACCESS_KEY}" | jq -r '.AccessKeyId')'","AWS_SECRET_ACCESS_KEY":"'$(echo "${ACCESS_KEY}" | jq -r '.SecretAccessKey')'"}'
```
