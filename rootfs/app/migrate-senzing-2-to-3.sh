#!/usr/bin/env bash

echo "INFO: migrate-senzing-2-to-3.sh starting."
echo "INFO: Sleeping ${SENZING_SLEEP_TIME:-15} seconds."

sleep ${SENZING_SLEEP_TIME:-15}

echo "INFO: Updating database"

/opt/senzing/g2/bin/g2dbupgrade \
    -a \
    -c /etc/opt/senzing/G2Module.ini

echo "INFO: Updating Senzing configuration 2.0 to 2.5"

/opt/senzing/g2/python/G2ConfigTool.py \
    --histDisable \
    --force \
    -c /etc/opt/senzing/G2Module.ini \
    /opt/senzing/g2/resources/config/g2core-config-upgrade-2.0-to-2.5.gtc

echo "INFO: Updating Senzing configuration 2.5 to 3.0"

/opt/senzing/g2/python/G2ConfigTool.py \
    --histDisable \
    --force \
    -c /etc/opt/senzing/G2Module.ini \
    /opt/senzing/g2/resources/config/g2core-config-upgrade-2.5-to-3.0.gtc

echo "INFO: migrate-senzing-2-to-3.sh complete."
