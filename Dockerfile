FROM ruby:2.7-slim

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

# Update packages database
RUN apt-get update

RUN apt-get install -qq -y git-all build-essential

# Allow for timezone setting in _config.yml
RUN apt-get install -qq -y tzdata

# Installing imagemagick library
RUN apt-get install -qq -y pkg-config libmagick++-dev

# Installing gsl library for gsl
RUN apt-get install -qq -y libgsl-dev

# Installing atlas library for nmatrix
RUN apt-get install -qq -y libatlas-base-dev

# debug
RUN bundle version

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
