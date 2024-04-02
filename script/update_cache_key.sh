#!/usr/bin/env bash

CACHE_KEY_PATH=$HOME/cache.key

function sha1sumx() {
  if [[ -f "$1" ]]; then
    echo $(sha1sum "$1")>> $CACHE_KEY_PATH
  fi
}

sha1sumx $(find "${WORKING_DIR}" -not -path "**/.asdf/**" -iname '**Gemfile.lock')
sha1sumx ${HOME}/.tool-versions
