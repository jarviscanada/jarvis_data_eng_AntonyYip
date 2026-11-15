#!/bin/bash

# Load shared functions
source "$(dirname "$0")/common.sh"

# Validate arguments and configure PostgreSQL connection
validate_arguments "$@" 
setup_psql "$@"

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
hostname=$(get_hostname) 

memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(df -BM /dev/sda2 | awk '{print $4}' | tail -n1 | sed 's/M$//' | xargs)

timestamp=$(get_timestamp)

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

insert_stmt="INSERT INTO PUBLIC.host_usage (
    \"timestamp\",
    host_id,
    memory_free,
    cpu_idle,
    cpu_kernel,
    disk_io,
    disk_available
)
VALUES (
    '$timestamp',
    $host_id,
    '$memory_free',
    '$cpu_idle',
    '$cpu_kernel',
    '$disk_io',
    '$disk_available'
)"

execute_sql "$insert_stmt"
exit $?

