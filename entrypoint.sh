#!/bin/sh
set -e

# Get script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Initial default value
PROVIDER=${INPUT_PROVIDER:=github}
TOKEN=${INPUT_TOKEN}
ACTOR=${INPUT_ACTOR:=${GITHUB_ACTOR}}
REPOSITORY=${INPUT_REPOSITORY:=${GITHUB_REPOSITORY}}
BRANCH=${INPUT_BRANCH:=gh-pages}
JEKYLL_SRC=${INPUT_JEKYLL_SRC:=./}
JEKYLL_CFG=${INPUT_JEKYLL_CFG:=${JEKYLL_SRC}/_config.yml}

echo "Starting the Jekyll Deploy Action"

if [ -z "${TOKEN}" ]; then
  echo "Please set the TOKEN environment variable."
  exit 1
fi

echo "Starting bundle install"
bundle config path vendor/bundle
bundle install

echo "Starting jekyll build"
JEKYLL_ENV=production bundle exec jekyll build \
  -s ${JEKYLL_SRC} \
  -c ${JEKYLL_CFG} \
  -d build

cd build

# Check if deploy on the same repository branch
if [[ "${PROVIDER}" == "github" ]]; then
  source "${SCRIPT_DIR}/providers/github.sh"
else
  echo "${PROVIDER} is an unsupported provider."
  exit 1
fi

exit $?
