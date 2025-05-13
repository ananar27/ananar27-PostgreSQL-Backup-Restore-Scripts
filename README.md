# 🧪 DevOps Training Task — PostgreSQL Backup & Restore Scripts

## Table of Contents
1. [Context](#️-contextContext)
2. [DB backup script](#-script-1-db_backupsh)
3. [DB restore script](#-script-2-db_restoresh)
4. [License](#license)

## 🗂️ Context
You are tasked with writing two Bash scripts to automate the backup and restore process for a PostgreSQL database named testdb. The scripts will be executed on a Linux server with PostgreSQL preinstalled.

## ✅ Script #1: db_backup.sh
### Goal:
Automatically create backups of the testdb database and manage their lifecycle.

### Script logic:

- Check if the database is running
- Run a simple SQL query to determine if the database is active.
- Check if the backup directory /opt/backups exists
- If there are no existing backups, create a new one using pg_dump in custom format (.pgdmp).
- If an existing backup is older than 3 days, create a new backup and remove old ones.
- Check if a backup is currently running
- Re-check that the database is running after backup

## ✅ Script #2: db_restore.sh
### Goal:
Restore the most recent backup of the testdb database.

## Script logic:

- Find the most recent backup file
- Locate the latest .pgdmp file from /opt/backups that is less than 3 days old.
- Recreate the database
- Restore the backup
- Use pg_restore to import the backup into the new database.
- Run vacuumdb
- Verify that the database is running after the restore

## License

This repository is licensed under the [CC BY-NC 4.0 License](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to read, copy, modify, and share this content for **non-commercial** and educational purposes only, provided proper attribution. Commercial use is **not** permitted without explicit permission.
