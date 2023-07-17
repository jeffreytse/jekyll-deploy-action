#!/bin/bash

# Update packages database
pacman -Syu --noconfirm

# Installing git package
pacman -S --noconfirm git

# Installing openssh package
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  pacman -S --noconfirm openssh
fi

# Installing ruby libraries
pacman -S --noconfirm ruby2.7 ruby-bundler

# Setting default ruby version
cp /usr/bin/ruby-2.7 /usr/bin/ruby

# debug
ruby -v && bundle version

# This is a temporary workaround
# See https://github.com/actions/checkout/issues/766
git config --global --add safe.directory "*"
