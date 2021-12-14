#!/bin/bash
openssl req \
    -x509 \
    -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -subj "/C=SE/O=Backtick/CN=localhost" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=DNS:*.localhost,DNS:*.local")) \
    -keyout cert/cert.key \
    -out cert/cert.crt

