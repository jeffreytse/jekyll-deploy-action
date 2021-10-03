#!/bin/bash

# Update packages database
pacman -Syu --noconfirm

# Installing git package
pacman -S --noconfirm git

# Installing ruby libraries
pacman -S --noconfirm ruby2.7 ruby-bundler

# Setting default ruby version
cp /usr/bin/ruby-2.7 /usr/bin/ruby

# debug
ruby -v && bundle version
