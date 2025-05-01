FROM alpine:latest

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

RUN apk update && apk add --no-cache bash perl gcc make musl-dev zlib-dev openssl-dev g++ linux-headers

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
