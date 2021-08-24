#!/bin/bash -x

# Used to download helm charts

repo=$(echo "${HELM_REPO}" | sed 's,https://,https://${HELM_REPO_PASSWORD}@,g')
echo "repo is $repo"
GIT_SSL_NO_VERIFY=true git clone $repo "${setpath}/repo"
pwd
ls -la
cd "${setpath}/repo/charts"
pwd
ls -la