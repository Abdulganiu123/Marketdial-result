#!/bin/bash

# Check if environment variables are set
if [ -z "$POSTGRES_DB" ] || [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ]; then
  echo "Error: POSTGRES_DB, POSTGRES_USER, and POSTGRES_PASSWORD environment variables must be set."
  exit 1
fi

# Create the store table in the specified database
echo "Creating table 'store' in database $POSTGRES_DB..."
export PGPASSWORD="$POSTGRES_PASSWORD"
psql -h database -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE TABLE IF NOT EXISTS store (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);"

echo "Table 'store' creation completed."
