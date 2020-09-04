FROM ubuntu:20.04

RUN set -xeu && \
    IFS=$'\n\t' && \
    export DEBIAN_FRONTEND=noninteractive && \
    export LANG="C.UTF-8" && \
    apt update && \
    apt upgrade -y && \
    apt install -y xsltproc && \
    apt autoremove -y && apt clean

ADD psalm-html-output.xsl /psalm-html-output.xsl

ENTRYPOINT ["xsltproc", "/psalm-html-output.xsl"]
CMD ["-"]
