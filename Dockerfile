FROM ubuntu:20.04

ARG VERSION=1.4.0

ENV PARAMS="--usecache --quiet --grade --hostfile /urlfile.txt"
ENV INTERVAL="604800"
# Can be a pipe separated list for egrep "A+|A|B"
ENV ACCEPTED="A+"
ENV LANG=C.UTF-8

RUN    apt update \
    && apt -y upgrade \
    && apt -y install curl ca-certificates \
    && apt-get clean


COPY ./entrypoint.sh /entrypoint.sh

RUN    cd /tmp \
    && curl -sSLO https://github.com/ssllabs/ssllabs-scan/releases/download/v${VERSION}/ssllabs-scan_${VERSION}-linux64.tgz \
    && tar xzf ssllabs-scan_${VERSION}-linux64.tgz \
    && mv ./ssllabs-scan /ssllabs-scan \
    && chmod +x /ssllabs-scan \
    && rm -rf ssllabs-scan* \
    && mkdir -p /var/log/ssllabs/ \
    && chmod +x /entrypoint.sh

VOLUME ["/var/log/ssllabs"]

ENTRYPOINT ["/entrypoint.sh"]
