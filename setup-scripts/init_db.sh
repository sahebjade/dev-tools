#!/bin/sh

echo "Initializing DB.."
source ./setenv.sh


cd $ONE_OPS_DISTR/oneops/dist
tar -xzvf oneops-db-schema-"$@".tar.gz

# Need to be fixed
cp $ONE_OPS_DISTR/oneops/dist/oneops/dist/single_db_schemas.sql /var/lib/pgsql/single_db_schemas.sql

cd /var/lib/pgsql
su postgres -c 'psql -f /var/lib/pgsql/single_db_schemas.sql'
cd $ONE_OPS_DISTR/dist/oneops/dist
./single_db_install.sh

#
now=$(date +"%T")
echo "Completed DB init : $now"


