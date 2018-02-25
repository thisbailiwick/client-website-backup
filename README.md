# client-website-backup
Gather client backups of directory structure and databases from remote servers and upload to box.com


* **Some local paths have hardcoded parts**
	* Remote client directory structure:
		* /backup - Parent directory
			* /backup-run - Holds the files for the backup scripts on the client server.
			* /database-backups - Where the database backups are stored.
			* /site-backup - Where the site backup is stored.
* Use
* **Todo**
	* Allow default and optional configs for path variables
	* Instead of separate script for site backups where the backup is larger than 5gb's; do a size check after initial tar and then split. (there is an example (and it's in use for one client) now, but leaving for more testing due to below)
		* The above may not actually be possible do to ram/storage limitations.
		* Possible to get a value from 'du'?
			* http://manpages.ubuntu.com/manpages/xenial/man1/du.1.html
	* Some clients have no ssh access. Use rclone ftp capabilites to sync over files.
		* https://rclone.org/ftp/