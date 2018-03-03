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
	echo "rsync -avz --progress ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/database-backups/* ./site-backups/${DOMAIN}"
	mkdir -p ./${DOMAIN}
	rsync -avz --progress --delete ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/database-backups/* ./site-backups/${DOMAIN}
done
