#!/bin/bash

BRANCH="${2:-master}"

if [ "$1" == "pull" ]; then
  echo "Pulling build cache..."
  gsutil cp -Jnr gs://refsheet-build-cache/* /cache/
else
  echo "Pushing build cache..."
  gsutil cp -Jnr /cache/* gs://refsheet-build-cache/
fi