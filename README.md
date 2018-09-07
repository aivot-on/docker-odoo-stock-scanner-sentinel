[![Build Status](https://travis-ci.org/camptocamp/docker-odoo-stock-scanner-sentinel.svg?branch=master)](https://travis-ci.org/camptocamp/docker-odoo-stock-scanner-sentinel)

# Docker Image for Odoo Stock Scanner Sentinel

This image is meant to be used with the Odoo addon: `stock_scanner` in the OCA repository https://github.com/OCA/stock-logistics-barcode.

It provides a running sentinel over ssh, allowing the hardware to use the scenarii (https://github.com/OCA/stock-logistics-barcode/tree/10.0/stock_scanner#for-the-sentinelpy-client).

The image is published on the official Docker registry in https://hub.docker.com/r/camptocamp/odoo-stock-scanner-sentinel/.

Latest:
```
docker pull camptocamp/odoo-stock-scanner-sentinel:11.0-latest
docker pull camptocamp/odoo-stock-scanner-sentinel:10.0-latest
docker pull camptocamp/odoo-stock-scanner-sentinel:9.0-latest
```

Versioned, for version 9.0, 10.0 or 11.0 of Odoo:
```
docker pull camptocamp/odoo-stock-scanner-sentinel:11.0-x-y
docker pull camptocamp/odoo-stock-scanner-sentinel:10.0-x-y
docker pull camptocamp/odoo-stock-scanner-sentinel:9.0-x-y
```
Where `x` is the version of the
[odoo-sentinel](https://pypi.python.org/pypi/odoo-sentinel) library, `y` is an
increment starting from 1 and incremented when the image is rebuilt for the
same library version, `x-y` corresponds to a GitHub tag on the project.

List of images: https://hub.docker.com/r/camptocamp/odoo-stock-scanner-sentinel/tags/

At this point, the images for 9.0, 10.0 and 11.0 are the same.


## Configuration

All the environment variables below are required but the port which has a default value.

| Environment variable          | Description                                                                       |
|-------------------------------|-----------------------------------------------------------------------------------|
| `SCANNER_SSH_AUTHORIZED_KEYS` | Multiline, content of the authorized_keys file used for the scanneroperator user. |
| `SCANNER_PROTOCOL`            | Protocol to connect jsonrpc (default) or jsonrpc+ssl                              |
| `SCANNER_HOST`                | Odoo Host                                                                         |
| `SCANNER_PORT`                | Odoo Port, default: 8069                                                          |
| `SCANNER_DB`                  | Name of Odoo database                                                             |
| `SCANNER_USER`                | Odoo user used by the sentinel                                                    |
| `SCANNER_PASSWORD`            | Password for the user                                                             |
| `SCANNER_TIMEOUT`             | Timeout                                                             |

The container publishes the stock scanner sentinel over SSH with the user
`scanneroperator`, on the port 22.

Example with Docker:

```
docker run -it --rm -p 2222:22 -e SCANNER_HOST=localhost -e SCANNER_PORT=80 -e SCANNER_DB=odoodb -e SCANNER_USER=admin -e SCANNER_PASSWORD=admin -e SCANNER_SSH_AUTHORIZED_KEYS='ssh-rsa AAAAxxxxxxxw== scanneroperator' camptocamp/odoo-stock-scanner-sentinel:10.0-latest
```

Example with docker-compose:

```
version: '2'

services:
  scannersentinel:
    image: camptocamp/odoo-stock-scanner-sentinel:10.0-latest
    ports:
      - 2222:22
    environment:
      SCANNER_USER: scanneroperator
      SCANNER_PASSWORD: test
      SCANNER_DB: odoodb
      SCANNER_HOST: odoohost
      SCANNER_PORT: 8069
      SCANNER_SSH_AUTHORIZED_KEYS: -|
        ssh-rsa AAAAxxxxxxxw== scanneroperator
        ssh-rsa AAAAyyyyyyyw== scanneroperator2
```

You can test the connection with:
```
ssh -p 2222 scanneroperator@localhost
```

You should see the ncurses client.

## Release new image

To release an updated image:

* If the `odoo-sentinel` library has a new version, change the version in
  `requirements.txt` and add a tag `x-1` (for instance 1.1-1 if the new
  `odoo-sentinel` version is 1.1)
* If you need a new build and the `odoo-sentinel` version did not change, add
  a tag by incrementing the last digit of the last release (for instance
  (`1.0-2` if the previous one was `1.0-1`)

When the tag is pushed, Travis will build the new image and push it on
https://hub.docker.com/r/camptocamp/odoo-stock-scanner-sentinel/
