FROM archlinux:base-devel

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

# Update packages database
RUN pacman -Syu --noconfirm

# Installing git package
RUN pacman -S --noconfirm git

# Installing ruby libraries
RUN pacman -S --noconfirm ruby2.7 ruby-bundler

# Setting default ruby version
RUN cp /usr/bin/ruby-2.7 /usr/bin/ruby

# debug
RUN ruby -v && bundle version

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
