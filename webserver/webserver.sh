#!/bin/bash

PASSWORD=$(openssl rand -hex 16)

# Create an SSL Self Signed Certificate
gskcmd -keydb -create -db /selfsigned.kdb -stash -pw $PASSWORD
gskcmd -cert \
    -create \
    -db /selfsigned.kdb \
    -label default \
    -size 2048 \
    -dn "CN=localhost, O=Trajano, C=CA" \
    -default_cert yes \
    -expire 365 \
    -sig_alg SHA512_WITH_RSA \
    -stashed

while ! dynamicRouting genKeystore \
    --host=controller \
    --user=adminUser \
    --password=adminPassword \
    --port=9443 \
    --keystorePassword=$PASSWORD \
    --autoAcceptCertificates
do
  sleep 1
done

gskcmd -keydb -convert \
  -db /plugin-key.jks \
  -pw $PASSWORD \
  -new_format cms \
  -stash
gskcmd -cert -setdefault \
  -label default \
  -db /plugin-key.kdb \
  -stashed

. /opt/IBM/HTTPServer/bin/envvars
exec /opt/IBM/HTTPServer/bin/httpd -d /opt/IBM/HTTPServer -DFOREGROUND
