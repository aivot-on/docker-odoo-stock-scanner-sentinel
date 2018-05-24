#!/bin/bash

# force to xterm because of bogus terminal emulator clients
export TERM=xterm
exec odoo-sentinel
