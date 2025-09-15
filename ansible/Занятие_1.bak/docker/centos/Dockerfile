FROM rockylinux:9.3
LABEL authors="kvl"

RUN dnf install -y epel-release
RUN dnf update -y && \
    dnf install -y procps-ng vim python3

ENTRYPOINT ["top", "-b"]