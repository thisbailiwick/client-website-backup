# client-website-backup
Gather client backups of directory structure and databases from remote servers and upload to box.com.
Remote client files are created via `run_site.sh` and `run_db.sh` then after creation and syncing to local they are deleted on the clients remote server.


* **Some local paths have hardcoded parts**
	* Remote client directory structure:
		* /backup - Parent directory
			* /backup-run - Holds the files for the backup scripts on the client server.
			* /database-backups - Where the database backups are stored.
			* /site-backup - Where the site backup is stored.
* **Todo**
	* Allow default and optional configs for path variables
	* Some clients have no ssh access. Use rclone ftp capabilites to sync over files.
		* https://rclone.org/ftp/