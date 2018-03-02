FROM debian:stable
MAINTAINER Camptocamp

COPY ./requirements.txt /

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python \
        python-pip \
        python-setuptools \
        python-wheel \
        openssh-server \
        && \
    pip install -r /requirements.txt && \
    apt-get clean && \
    apt-get remove --purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false python-pip python-setuptools python-wheel && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd

RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell $(which odoo-sentinel) scanneroperator \
    && mkdir /home/scanneroperator/.ssh \
    && chown -R scanneroperator: /home/scanneroperator/.ssh

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
