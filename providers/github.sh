#!/bin/sh
set -e

# Check if deploy to same branch
if [ "${REPOSITORY}" = "${GITHUB_REPOSITORY}" ]; then
  if [ "${GITHUB_REF}" = "refs/heads/${BRANCH}" ]; then
    echo "It's conflicted to deploy on same branch ${BRANCH}"
    exit 1
  fi
fi

# Tell GitHub Pages not to run Jekyll
touch .nojekyll
[ -n "$INPUT_CNAME" ] && echo "$INPUT_CNAME" > CNAME

echo "Deploying to ${REPOSITORY} on branch ${BRANCH}"
echo "Deploying to https://${ACTOR}:${TOKEN}@github.com/${REPOSITORY}.git"

REMOTE_REPO="https://${ACTOR}:${TOKEN}@github.com/${REPOSITORY}.git" && \
  git config --global http.postBuffer 524288000 && \
  git config --global init.defaultBranch main && \
  git init && \
  git config user.name "${ACTOR}" && \
  git config user.email "${ACTOR}@users.noreply.github.com" && \
  git add . && \
  git commit -m "jekyll build from Action ${GITHUB_SHA}" && \
  git push --force $REMOTE_REPO main:$BRANCH && \
  fuser -k .git || rm -rf .git && \
  cd ..

exit $?
