#!/bin/bash -e

run_if_yes () {
  cmd=$1
  echo -n "$cmd [Y/n]? "
  read response
  case $response in
    Y|y)
      eval $cmd
    ;;
    *)
     echo "skipping"
    ;;
  esac
}

# Remove buckets
for bucket in $(aws s3api list-buckets --query 'Buckets[?contains(Name, `'$environment'`) == `true`].Name' --output text); do
  if [ $(aws s3api get-bucket-tagging --bucket $bucket --query 'TagSet[?Key == `Environment`].Value' --output text) == $environment ]; then
    cmd="aws s3 rb --force s3://$bucket"
    run_if_yes "$cmd"
  fi
done

# Tear down the stack
stack=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE DELETE_FAILED \
  --query 'StackSummaries[].StackId' --output table | grep ${environment}-buckets-${AWS_DEFAULT_REGION} \
  | awk '{print $2}')

cmd="aws cloudformation delete-stack --stack-name $stack"
run_if_yes "$cmd"
