FROM archlinux:base-devel

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
