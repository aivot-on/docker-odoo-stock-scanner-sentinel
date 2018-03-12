#!/bin/bash -e

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD"

  if [ "$TRAVIS_BRANCH" == "master" ]; then
    tag=latest
  elif [ ! -z "$TRAVIS_TAG" ]; then
    tag="${TRAVIS_TAG}"
  elif [ ! -z "$TRAVIS_BRANCH" ]; then
    tag="${TRAVIS_BRANCH}"
  else
    echo "Not pushing image"
    exit 0
  fi

  echo "Pushing image to docker hub ${DOCKER_HUB_REPO}:${tag}"
  docker tag odoo-stock-scanner-sentinel "camptocamp/odoo-stock-scanner-sentinel:9.0-${tag}"
  docker tag odoo-stock-scanner-sentinel "camptocamp/odoo-stock-scanner-sentinel:10.0-${tag}"
  docker tag odoo-stock-scanner-sentinel "camptocamp/odoo-stock-scanner-sentinel:11.0-${tag}"
  docker push "camptocamp/odoo-stock-scanner-sentinel:9.0-${tag}"
  docker push "camptocamp/odoo-stock-scanner-sentinel:10.0-${tag}"
  docker push "camptocamp/odoo-stock-scanner-sentinel:11.0-${tag}"

fi
