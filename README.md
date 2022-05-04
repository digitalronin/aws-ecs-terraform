# AWS ECS Demo

Demonstrate how to deploy a containerised application to Amazon ECS using terraform.

## Pre-requisites

- AWS account
- Terraform 1.1.9
- Docker (for the AWS CLI)

## Setup

- Use the AWS web interface to create an IAM user with full permissions (TODO:
  reduce to the minimum set of permissions required),  and download the Access
  Key and Secret Key.

- Copy `dotenv.example` to `.env` and replace the dummy values with the real
  credentials.

- Set an alias to run the AWS CLI via docker

```
. .env
alias aws="docker run --rm -ti \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli:2.5.7"
```

