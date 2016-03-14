#!/usr/bin/env bash

set -eu

# only branch latest and no pull requuest builds are deployed
if [[ "${TRAVIS_BRANCH}" == "latest" ]] && [[ "${TRAVIS_PULL_REQUEST}" == "false" ]] ; then
  docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
  docker push experimentalplatform/ubuntu:$TRAVIS_BRANCH

  if [[ ${TRIGGER:-false} == "true" ]]; then
    for project in platform-app-manager platform-central-gateway platform-configure platform-dnsmasq platform-dokku platform-frontend platform-hardware platform-hostapd platform-hostname-avahi platform-hostname-smb platform-monitoring platform-ptw platform-pulseaudio platform-skvs platform-smb platform-systemd-proxy; do
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
      sleep 5
    done
  fi
fi
