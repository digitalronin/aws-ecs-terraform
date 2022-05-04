# AWS ECS Demo

Demonstrate how to deploy a containerised application to Amazon ECS using terraform.

Initially based on [this blog
post](https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/)
and [this one](https://blog.ulysse.io/post/setting-up-ecs-with-terraform/)

This creates an ECS cluster, and a task which runs a "hello-world" web server
image, along with a load-balancer and all the networking stuff to make it
accessible from the internet. It also sets up cloudwatch logging.

## Pre-requisites

- AWS account
- Terraform 1.1.9
- Docker (for the AWS CLI)

## Setup

- Use the AWS web interface to create an IAM user with admin permissions (TODO:
  reduce to the minimum set of permissions required),  and download the Access
  Key and Secret Key.

- Copy `dotenv.example` to `.env` and replace the dummy values with the real
  credentials.

- Set an alias to run the AWS CLI via docker

```
. .env
alias aws="docker run --rm -ti \
  -e AWS_ACCESS_KEY_ID=$TF_VAR_aws_access_key \
  -e AWS_SECRET_ACCESS_KEY=$TF_VAR_aws_secret_key \
  -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli:2.5.7"
```

## Create/Update infrastructure

```
terraform init
terraform apply
```

This will output the public DNS name of the load-balancer. You can hit this
with curl and see the "Hello World" response, and the log entries in
Cloudwatch.

## Clean up

```
terraform destroy
```

## TODO

- add a pre-commit hook to run `terraform fmt`
