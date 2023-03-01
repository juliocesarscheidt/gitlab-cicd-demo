# gitlab-cicd-demo

In order to run the pipeline, set the following variables on CI/CD env:

```bash
# aws
export AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="AWS_SECRET_ACCESS_KEY"
export AWS_REGION="us-east-1"
# mongo
export MONGO_URI="mongodb+srv://<user>:<password>@<host>/?maxPoolSize=1&retryWrites=true&w=majority"
export MONGO_DATABASE="bitcoin"
# s3
export S3_BUCKET_NAME="bitcoin-bucket-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | tr '[:upper:]' '[:lower:]' | head -n 1)"
```

## Application architecture
![Architecture](./architecture/gitlab-cicd-demo.drawio.png)
