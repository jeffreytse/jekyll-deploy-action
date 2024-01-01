FROM archlinux:base-devel

# Update the package repositories and install necessary packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm archlinux-keyring

# Cache the result of refreshing keys
RUN pacman-key --init \
    && pacman-key --populate archlinux \
    && pacman-key --refresh-keys

LABEL version="0.1.0"
LABEL repository="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL homepage="https://github.com/jeffreytse/jekyll-deploy-action"
LABEL maintainer="Jeffrey Tse <jeffreytse.mail@gmail.com>"

COPY LICENSE.txt README.md /

COPY script /script
COPY providers /providers
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
