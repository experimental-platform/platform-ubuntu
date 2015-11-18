#!/usr/bin/env bash

set -eu

if [[ "$TRAVIS_BRANCH" == "latest" ]]; then
  docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
  docker push experimentalplatform/ubuntu:$TRAVIS_BRANCH

  if [[ ${TRIGGER:-false} == "true" ]]; then
    for project in platform-app-manager platform-central-gateway platform-configure platform-dokku platform-frontend platform-hostname-avahi platform-hostname-smb platform-monitoring platform-ptw platform-skvs platform-systemd-proxy platform-pulseaudio platform-hardware; do
      URL="https://api.travis-ci.org/repo/experimental-platform%2F${project}/requests"
      BODY="{ \"request\": {
        \"message\": \"Triggered by '$TRAVIS_REPO_SLUG'\",
        \"config\": {
          \"env\": {
            \"TRIGGER\": \"true\"
      }}}}"
      echo "URL: $URL"
      echo "BODY: $BODY"
      STATUSCODE=$(curl -s -i -X POST --output /dev/stderr --write-out "%{http_code}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -H "Travis-API-Version: 3" \
        -H "Authorization: token $TRAVIS_TOKEN" \
        -d "$BODY" \
        $URL)

      if test $STATUSCODE -ne 202; then
        exit 1
      fi

      echo "Triggered experimental-platform/$project"
    done
  fi
fi
