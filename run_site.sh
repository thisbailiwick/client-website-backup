#!/bin/bash
#make sure we're in the right directory
cd $(dirname ./wr-backup/run_site.sh)
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

	if [[ $SPLIT = "split" ]]
	then
		# backup files are split into pieces due to box.com filesize limitation
		COUNTER=0
	 	while [  $COUNTER -lt 10	 ]; do
			echo "rsync -avz --progress --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/site_${COUNTER} /mnt/volume-sfo2-01/site-backups/${DOMAIN}/site_${COUNTER}"

			rsync -avz --progress --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/site_${COUNTER} /mnt/volume-sfo2-01/site-backups/${DOMAIN}/site_${COUNTER}.split
			if [ "$?" -eq "$COUNTER" ]
			then
				break
			fi
			echo $?
			let COUNTER=COUNTER+1
		done
	else
		# backup is one file
		echo one file
		echo "rsync -avz --progress --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/site-backup.tar.gz /mnt/volume-sfo2-01/site-backups/${DOMAIN}/${DOMAIN}-site-backup.tar.gz"
		rsync -avz --progress --timeout=10800 ${USERNAME}@${DOMAIN}:${REMOTEPATH}backups/site-backup/site-backup.tar.gz /mnt/volume-sfo2-01/site-backups/${DOMAIN}/${DOMAIN}-site-backup.tar.gz
	fi
done
