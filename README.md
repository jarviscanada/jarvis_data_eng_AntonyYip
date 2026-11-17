# Linux cluster monitoring agent

## Introduction
The linux monitoring cluster agent project is a tool which will regularly capture the real time cluster usage data and save the records to the database for future reference.

## Architecture and design
![Architecture Diagram](assets/architecture.png)

## Quick Start
List of the script files and purposes
- `psql_docker.sh`: Create or start the postgreSQL and the related docker instance
- `ddl.sql`: Create tables the `host_info` and `host_usage`
- `host_info.sh`: Grep and insert the hardware specs information into the table `host_info`
- `host_usage.sh`: Grep and insert the hardware usage data into the table `host_usage`
- `Crontab`: Setup the schedule job in every minutes and start the docker and postgreSQL instance after restart the machine
