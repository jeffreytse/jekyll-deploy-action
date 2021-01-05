FROM ubuntu:lates

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

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
