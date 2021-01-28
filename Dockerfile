FROM ruby:2.7-alpine

LABEL version="0.0.1"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

RUN apk add --no-cache git build-base

# Allow for timezone setting in _config.yml
RUN apk add --update tzdata

# Installing imagemagick library
RUN apk add --update pkgconfig imagemagick imagemagick-dev imagemagick-libs

# debug
RUN bundle version

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
