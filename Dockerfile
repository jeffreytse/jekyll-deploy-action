FROM ubuntu:latest

LABEL version="0.0.1"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential && \
  apt-get install -y git && \
  apt-get install -y imagemagick && \
  apt-get install -y libmagickwand-dev && \
  apt-get install -y ruby && \
  apt-get install -y ruby-dev

RUN gem install rmagick
RUN gem install bundler

# debug
RUN bundle version

RUN apk add --no-cache git build-base
# Allow for timezone setting in _config.yml
RUN apk add --update tzdata

# Installing imagemagick and RMagick - required for jekyll_picture_tag
RUN apk add --update pkgconfig imagemagick imagemagick-dev imagemagick-libs

# debug
RUN bundle version

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
