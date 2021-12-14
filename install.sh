#!/bin/bash

# create a CA private key
openssl genrsa -nodes -out root/root.key 2048

# generate root CA certificate
openssl req -x509 -new -nodes -key root/root.key -sha256 -days 1825 -out root/root.pem

# add to trusted certificates
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" root/root.pem

# add to firefox
mozPath="$HOME/Library/Application Support/Mozilla/Certificates"
mkdir -p "$mozPath"
cp root/root.pem "$mozPath/root.pem"

