#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER hive;
	CREATE DATABASE hivemetastore;
	GRANT ALL PRIVILEGES ON DATABASE hivemetastore TO hive;
EOSQL
