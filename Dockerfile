FROM mcr.microsoft.com/azure-sql-edge:latest

USER root

# Create directory for initialization scripts
RUN mkdir -p /usr/config

# Copy SQL files and initialization script
COPY db /usr/config/db

# Switch back to the mssql user
USER mssql

# Start SQL Server and run the initialization script
# CMD /bin/bash -c "/opt/mssql/bin/sqlservr & /usr/config/init-db.sh"