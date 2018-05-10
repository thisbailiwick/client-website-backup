#!/bin/bash
#make sure we're in the right directory
BASEDIRECTORY=$(dirname ./wr-backup/run_site.sh)
if [ -d "$BASEDIRECTORY" ]; then
  cd $BASEDIRECTORY
fi
SITES=(
    #add --split at the end of the path if backup file is split due to box.com upload limitations
    '$urltoserver::$ssh_username::/path/to/parent-directory-of-root-backup-directory/[---split]'
)

for domain in "${SITES[@]}"; do
	DOMAIN="${domain%%::*}"
	SPLIT=${domain#*---}
	DOMAIN="${domain%%::*}"
	USERNAME="${domain#*::}"
	USERNAME="${USERNAME%::*}"
	REMOTEPATH="${domain##*::}"
	REMOTEPATH="${REMOTEPATH%---*}"

	echo "${SPLIT}"
	echo "${DOMAIN}"
	echo "${USERNAME}"
	echo "${REMOTEPATH}"

	# ssh into remote client server and run site backup
  echo "php ${REMOTEPATH}backups/backup-run/site_backups.php"
	ssh ${USERNAME}@${DOMAIN} /bin/bash <<-EOF
    if [[ $REMOTEPATH = "" ]]
    then
      php ./backups/backup-run/site_backups.php
    else
      php ${REMOTEPATH}backups/backup-run/site_backups.php
    fi
	EOF
	wait

	# make the local dirs if necessary
	mkdir -p ./site-backups/${DOMAIN}

	# run the transfer from the clients server to local
	echo "rsync -avz --progress --remove-source-files --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/* ./site-backups/${DOMAIN}"
	rsync -avz --progress --remove-source-files --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/* ./site-backups/${DOMAIN}
done
