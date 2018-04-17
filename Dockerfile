FROM debian:stable
MAINTAINER Camptocamp

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

COPY ./requirements.txt /

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        openssh-server \
        && \
    pip3 install -r /requirements.txt && \
    apt-get clean && \
    apt-get remove --purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false python3-pip python3-setuptools python3-wheel && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd

RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell $(which odoo-sentinel) scanneroperator \
    && mkdir /home/scanneroperator/.ssh \
    && chown -R scanneroperator: /home/scanneroperator/.ssh

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
