#!/bin/bash
domain="$1"

cat > conf.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $domain
DNS.2 = *.$domain
EOF

# create a certificate signing request for the domain
openssl req -new -nodes \
    -subj "/C=SE/O=Backtick Technologies AB/CN=$domain" \
    -keyout "./config/certs/$domain.key" \
    -out request.csr

# sign it
openssl x509 -req -days 825 -sha256 \
    -in request.csr \
    -CA ./root/backtick.pem -CAkey ./root/backtick.key \
    -CAcreateserial \
    -extfile conf.ext \
    -out ./config/certs/$domain.crt

# delete intermediate files
rm conf.ext request.csr

# add cert to traefik
echo "tls:" > ./config/domains/$domain.yml
echo "  certificates:" >> ./config/domains/$domain.yml
echo "    - certFile: /config/certs/$domain.crt" >> ./config/domains/$domain.yml
echo "      keyFile: /config/certs/$domain.key" >> ./config/domains/$domain.yml

