#!/bin/sh

now=$(date +"%T")

echo "Deploying Tomcat web apps: $now "

mkdir -p /usr/local/oneops/certs

if [ ! -e /usr/local/oneops/certs/oo.key ]; then
cd /usr/local/oneops/certs
dd if=/dev/urandom count=24 bs=1 | xxd -ps > oo.key
truncate -s -1 oo.key
chmod 400 oo.key
chown tomcat7:root oo.key
fi

cd /usr/local/tomcat7/webapps/

service tomcat7 stop

rm -rf *
wars=( adapter antenna cms-admin controller daq-api opamp sensor transistor transmitter )

for war in "${wars[@]}"
do
 cd $ONE_OPS_DISTR/oneops/dist/
 tar -xvf oneops-$war_package-"@".tar.gz
 cp $ONE_OPS_DISTR/oneops/dist/oneops/dist/$war_package* /usr/local/tomcat7/webapps/$war_package.war
done




cp $OO_HOME/tom_setenv.sh /usr/local/tomcat7/bin/setenv.sh
chown tomcat7:root /usr/local/tomcat7/bin/setenv.sh

mkdir -p /opt/oneops/controller/antenna/retry
mkdir -p /opt/oneops/opamp/antenna/retry
mkdir -p /opt/oneops/cms-publisher/antenna/retry
mkdir -p /opt/oneops/transmitter/antenna/retry
mkdir -p /opt/oneops/transmitter/search/retry
mkdir -p /opt/oneops/controller/search/retry
mkdir -p /opt/oneops/opamp/search/retry

service tomcat7 start

now=$(date +"%T")
echo "Done with Tomcat: $now "


