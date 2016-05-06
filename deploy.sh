#!/usr/bin/env bash

set -eu

./build-ubuntu.sh
./s3-upload.sh put experimentalplatform-ubuntu-${TRAVIS_BRANCH}.aci ubuntu-${TRAVIS_BUILD_NUMBER}.aci
./s3-upload.sh copy ubuntu-${TRAVIS_BUILD_NUMBER}.aci ubuntu-${TRAVIS_BRANCH}.aci
