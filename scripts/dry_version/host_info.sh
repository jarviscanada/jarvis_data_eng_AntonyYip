#!/bin/bash

# Load shared functions
source "$(dirname "$0")/common.sh"

# Validate arguments and configure PostgreSQL connection
validate_arguments "$@" 
setup_psql "$@"

# Save the host name
hostname=$(get_hostname) 

# Execute lscpu and store its output in the lscpu_out variable.
lscpu_out=$(lscpu) 

cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "^Model name:" | awk -F ':' '{print $2}' | xargs)
cpu_mhz=$(echo "$cpu_model" | awk -F '@ ' '{print $2}' | sed 's/GHz//' | awk '{print $1 * 1000}')
l2_cache=$(echo "$lscpu_out"  | egrep "^L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')

timestamp=$(get_timestamp)

insert_stmt="INSERT INTO PUBLIC.host_info (
    hostname,
    cpu_number,
    cpu_architecture,
    cpu_model,
    cpu_mhz,
    l2_cache,
    \"timestamp\",
    total_mem
)
VALUES (
    '$hostname',
    '$cpu_number',
    '$cpu_architecture',
    '$cpu_model',
    '$cpu_mhz',
    '$l2_cache',
    '$timestamp',
    '$total_mem'
)"

execute_sql "$insert_stmt"
exit $?

