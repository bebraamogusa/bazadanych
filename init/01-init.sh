#!/bin/bash
set -e

# Enable local_infile for this session to allow LOAD DATA INFILE
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SET GLOBAL local_infile = 1;"

echo "==================================="
echo "1. Creating schema and tables..."
echo "==================================="
mysql --default-character-set=utf8mb4 -u root -p"${MYSQL_ROOT_PASSWORD}" < "/import_danych/nawigacja_gwiezdna.sql" || { echo "Schema import failed!"; exit 1; }

echo "==================================="
echo "2. Importing CSV data..."
echo "==================================="
mysql --default-character-set=utf8mb4 --local-infile=1 -u root -p"${MYSQL_ROOT_PASSWORD}" nawigacja_gwiezdna < "/import_danych/import_docker.sql" || { echo "Data import failed!"; exit 1; }

echo "==================================="
echo "Database initialization completed."
echo "==================================="
