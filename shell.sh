#!/bin/bash

set -euo pipefail

source .env

if [ -t 1 ]; then
  usetty=-it
else
  usetty=
fi

docker run --rm \
  -e AWS_ACCESS_KEY_ID=$TF_VAR_aws_access_key \
  -e AWS_SECRET_ACCESS_KEY=$TF_VAR_aws_secret_key \
  -e AWS_REGION=$TF_VAR_aws_region \
  -v ~/.aws:/root/.aws \
  -v $(pwd):/aws \
  -w /aws \
  $usetty digitalronin/aws-tf bash

