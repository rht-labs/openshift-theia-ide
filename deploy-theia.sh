#!/bin/bash
NAMESPACE=${1:-unknown}
GITHUB_TOKEN=${2:-unknown}
if [ "$NAMESPACE" == "unknown" ]; then
  printf "\n\033[1;35m Please specify a NAMESPACE as first argument ! Bye...\033[m\n\n" >&2 && exit 1
fi
if [ "$GITHUB_TOKEN" == "unknown" ]; then
  printf "\n\033[1;35m Please specify your GITHUB_TOKEN as second argument ! Bye...\033[m\n\n" >&2 && exit 1
fi
echo "using namesapce ${NAMESPACE}"
oc new-project ${NAMESPACE}
oc process -f openshift-templates/theia-template.yaml -p GITHUB_TOKEN=${GITHUB_TOKEN} | oc create -f-