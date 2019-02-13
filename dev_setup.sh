#!/bin/bash
mkdir certs
cd certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout dev.key -out dev.crt
