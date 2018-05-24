FROM debian:stable
MAINTAINER Camptocamp

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

COPY ./requirements.txt /
COPY ./patches /tmp/patches

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        openssh-server \
        patch \
        && \
    pip3 install -r /requirements.txt && \
    # https://github.com/OCA/odoo-sentinel/pull/10
    patch /usr/local/lib/python3.5/dist-packages/odoosentinel/__init__.py /tmp/patches/0001-Encode-text-to-the-system-s-preferred-encoding.patch && \
    # https://github.com/OCA/odoo-sentinel/pull/9
    patch /usr/local/lib/python3.5/dist-packages/odoosentinel/__init__.py /tmp/patches/0001-Fix-error-that-flood-sentinel-log.patch && \
    # https://github.com/OCA/odoo-sentinel/pull/3
    patch /usr/local/lib/python3.5/dist-packages/odoosentinel/__init__.py /tmp/patches/0001-FIX-Re-add-the-size-configuration-from-Odoo.patch && \
    rm -rf /tmp/patches && \
    apt-get clean && \
    apt-get remove --purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false python3-pip python3-setuptools python3-wheel patch && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    echo -e 'LANG=C.UTF-8\nLC_ALL=C.UTF-8' > /etc/default/locale

RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell $(which odoo-sentinel) scanneroperator \
    && mkdir /home/scanneroperator/.ssh \
    && chown -R scanneroperator: /home/scanneroperator/.ssh \
    # ignore locale of the ssh client (LANG + LC_*)
    && sed -i '/AcceptEnv LANG LC_*/s/^/#/' /etc/ssh/sshd_config

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
