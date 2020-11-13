#!/bin/bash

CACHE_BUCKET="gs://refsheet-build-cache"
BRANCH="${2:-master}"

echo "Forcing artifacts..."
mkdir -p /artifacts
echo "BRANCH=$BRANCH" > /artifacts/LAST_BUILD

if [ "$1" == "pull" ]; then
  echo "Finding cache..."
  if gsutil ls "$CACHE_BUCKET/cache-$BRANCH.tar.gz" > /dev/null; then
    gsutil -m cp -Jr "$CACHE_BUCKET/cache-$BRANCH.tar.gz" cache.tar.gz
  elif gsutil ls "$CACHE_BUCKET/cache-master.tar.gz" > /dev/null; then
    gsutil -m cp -Jr "$CACHE_BUCKET/cache-master.tar.gz" cache.tar.gz
  else
    echo "No cache found."
    exit 0
  fi

  echo "Extracting cache..."
  tar -xzf cache.tar.gz -C /cache
else
  echo "Creating cache archive..."
  opwd=$(pwd)
  cd /cache || exit 0
  tar -czf "$opwd/cache.tar.gz" .
  cd "$opwd" || exit 0

  echo "Uploading archive..."
  gsutil -m cp -Jr cache.tar.gz "gs://refsheet-build-cache/cache-$BRANCH.tar.gz"
fi

rm -f cache.tar.gz
