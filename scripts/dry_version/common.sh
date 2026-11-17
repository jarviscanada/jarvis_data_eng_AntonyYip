#!/bin/bash

validate_arguments() {
    if [ "$#" -ne 5 ]; then
        echo "Illegal number of parameters" >&2
        return 1
    fi
}

setup_psql() {
    psql_host=$1
    psql_port=$2
    db_name=$3
    psql_user=$4
    export PGPASSWORD="$5"
}

get_hostname() {
    hostname -f
}

get_timestamp() {
    vmstat -t | awk '{print $18, $19}' | tail -n1 | xargs
}

execute_sql() {
    psql -h "$psql_host" \
         -p "$psql_port" \
         -d "$db_name" \
         -U "$psql_user" \
         -c "$1"
}

