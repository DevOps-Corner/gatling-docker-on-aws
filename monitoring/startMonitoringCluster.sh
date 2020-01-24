#!/usr/bin/env bash
set -e

function help_text {
    cat <<EOF
    Usage: $0 [ -cl|--ecs-cluster ECS_CLUSTER_NAME ] [ -r|--region AWS_REGION ] [ -p|--profile AWS_PROFILE] [-h]

        -cl, --ecs-cluster AWS_ECS_CLUSTER          (required) ECS Cluster to run on.
        -r, --region AWS_REGION                     (required) AWS region.
        -p, --profile AWS_PROFILE                   (optional) AWS profile used, default if omitted.
EOF
    exit 1
}

ECS_PROFILE=""

while [ $# -gt 0 ]; do
    arg=$1
    case $arg in
        -p|--profile)
            export AWS_DEFAULT_PROFILE="$2"
            ECS_PROFILE="--aws-profile $2"
            shift; shift;
        ;;
        -r|--region)
            export AWS_REGION="$2"
            shift; shift;
        ;;
        *)
            echo "ERROR: Unrecognised option: ${arg}"
            help_text
            exit 1
        ;;
    esac
done

ecs-cli compose up --cluster $AWS_ECS_CLUSTER --create-log-groups $ECS_PROFILE --region $AWS_REGION
