

# Instructions on creating an AWS User to be used on CI to interact with S3

```bash

# create a bucket
export S3_BUCKET_NAME="bitcoin-bucket-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | tr '[:upper:]' '[:lower:]' | head -n 1)"
echo "${S3_BUCKET_NAME}"

export AWS_REGION=sa-east-1

aws s3api create-bucket --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}" \
  --create-bucket-configuration LocationConstraint="${AWS_REGION}" --acl private



# create policy to user interact with S3
cat <<EOF > tmp_policy_s3_user.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${S3_BUCKET_NAME}/bitcoin/*"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name "s3-user-gitlab-cicd-demo-policy" \
  --policy-document file://tmp_policy_s3_user.json
rm tmp_policy_s3_user.json

# "arn:aws:iam::${AWS_ACCOUNT}:policy/s3-user-gitlab-cicd-demo-policy"

# create an user to interact with S3
aws iam create-user --user-name "s3-user-gitlab-cicd-demo"


# attach policies to user
aws iam attach-user-policy \
  --user-name "s3-user-gitlab-cicd-demo" \
  --policy-arn "arn:aws:iam::${AWS_ACCOUNT}:policy/s3-user-gitlab-cicd-demo-policy"


# create an access key to use on CI
aws iam create-access-key --user-name "s3-user-gitlab-cicd-demo"
{
    "AccessKey": {
        "UserName": "s3-user-gitlab-cicd-demo",
        "AccessKeyId": "",
        "Status": "Active",
        "SecretAccessKey": "",
        "CreateDate": ""
    }
}
```
