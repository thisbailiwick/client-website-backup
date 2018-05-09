#!/usr/bin/env bash
# make sure we're in the right directory
BASEDIRECTORY=$(dirname ./wr-backup/run_db.sh)
if [ -d "$BASEDIRECTORY" ]; then
  cd $BASEDIRECTORY
fi
SITES=(
    '$urltoserver::$ssh_username::/path/to/parent-directory-of-root-backup-directory'
)

YESTERDAY=`date +%d -d "yesterday"`

echo ${YESTERDAY}


for domain in "${SITES[@]}"; do
	DOMAIN="${domain%%::*}"
	USERNAME="${domain#*::}"
	USERNAME="${USERNAME%::*}"
	REMOTEPATH="${domain##*::}"
	echo remotepath ${REMOTEPATH}
	echo username ${USERNAME}

	#ssh into reomote client
	#create db backup
	ssh ${USERNAME}@${DOMAIN} /bin/bash <<-EOF
		php ./${REMOTEPATH}backups/backup-run/database_backups.php
	EOF
	wait

	#make the directories if need be
	mkdir -p ./site-backups/${DOMAIN}
	
	#transfer and delete db backup echo
	echo "rsync -avz --progress --remove-source-files ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/database-backups/* ./site-backups/${DOMAIN}"

	##transfer and delete db backup
	rsync -avz --progress --remove-source-files --delete ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/database-backups/* ./site-backups/${DOMAIN}
done
