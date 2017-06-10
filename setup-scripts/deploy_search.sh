#!/bin/sh
source setenv.sh
now=$(date +"%T")
echo "Deploying Search consumer: $now "

export OO_HOME=/home/oneops

mkdir -p /opt/oneops-search
mkdir -p /opt/oneops-search/log

service search-consumer stop
cd $ONE_OPS_DISTR/oneops/dist/
tar -xvf oneops-search-"$@".tar.gz
cp $ONE_OPS_DISTR/oneops/dist/oneops/dist/search*.jar /opt/oneops-search
cp $ONE_OPS_DISTR/start-consumer.sh /opt/oneops-search


service search-consumer start

now=$(date +"%T")
echo "Done with search-consumer: $now "


