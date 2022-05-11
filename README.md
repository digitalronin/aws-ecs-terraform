# AWS ECS Demo

Demonstrate how to deploy a containerised application to Amazon ECS using terraform.

Initially based on [this blog
post](https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/)
and [this one](https://blog.ulysse.io/post/setting-up-ecs-with-terraform/)

This creates an ECS cluster, and a task which runs a rails application web
server image, along with a load-balancer and all the networking stuff to make
it accessible from the internet.

It also creates and enables the rails app. to access a Redis cluster (of 1
node), a Postgres RDS database, and sets up cloudwatch logging.

## Pre-requisites

- AWS account
- Terraform 1.1.9
- Docker (for the AWS CLI)
- [Overcommit](https://github.com/sds/overcommit) (for git commit hooks)

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
with curl and see the home page, and the log entries in Cloudwatch.


```
curl $(terraform output -raw load_balancer_ip)
```

## Update docker image

The ECS task deploys a docker image from the ECR.

To push a new docker image:

1. Tag your image with the ECR URI

e.g. To tag a docker image which is locally tagged as
`digitalronin/nodejs-hello-world` with a git commit reference of 47790ea:

```
ecr=$(terraform output -raw ecr-uri)
docker tag digitalronin/nodejs-hello-world:latest $ecr:47790ea
```

2. Login to the ECR

```
ecr=$(terraform output -raw ecr-uri)
aws ecr --region us-east-2 get-login-password | docker login --username AWS --password-stdin $ecr
```

3. Push the image

```
ecr=$(terraform output -raw ecr-uri)
docker push $ecr:47790ea
```

### Deploy new docker image

Change the `TF_VAR_image_tag` environment variable to the new tag value,
i.e.

```
export TF_VAR_image_tag=47790ea
```

...then run `terraform apply`

Changes should take effect in a few minutes. NB: Requests will be served by
both the old and new versions of the docker image, for a minute or two.

## Clean up

```
terraform destroy
```

## TODO

- add an initialisation task to run once per deployment (e.g. `rails db:migrate`)
- add SSL
- configure autoscaling
- setup CD
- lock down the networking side
- reduce deployer IAM permissions to a minimum
