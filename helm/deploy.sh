#!/bin/bash

set -eu

environment=${1}
shift

if [ ! -d "environment/${environment}" ]; then
  echo "$0: environment ${environment} not found. deployment to lower environments is automated through the azure devops pipeline for each service."
  exit 1
fi

context=unknown
namespace=default

case $environment in
prod)
    context=aks-ghost-admin
  ;;
*) ;;
esac

if [ "${context}" = "unknown" ]; then
  echo "$0: no known context for $environment"
  exit 1
fi

helm="helm --kube-context=${context} --namespace=${namespace}"
kubectl="kubectl --context=${context} --namespace=${namespace}"

if [ -z "$1" -o "$1" = "ghost" ]; then
      helm --kube-context=${context} --namespace=tools \
        upgrade --install \
        ghost ghost \
        -f ./environment/$environment/values-ghost.yaml
      exit 0
fi
