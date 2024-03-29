#!/bin/bash
set -e

# Check if deploy to same branch
if [[ "${REPOSITORY}" = "${GITHUB_REPOSITORY}" ]]; then
  if [[ "${GITHUB_REF}" = "refs/heads/${BRANCH}" ]]; then
    echo "It's conflicted to deploy on same branch ${BRANCH}"
    exit 1
  fi
fi

# Tell GitHub Pages not to run Jekyll
touch .nojekyll
[[ -n "$INPUT_CNAME" ]] && echo "$INPUT_CNAME" > CNAME

# Prefer to use SSH approach when SSH private key is provided
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  export GIT_SSH_COMMAND="ssh -i ${SSH_PRIVATE_KEY_PATH} \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null"
  REMOTE_REPO="git@github.com:${REPOSITORY}.git"
else
  REMOTE_REPO="https://${ACTOR}:${TOKEN}@github.com/${REPOSITORY}.git"
fi

echo "Deploying to ${REPOSITORY} on branch ${BRANCH}"
echo "Deploying to ${REMOTE_REPO}"

git config --global init.defaultBranch main && \
  git config --global http.postBuffer 524288000 && \
  git init && \
  git config user.name "${ACTOR}" && \
  git config user.email "${ACTOR}@users.noreply.github.com" && \
  git add . && \
  git commit -m "jekyll build from Action ${GITHUB_SHA}" && \
  git push --force $REMOTE_REPO main:$BRANCH && \
  (fuser -k .git || rm -rf .git) && \
  cd ..

PROVIDER_EXIT_CODE=$?
