#!/bin/bash
set -e

# Get script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
WORKING_DIR=${PWD}

# Initial default value
PROVIDER=${INPUT_PROVIDER:=github}
TOKEN=${INPUT_TOKEN}
SSH_PRIVATE_KEY=${INPUT_SSH_PRIVATE_KEY:=}
ACTOR=${INPUT_ACTOR}
REPOSITORY=${INPUT_REPOSITORY}
BRANCH=${INPUT_BRANCH}
RUBY_VER=${INPUT_RUBY_VER:=3.2.0}
BUNDLER_VER=${INPUT_BUNDLER_VER:=~>2.5.0}
JEKYLL_SRC=${INPUT_JEKYLL_SRC:=./}
JEKYLL_CFG=${INPUT_JEKYLL_CFG:=./_config.yml}
JEKYLL_BASEURL=${INPUT_JEKYLL_BASEURL:=}
PRE_BUILD_COMMANDS=${INPUT_PRE_BUILD_COMMANDS:=}

# Set default bundle path and cache
BUNDLE_PATH=${WORKING_DIR}/vendor/bundle

echo "Starting the Jekyll Deploy Action"

if [[ "${PROVIDER}" != "test" ]]; then
  # Check if the token or SSH private key is set
  if [[ -z "${TOKEN}" && -z "${SSH_PRIVATE_KEY}" ]]; then
    echo "Please set the TOKEN or SSH_PRIVATE_KEY environment variable."
    exit 1
  fi
fi

# Check parameters and assign default values
if [[ "${PROVIDER}" == "github" ]]; then
  : ${ACTOR:=${GITHUB_ACTOR}}
  : ${REPOSITORY:=${GITHUB_REPOSITORY}}
  : ${BRANCH:=gh-pages}

  # Check if repository is available
  if ! echo "${REPOSITORY}" | grep -Eq ".+/.+"; then
    echo "The repository ${REPOSITORY} doesn't match the pattern <author>/<repos>"
    exit 1
  fi

  # Fix Github API metadata warnings
  export JEKYLL_GITHUB_TOKEN=${TOKEN}
fi

# Initialize environment
echo "Initialize environment"
source ${SCRIPT_DIR}/script/init_environment.sh

cd ${JEKYLL_SRC}

# Check and execute pre_build_commands commands
if [[ ${PRE_BUILD_COMMANDS} ]]; then
  echo "Executing pre-build commands"
  eval "${PRE_BUILD_COMMANDS}"
fi

echo "Check bundler version from Gemfile.lock"
GEMFILE_LOCK_DIR="${PWD}"
while [[ "${GEMFILE_LOCK_DIR}" != "/" ]] &&
  [[ ! -f "${GEMFILE_LOCK_DIR}/Gemfile.lock" ]]; do
  GEMFILE_LOCK_DIR="$(dirname "${GEMFILE_LOCK_DIR}")"
done

if [[ -f "${GEMFILE_LOCK_DIR}/Gemfile.lock" ]]; then
  BUNDLER_VER="$( \
    grep -A 1 'BUNDLED WITH' "${GEMFILE_LOCK_DIR}/Gemfile.lock" | \
    tail -n 1 | xargs)"
  echo "Bundler version ${BUNDLER_VER} is required by your Gemfile.lock!"
fi

echo "Initial comptible bundler"
${SCRIPT_DIR}/script/cleanup_bundler.sh
gem install bundler -v "${BUNDLER_VER}"

CLEANUP_BUNDLER_CACHE_DONE=false

# Clean up bundler cache
cleanup_bundler_cache() {
  echo "Cleaning up incompatible bundler cache"
  rm -rf ${BUNDLE_PATH}
  mkdir -p ${BUNDLE_PATH}
  CLEANUP_BUNDLER_CACHE_DONE=true
}

# If the vendor/bundle folder is cached in a differnt OS (e.g. Ubuntu),
# it would cause `jekyll build` failed, we should clean up the uncompatible
# cache firstly.
OS_NAME_FILE=${BUNDLE_PATH}/os-name
os_name=$(cat /etc/os-release | grep '^NAME=')
os_name=${os_name:6:-1}

if [[ "$os_name" != "$(cat $OS_NAME_FILE 2>/dev/null)" ]]; then
  cleanup_bundler_cache
  echo $os_name > $OS_NAME_FILE
fi

echo "Starting bundle install"
bundle config cach_all true
bundle config path $BUNDLE_PATH
bundle install

# Pre-handle Jekyll baseurl
if [[ -n "${JEKYLL_BASEURL-}" ]]; then
  JEKYLL_BASEURL="--baseurl ${JEKYLL_BASEURL}"
fi

build_jekyll() {
  echo "Starting jekyll build"
  JEKYLL_ENV=production bundle exec jekyll build \
    ${JEKYLL_BASEURL} \
    -c ${JEKYLL_CFG} \
    -d ${WORKING_DIR}/build
}

build_jekyll || {
  $CLEANUP_BUNDLER_CACHE_DONE && exit -1
  echo "Rebuild all gems and try to build again"
  cleanup_bundler_cache
  bundle install
  build_jekyll
}

# Pre-handle SSH private key
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  echo "Pre-handle SSH private key file"
  SSH_PRIVATE_KEY_PATH=$(mktemp /tmp/ssh-priv-key.XXXXXX)
  echo "${SSH_PRIVATE_KEY}" > ${SSH_PRIVATE_KEY_PATH}
  # To prevent from permissions are too open issue, the key can be
  # only readable by self
  chmod 400 ${SSH_PRIVATE_KEY_PATH}
fi

cd ${WORKING_DIR}/build

# Check if deploy on the same repository branch
PROVIDER_EXIT_CODE=0
if [[ -f "${SCRIPT_DIR}/providers/${PROVIDER}.sh" ]]; then
  source "${SCRIPT_DIR}/providers/${PROVIDER}.sh"
else
  echo "${PROVIDER} is an unsupported provider."
  PROVIDER_EXIT_CODE=1
fi

# Post-handle SSH private key
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  echo "Post-handle SSH private key file"
  rm -f ${SSH_PRIVATE_KEY_PATH}
fi

# Update cache key
echo "Update cache key..."
source ${SCRIPT_DIR}/script/update_cache_key.sh

exit ${PROVIDER_EXIT_CODE}
