#!/bin/sh
PASSWORD=$(openssl rand -base64 32)
collective create defaultServer \
    --keystorePassword=$PASSWORD \
    --createConfigFile=/wlp/usr/servers/defaultServer/collective-create-include.xml
sed -i 's#<variable .*/>#<variable name="defaultHostName" value="controller" />#' /wlp/usr/servers/defaultServer/collective-create-include.xml
sed -i 's#<quickStartSecurity .*/>#<quickStartSecurity userName="adminUser" userPassword="adminPassword"/>#' /wlp/usr/servers/defaultServer/collective-create-include.xml

exec /wlp/bin/server run
