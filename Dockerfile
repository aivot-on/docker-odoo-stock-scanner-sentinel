FROM debian:stable
MAINTAINER Camptocamp

COPY ./hardware/ /opt/odoo/hardware
COPY ./shell.sh /opt/odoo

RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell /opt/odoo/shell.sh scanneroperator \
    && mkdir /home/scanneroperator/.ssh \
    && chown -R scanneroperator: /home/scanneroperator/.ssh

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python-pip \
        python-setuptools \
        python-wheel \
        openssh-server \
        gettext \
        && \
    apt-get clean && \
    rm -rf /va/lob/apt/lists/* && \
    pip install "openobject-library<2" && \
    cd /opt/odoo/hardware/i18n/ && \
    ./translate.sh compile fr && \
    ./translate.sh compile en && \
    apt-get remove --purge -y python-pip python-setuptools python-wheel gettext && \
    mkdir /var/run/sshd

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
