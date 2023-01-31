#!/usr/bin/env bash

set -euE

BRANCH_NAME="${DEPLOY_BRANCH:=main}"
REPO_URL="${DEPLOY_REPO:=https://github.com/fleetyards/ExFleetYards}"
USER="${DEPLOY_USER:=fleetyards-api}"
RELEASES_TO_KEEP="${RELEASES_TO_KEEP:=5}"
ENVIRONMENT="${DEPLOY_ENV:=staging}"

HOME=/home/$USER
RELEASES_DIR=$HOME/releases
DEPLOYMENT_TIME=$(date +"%Y%m%d%H%M%S")
DEPLOY_TO=$RELEASES_DIR/$DEPLOYMENT_TIME
CONFIG_PATH=$HOME/config.exs

function prepare() {
  echo "-> Prepare Deployment"
  if [ -f "$HOME/CURRENT_RELEASE" ]; then
    mv "$HOME/CURRENT_RELEASE" "$HOME/PREVIOUS_RELEASE"
  fi

  echo "$DEPLOYMENT_TIME" >> "$HOME/CURRENT_RELEASE"
}

function run() {
  echo "-> Start Deployment"
  echo "--> Checkout Source into $DEPLOY_TO"

  git clone --branch "$BRANCH_NAME" "$REPO_URL" "$DEPLOY_TO"

  pushd "$DEPLOY_TO" > /dev/null

  echo "--> Get deps"

  MIX_ENV=$ENVIRONMENT mix deps.get --only "$ENVIRONMENT"

  echo "--> Creating new Release"

  MIX_ENV=$ENVIRONMENT mix release

  echo "--> Running pending migrations"

  MIX_ENV=$ENVIRONMENT FLEETYARDS_CONFIG_PATH=$CONFIG_PATH "$DEPLOY_TO/_build/$ENVIRONMENT/rel/api/bin/api" eval "ExFleetYards.Release.Tasks.run(\"migrate\")"

  popd > /dev/null

  echo "--> Symlink release to current"

  ln -sfT "$DEPLOY_TO" "$HOME/current"

  echo "--> Clean up old releases"

  pushd "$RELEASES_DIR" > /dev/null

  ls -t "$RELEASES_DIR" | tail -n +$(("$RELEASES_TO_KEEP" + 1)) | xargs rm -rf

  popd > /dev/null

  echo "--> Restart Service"

  sudo service fleetyards-api-main restart
}

function cleanup() {
  if [ -f "$HOME/PREVIOUS_RELEASE" ]; then
    echo "--> Reverting deployment"

    ln -sfT "$HOME/$(cat "$HOME/PREVIOUS_RELEASE")" "$HOME/current"

    mv "$HOME/PREVIOUS_RELEASE" "$HOME/CURRENT_RELEASE"
  fi

  if [ -f "$DEPLOY_TO" ]; then
    rm -rf "$DEPLOY_TO"
  fi

  echo "-> Deployment failed"
}

trap 'cleanup' ERR

prepare

run

echo "-> Deployment finished"
