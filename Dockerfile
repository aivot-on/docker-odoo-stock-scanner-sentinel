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
COPY ./shell.sh  /opt/odoo
RUN adduser --home /home/scanneroperator --disabled-login --gecos "" --shell /opt/odoo/shell.sh scanneroperator

COPY .odoo_sentinelrc /home/scanneroperator
COPY authorized_keys /home/scanneroperator/.ssh/
RUN chown -R scanneroperator:scanneroperator /home/scanneroperator/.ssh && \
    chmod 640 /home/scanneroperator/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
