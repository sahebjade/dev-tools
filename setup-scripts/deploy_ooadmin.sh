#!/bin/sh

echo "Deploying OneOps Admin "

gem install  $OO_HOME/dist/oneops/dist/oneops-admin-1.0.0.gem --no-ri --no-rdoc

mkdir -p /opt/oneops-admin
cd /opt/oneops-admin

export DISPLAY_LOCAL_STORE="/opt/oneops/public"
rm -fr circuit
circuit create
cd circuit
circuit init

cd "$BUILD_BASE"

cp -R /tmp/oneops_circuits/circuit-oneops-1 /home/oneops/build/


cd "$BUILD_BASE/circuit-oneops-1"
circuit install

echo "install inductor as ooadmin"
adduser ooadmin 2>/dev/null

cd /opt/oneops
chown ooadmin /opt/oneops
su ooadmin -c "
inductor create
cd inductor
# add inductor using shared queue
inductor add --mqhost localhost \
--dns on \
--debug on \
--daq_enabled true \
--collector_domain localhost \
--tunnel_metrics on \
--perf_collector_cert /etc/pki/tls/logstash/certs/logstash-forwarder.crt \
--ip_attribute public_ip \
--queue shared \
--mgmt_url http://localhost:9090 \
--logstash_cert_location /etc/pki/tls/logstash/certs/logstash-forwarder.crt \
--logstash_hosts vagrant.oo.com:5000 \
--max_consumers 10 \
--local_max_consumers 10 \
--authkey superuser:amqpass \
--amq_truststore_location /opt/oneops/inductor/lib/client.ts \
--additional_java_args \"\" \
--env_vars \"\"

mkdir -p /opt/oneops/inductor/lib
\cp /opt/activemq/conf/client.ts /opt/oneops/inductor/lib/client.ts
ln -sf /home/oneops/build/circuit-oneops-1 .
inductor start
"
inductor install_initd
chkconfig --add inductor
chkconfig inductor on
echo "export INDUCTOR_HOME=/opt/oneops/inductor" > /opt/oneops/inductor_env.sh
echo "export PATH=$PATH:/usr/local/bin" >> /opt/oneops/inductor_env.sh

echo "done with inductor"
