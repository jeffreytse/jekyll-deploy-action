FROM ruby:2.7

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

# Update packages database
RUN apt-get update

# Installing git package
RUN apt-get install -qq -y git

# Allow for timezone setting in _config.yml
RUN apt-get install -qq -y tzdata

# Installing imagemagick library
RUN apt-get install -qq -y pkg-config libmagick++-dev

# Installing libvips library
RUN apt-get install -qq -y libvips-dev

# Installing gsl and atlas libraries
RUN apt-get install -qq -y libgsl-dev libatlas-base-dev

# debug
RUN bundle version

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
