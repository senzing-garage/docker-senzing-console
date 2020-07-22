#!/usr/bin/env bash

# Signal trapping.

handle_term()
{
   echo "signal received, sleep-infinity exiting."
   exit 0
}

trap 'handle_term' TERM

# =============================================================================
# Main
# =============================================================================

if [[ ( ! -z ${INSTALL_MYSQL_CLIENT} ) ]]; then
    echo "Installing mysql-client."

    apt-get update
    
    # Get and install extra client objects to use odbc with mysql
    wget https://dev.mysql.com/get/Downloads/Connector-ODBC/8.0/mysql-connector-odbc_8.0.20-1debian10_amd64.deb
    wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-common_8.0.20-1debian10_amd64.deb
    wget https://dev.mysql.com/get/Downloads/MySQL-8.0/libmysqlclient21_8.0.20-1debian10_amd64.deb
    
    apt install ./mysql-connector-odbc_8.0.20-1debian10_amd64.deb
    apt install ./mysql-common_8.0.20-1debian10_amd64.deb
    apt install ./libmysqlclient21_8.0.20-1debian10_amd64.deb
    
    # Modify odbcinst.ini for G2Database ODBC use with connection string 
    sed -i 's/\[MySQL ODBC 8.0 Unicode Driver\]/#\[MySQL ODBC 8.0 Unicode Driver\]\n\[MYSQL\]/' /etc/odbcinst.ini
    
    #Corresponding odbc.ini should look like, where Server, Database & Port should be modified
    #
    # [MYSQL]
    # Driver=MYSQL
    # Server=172.17.0.1
    # Database=G2
    # Port=3306
fi

echo "/app/sleep-infinitely.sh is sleeping infinitely."

# Sleep in a manner that allows "docker stop ..." to shutdown gracefully.

sleep infinity &
wait
