#!/bin/sh
PASSWORD=$(openssl rand -base64 32)
while ! collective join defaultServer \
    --host=controller \
    --port=9443 \
    --user=adminUser \
    --password=adminPassword \
    --autoAcceptCertificates \
    --keystorePassword=$PASSWORD \
    --createConfigFile=/wlp/usr/servers/defaultServer/collective-join-include.xml
do
    sleep 2
done

exec /wlp/bin/server run
