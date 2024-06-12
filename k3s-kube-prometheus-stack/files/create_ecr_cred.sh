#!/bin/bash
# KUBECTL='kubectl --dry-run=client'
KUBECTL='kubectl'

AWS_ACCOUNT_ID=955666616060
ENVIRONMENT=local # yes, typo
AWS_DEFAULT_REGION=ap-northeast-2

EXISTS=$($KUBECTL get secret "$ENVIRONMENT-aws-ecr" | tail -n 1 | cut -d ' ' -f 1)
if [ "$EXISTS" = "$ENVIRONMENT-aws-ecr-$AWS_DEFAULT_REGION" ]; then
  echo "Secret exists, deleting"
  $KUBECTL delete secrets "$ENVIRONMENT-aws-ecr"
fi

PASS=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
$KUBECTL create secret docker-registry $ENVIRONMENT-aws-ecr\
    --docker-server=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com \
    --docker-username=AWS \
    --docker-password=$PASS \
    --docker-email=infra@setu.co --namespace monitoring