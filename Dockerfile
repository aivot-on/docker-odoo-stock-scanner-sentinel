FROM debian:stable
MAINTAINER Camptocamp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python-pip \
        python-setuptools \
        python-wheel \
        openssh-server && \
    apt-get clean && \
    rm -rf /va/lob/apt/lists/* && \
    pip install "openobject-library<2" && \
    mkdir /opt/odoo && \
    apt-get remove --purge -y python-pip python-setuptools python-wheel && \
    mkdir /var/run/sshd

COPY ./hardware/ /opt/odoo/hardware
COPY ./shell.sh /opt/odoo
RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell /opt/odoo/shell.sh scanneroperator \
    && mkdir /home/scanneroperator/.ssh \
    && chown -R scanneroperator: /home/scanneroperator/.ssh

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
